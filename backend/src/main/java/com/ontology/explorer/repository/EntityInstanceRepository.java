package com.ontology.explorer.repository;

import com.ontology.explorer.model.EntityInstance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EntityInstanceRepository extends JpaRepository<EntityInstance, Long> {
    List<EntityInstance> findByOntologyTypeId(Long ontologyTypeId);

    @Query("SELECT e FROM EntityInstance e WHERE e.name LIKE %:keyword%")
    List<EntityInstance> searchByName(@Param("keyword") String keyword);
}
