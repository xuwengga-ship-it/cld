package com.ontology.explorer.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "ontology_type")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OntologyType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String icon;

    private String color;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "ontologyType", cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<EntityInstance> instances = new ArrayList<>();

    @OneToMany(mappedBy = "sourceType")
    private List<RelationType> outgoingRelations = new ArrayList<>();

    @OneToMany(mappedBy = "targetType")
    private List<RelationType> incomingRelations = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
