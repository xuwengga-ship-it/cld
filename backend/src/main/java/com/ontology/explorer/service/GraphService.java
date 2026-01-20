package com.ontology.explorer.service;

import com.ontology.explorer.dto.*;
import com.ontology.explorer.model.*;
import com.ontology.explorer.repository.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class GraphService {

    @Autowired
    private EntityInstanceRepository entityRepository;

    @Autowired
    private RelationshipRepository relationshipRepository;

    @Autowired
    private OntologyTypeRepository ontologyTypeRepository;

    @Autowired
    private RelationTypeRepository relationTypeRepository;

    @Autowired
    private OntologyActionRepository ontologyActionRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Transactional(readOnly = true)
    public GraphDataDTO getGraphData(List<Long> entityIds, LocalDateTime timePoint) {
        List<EntityInstance> entities;
        List<Relationship> relationships;

        if (entityIds == null || entityIds.isEmpty()) {
            entities = entityRepository.findAll();
            if (timePoint != null) {
                relationships = relationshipRepository.findAll().stream()
                    .filter(r -> isValidAtTime(r, timePoint))
                    .collect(Collectors.toList());
            } else {
                relationships = relationshipRepository.findAll();
            }
        } else {
            entities = entityRepository.findAllById(entityIds);
            if (timePoint != null) {
                relationships = relationshipRepository.findByEntityIdsAtTime(entityIds, timePoint);
            } else {
                relationships = relationshipRepository.findByEntityIds(entityIds);
            }
        }

        return buildGraphData(entities, relationships);
    }

    @Transactional(readOnly = true)
    public GraphDataDTO peripheralSearch(PeripheralSearchRequest request) {
        Set<Long> visitedEntityIds = new HashSet<>();
        Set<Long> currentLevelIds = new HashSet<>(request.getEntityIds());
        Set<Relationship> allRelationships = new HashSet<>();
        int maxDepth = request.getDepth() != null ? request.getDepth() : 1;

        for (int depth = 0; depth < maxDepth; depth++) {
            if (currentLevelIds.isEmpty()) break;

            visitedEntityIds.addAll(currentLevelIds);
            List<Relationship> relationships;

            if (request.getTimePoint() != null) {
                relationships = relationshipRepository.findByEntityIdsAtTime(
                    new ArrayList<>(currentLevelIds),
                    request.getTimePoint()
                );
            } else {
                relationships = relationshipRepository.findByEntityIds(new ArrayList<>(currentLevelIds));
            }

            if (request.getRelationTypeIds() != null && !request.getRelationTypeIds().isEmpty()) {
                relationships = relationships.stream()
                    .filter(r -> request.getRelationTypeIds().contains(r.getRelationType().getId()))
                    .collect(Collectors.toList());
            }

            allRelationships.addAll(relationships);

            Set<Long> nextLevelIds = new HashSet<>();
            for (Relationship rel : relationships) {
                if (!visitedEntityIds.contains(rel.getTargetEntity().getId())) {
                    nextLevelIds.add(rel.getTargetEntity().getId());
                }
                if (!visitedEntityIds.contains(rel.getSourceEntity().getId())) {
                    nextLevelIds.add(rel.getSourceEntity().getId());
                }
            }
            currentLevelIds = nextLevelIds;
        }

        List<EntityInstance> entities = entityRepository.findAllById(visitedEntityIds);
        return buildGraphData(entities, new ArrayList<>(allRelationships));
    }

    @Transactional(readOnly = true)
    @Cacheable(value = "relationType", key = "#ontologyTypeId")
    public List<RelationType> getRelationTypesForOntologyType(Long ontologyTypeId) {
        return relationTypeRepository.findRelationsByOntologyType(ontologyTypeId);
    }

    @Transactional(readOnly = true)
    public List<OntologyAction> getActionsForOntologyType(Long ontologyTypeId) {
        return ontologyActionRepository.findByOntologyTypeId(ontologyTypeId);
    }

    @Transactional
    public EntityInstance createEntity(EntityCreateRequest request) {
        OntologyType ontologyType = ontologyTypeRepository.findById(request.getOntologyTypeId())
            .orElseThrow(() -> new RuntimeException("Ontology type not found"));

        EntityInstance entity = new EntityInstance();
        entity.setName(request.getName());
        entity.setDescription(request.getDescription());
        entity.setOntologyType(ontologyType);

        try {
            entity.setProperties(objectMapper.writeValueAsString(request.getProperties()));
        } catch (Exception e) {
            entity.setProperties("{}");
        }

        return entityRepository.save(entity);
    }

    @Transactional(readOnly = true)
    public List<EntityInstance> getEntitiesByType(Long ontologyTypeId) {
        return entityRepository.findByOntologyTypeId(ontologyTypeId);
    }

    @Transactional(readOnly = true)
    public EntityInstance getEntityById(Long entityId) {
        return entityRepository.findById(entityId)
            .orElseThrow(() -> new RuntimeException("Entity not found"));
    }

    private GraphDataDTO buildGraphData(List<EntityInstance> entities, List<Relationship> relationships) {
        List<GraphNodeDTO> nodes = entities.stream()
            .map(this::entityToNode)
            .collect(Collectors.toList());

        List<GraphEdgeDTO> edges = relationships.stream()
            .map(this::relationshipToEdge)
            .collect(Collectors.toList());

        return new GraphDataDTO(nodes, edges);
    }

    private GraphNodeDTO entityToNode(EntityInstance entity) {
        GraphNodeDTO node = new GraphNodeDTO();
        node.setId("entity_" + entity.getId());
        node.setLabel(entity.getName());
        node.setType(entity.getOntologyType().getName());
        node.setOntologyTypeId(entity.getOntologyType().getId().toString());
        node.setIcon(entity.getOntologyType().getIcon());
        node.setColor(entity.getOntologyType().getColor());

        try {
            if (entity.getProperties() != null) {
                Map<String, Object> props = objectMapper.readValue(
                    entity.getProperties(),
                    objectMapper.getTypeFactory().constructMapType(Map.class, String.class, Object.class)
                );
                node.setProperties(props);
            }
        } catch (Exception e) {
            node.setProperties(new HashMap<>());
        }

        return node;
    }

    private GraphEdgeDTO relationshipToEdge(Relationship relationship) {
        GraphEdgeDTO edge = new GraphEdgeDTO();
        edge.setId("rel_" + relationship.getId());
        edge.setSource("entity_" + relationship.getSourceEntity().getId());
        edge.setTarget("entity_" + relationship.getTargetEntity().getId());
        edge.setLabel(relationship.getRelationType().getName());
        edge.setType(relationship.getRelationType().getName());
        edge.setColor(relationship.getRelationType().getColor());

        try {
            if (relationship.getProperties() != null) {
                Map<String, Object> props = objectMapper.readValue(
                    relationship.getProperties(),
                    objectMapper.getTypeFactory().constructMapType(Map.class, String.class, Object.class)
                );
                edge.setProperties(props);
            }
        } catch (Exception e) {
            edge.setProperties(new HashMap<>());
        }

        return edge;
    }

    private boolean isValidAtTime(Relationship relationship, LocalDateTime timePoint) {
        if (timePoint == null) return true;

        LocalDateTime validFrom = relationship.getValidFrom();
        LocalDateTime validTo = relationship.getValidTo();

        boolean afterStart = validFrom == null || !timePoint.isBefore(validFrom);
        boolean beforeEnd = validTo == null || !timePoint.isAfter(validTo);

        return afterStart && beforeEnd;
    }
}
