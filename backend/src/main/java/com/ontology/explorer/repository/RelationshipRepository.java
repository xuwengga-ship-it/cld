package com.ontology.explorer.repository;

import com.ontology.explorer.model.Relationship;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface RelationshipRepository extends JpaRepository<Relationship, Long> {

    @Query("SELECT r FROM Relationship r WHERE r.sourceEntity.id = :entityId OR r.targetEntity.id = :entityId")
    List<Relationship> findByEntityId(@Param("entityId") Long entityId);

    @Query("SELECT r FROM Relationship r WHERE r.sourceEntity.id IN :entityIds OR r.targetEntity.id IN :entityIds")
    List<Relationship> findByEntityIds(@Param("entityIds") List<Long> entityIds);

    @Query("SELECT r FROM Relationship r WHERE (r.sourceEntity.id = :entityId OR r.targetEntity.id = :entityId) " +
           "AND (r.validFrom IS NULL OR r.validFrom <= :timePoint) " +
           "AND (r.validTo IS NULL OR r.validTo >= :timePoint)")
    List<Relationship> findByEntityIdAtTime(@Param("entityId") Long entityId, @Param("timePoint") LocalDateTime timePoint);

    @Query("SELECT r FROM Relationship r WHERE (r.sourceEntity.id IN :entityIds OR r.targetEntity.id IN :entityIds) " +
           "AND (r.validFrom IS NULL OR r.validFrom <= :timePoint) " +
           "AND (r.validTo IS NULL OR r.validTo >= :timePoint)")
    List<Relationship> findByEntityIdsAtTime(@Param("entityIds") List<Long> entityIds, @Param("timePoint") LocalDateTime timePoint);
}
