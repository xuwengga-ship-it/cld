-- Graph Ontology Explorer Database Schema
-- Execute this script manually to initialize the database

-- Drop tables if exist (for fresh start)
DROP TABLE IF EXISTS relationship;
DROP TABLE IF EXISTS ontology_action;
DROP TABLE IF EXISTS entity_instance;
DROP TABLE IF EXISTS relation_type;
DROP TABLE IF EXISTS ontology_type;

-- Ontology Type table
CREATE TABLE ontology_type (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(255),
    color VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Entity Instance table
CREATE TABLE entity_instance (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    ontology_type_id BIGINT NOT NULL,
    properties TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ontology_type_id) REFERENCES ontology_type(id) ON DELETE CASCADE,
    INDEX idx_ontology_type (ontology_type_id),
    INDEX idx_name (name)
);

-- Relation Type table
CREATE TABLE relation_type (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    source_type_id BIGINT NOT NULL,
    target_type_id BIGINT NOT NULL,
    color VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (source_type_id) REFERENCES ontology_type(id) ON DELETE CASCADE,
    FOREIGN KEY (target_type_id) REFERENCES ontology_type(id) ON DELETE CASCADE,
    INDEX idx_source_type (source_type_id),
    INDEX idx_target_type (target_type_id)
);

-- Relationship table (time-series support)
CREATE TABLE relationship (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    source_entity_id BIGINT NOT NULL,
    target_entity_id BIGINT NOT NULL,
    relation_type_id BIGINT NOT NULL,
    properties TEXT,
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_to TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (source_entity_id) REFERENCES entity_instance(id) ON DELETE CASCADE,
    FOREIGN KEY (target_entity_id) REFERENCES entity_instance(id) ON DELETE CASCADE,
    FOREIGN KEY (relation_type_id) REFERENCES relation_type(id) ON DELETE CASCADE,
    INDEX idx_source_entity (source_entity_id),
    INDEX idx_target_entity (target_entity_id),
    INDEX idx_relation_type (relation_type_id),
    INDEX idx_valid_from (valid_from),
    INDEX idx_valid_to (valid_to)
);

-- Ontology Action table
CREATE TABLE ontology_action (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    ontology_type_id BIGINT NOT NULL,
    icon VARCHAR(255),
    action_type VARCHAR(100),
    config TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ontology_type_id) REFERENCES ontology_type(id) ON DELETE CASCADE,
    INDEX idx_ontology_type (ontology_type_id)
);
