package com.ontology.explorer.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PeripheralSearchRequest {
    private List<Long> entityIds;
    private List<Long> relationTypeIds;
    private Integer depth;
    private LocalDateTime timePoint;
}
