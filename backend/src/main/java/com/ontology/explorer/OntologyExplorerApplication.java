package com.ontology.explorer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class OntologyExplorerApplication {
    public static void main(String[] args) {
        SpringApplication.run(OntologyExplorerApplication.class, args);
    }
}
