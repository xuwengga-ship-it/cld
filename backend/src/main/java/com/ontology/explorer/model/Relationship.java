package com.ontology.explorer.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "relationship")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Relationship {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "source_entity_id", nullable = false)
    private EntityInstance sourceEntity;

    @ManyToOne
    @JoinColumn(name = "target_entity_id", nullable = false)
    private EntityInstance targetEntity;

    @ManyToOne
    @JoinColumn(name = "relation_type_id", nullable = false)
    private RelationType relationType;

    @Column(columnDefinition = "TEXT")
    private String properties;

    @Column(name = "valid_from")
    private LocalDateTime validFrom;

    @Column(name = "valid_to")
    private LocalDateTime validTo;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (validFrom == null) {
            validFrom = LocalDateTime.now();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
