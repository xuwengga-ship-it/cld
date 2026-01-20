package com.ontology.explorer.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EntityCreateRequest {
    private String name;
    private String description;
    private Long ontologyTypeId;
    private Map<String, Object> properties;
}
