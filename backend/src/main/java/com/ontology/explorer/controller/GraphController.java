package com.ontology.explorer.controller;

import com.ontology.explorer.dto.*;
import com.ontology.explorer.model.EntityInstance;
import com.ontology.explorer.model.OntologyAction;
import com.ontology.explorer.model.RelationType;
import com.ontology.explorer.service.GraphService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/graph")
@CrossOrigin(origins = "*")
public class GraphController {

    @Autowired
    private GraphService graphService;

    @GetMapping("/data")
    public ResponseEntity<GraphDataDTO> getGraphData(
            @RequestParam(required = false) List<Long> entityIds,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime timePoint) {
        GraphDataDTO data = graphService.getGraphData(entityIds, timePoint);
        return ResponseEntity.ok(data);
    }

    @PostMapping("/peripheral-search")
    public ResponseEntity<GraphDataDTO> peripheralSearch(@RequestBody PeripheralSearchRequest request) {
        GraphDataDTO data = graphService.peripheralSearch(request);
        return ResponseEntity.ok(data);
    }

    @GetMapping("/relation-types/{ontologyTypeId}")
    public ResponseEntity<List<RelationType>> getRelationTypes(@PathVariable Long ontologyTypeId) {
        List<RelationType> relationTypes = graphService.getRelationTypesForOntologyType(ontologyTypeId);
        return ResponseEntity.ok(relationTypes);
    }

    @GetMapping("/actions/{ontologyTypeId}")
    public ResponseEntity<List<OntologyAction>> getActions(@PathVariable Long ontologyTypeId) {
        List<OntologyAction> actions = graphService.getActionsForOntologyType(ontologyTypeId);
        return ResponseEntity.ok(actions);
    }

    @PostMapping("/entity")
    public ResponseEntity<EntityInstance> createEntity(@RequestBody EntityCreateRequest request) {
        EntityInstance entity = graphService.createEntity(request);
        return ResponseEntity.ok(entity);
    }

    @GetMapping("/entities/{ontologyTypeId}")
    public ResponseEntity<List<EntityInstance>> getEntitiesByType(@PathVariable Long ontologyTypeId) {
        List<EntityInstance> entities = graphService.getEntitiesByType(ontologyTypeId);
        return ResponseEntity.ok(entities);
    }

    @GetMapping("/entity/{entityId}")
    public ResponseEntity<EntityInstance> getEntityById(@PathVariable Long entityId) {
        EntityInstance entity = graphService.getEntityById(entityId);
        return ResponseEntity.ok(entity);
    }
}
