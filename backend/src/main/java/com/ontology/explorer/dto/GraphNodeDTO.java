package com.ontology.explorer.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GraphNodeDTO {
    private String id;
    private String label;
    private String type;
    private String ontologyTypeId;
    private String icon;
    private String color;
    private Map<String, Object> properties;
    private Integer x;
    private Integer y;
}
