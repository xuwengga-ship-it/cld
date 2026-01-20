package com.ontology.explorer.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GraphEdgeDTO {
    private String id;
    private String source;
    private String target;
    private String label;
    private String type;
    private String color;
    private Map<String, Object> properties;
}
