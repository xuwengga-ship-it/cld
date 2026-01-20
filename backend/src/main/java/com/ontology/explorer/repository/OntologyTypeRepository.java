package com.ontology.explorer.repository;

import com.ontology.explorer.model.OntologyType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OntologyTypeRepository extends JpaRepository<OntologyType, Long> {
    Optional<OntologyType> findByName(String name);
}
