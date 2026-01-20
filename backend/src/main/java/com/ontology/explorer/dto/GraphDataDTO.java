package com.ontology.explorer.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GraphDataDTO {
    private List<GraphNodeDTO> nodes;
    private List<GraphEdgeDTO> edges;
}
