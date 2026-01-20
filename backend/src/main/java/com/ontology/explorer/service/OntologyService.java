package com.ontology.explorer.service;

import com.ontology.explorer.model.OntologyType;
import com.ontology.explorer.repository.OntologyTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class OntologyService {

    @Autowired
    private OntologyTypeRepository ontologyTypeRepository;

    @Transactional(readOnly = true)
    @Cacheable(value = "ontologyTypes")
    public List<OntologyType> getAllOntologyTypes() {
        return ontologyTypeRepository.findAll();
    }

    @Transactional(readOnly = true)
    public OntologyType getOntologyTypeById(Long id) {
        return ontologyTypeRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Ontology type not found"));
    }

    @Transactional
    public OntologyType createOntologyType(OntologyType ontologyType) {
        return ontologyTypeRepository.save(ontologyType);
    }
}
