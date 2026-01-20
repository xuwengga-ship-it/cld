package com.ontology.explorer.repository;

import com.ontology.explorer.model.OntologyAction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OntologyActionRepository extends JpaRepository<OntologyAction, Long> {
    List<OntologyAction> findByOntologyTypeId(Long ontologyTypeId);
}
