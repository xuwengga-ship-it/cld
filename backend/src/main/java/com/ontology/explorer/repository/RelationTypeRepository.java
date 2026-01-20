package com.ontology.explorer.repository;

import com.ontology.explorer.model.RelationType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RelationTypeRepository extends JpaRepository<RelationType, Long> {
    @Query("SELECT DISTINCT rt FROM RelationType rt WHERE rt.sourceType.id = :typeId OR rt.targetType.id = :typeId")
    List<RelationType> findRelationsByOntologyType(@Param("typeId") Long typeId);

    @Query("SELECT DISTINCT rt FROM RelationType rt WHERE rt.sourceType.id = :sourceTypeId AND rt.targetType.id = :targetTypeId")
    List<RelationType> findBySourceAndTargetType(@Param("sourceTypeId") Long sourceTypeId, @Param("targetTypeId") Long targetTypeId);
}
