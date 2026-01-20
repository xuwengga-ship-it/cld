package com.ontology.explorer.controller;

import com.ontology.explorer.model.OntologyType;
import com.ontology.explorer.service.OntologyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ontology")
@CrossOrigin(origins = "*")
public class OntologyController {

    @Autowired
    private OntologyService ontologyService;

    @GetMapping("/types")
    public ResponseEntity<List<OntologyType>> getAllOntologyTypes() {
        List<OntologyType> types = ontologyService.getAllOntologyTypes();
        return ResponseEntity.ok(types);
    }

    @GetMapping("/types/{id}")
    public ResponseEntity<OntologyType> getOntologyTypeById(@PathVariable Long id) {
        OntologyType type = ontologyService.getOntologyTypeById(id);
        return ResponseEntity.ok(type);
    }

    @PostMapping("/types")
    public ResponseEntity<OntologyType> createOntologyType(@RequestBody OntologyType ontologyType) {
        OntologyType created = ontologyService.createOntologyType(ontologyType);
        return ResponseEntity.ok(created);
    }
}
