# Backend - Graph Ontology Explorer

Spring Boot 3.x backend for the Graph Ontology Explorer system.

## Architecture

### Layers

1. **Controller Layer** - REST API endpoints
2. **Service Layer** - Business logic
3. **Repository Layer** - Data access
4. **Model Layer** - Entity definitions

### Key Components

#### Models
- **OntologyType** - Defines types of entities (公司, 供应商, etc.)
- **EntityInstance** - Individual entity instances
- **RelationType** - Defines relationship types between ontology types
- **Relationship** - Actual relationships between entities with time-series support
- **OntologyAction** - Actions associated with ontology types

#### Services
- **GraphService** - Graph operations, peripheral search, time-series queries
- **OntologyService** - Ontology type management

#### Controllers
- **GraphController** - Graph data and operations API
- **OntologyController** - Ontology management API

## API Endpoints

### Graph APIs

#### GET /api/graph/data
Get graph data with optional filters.

**Query Parameters:**
- `entityIds` (optional): List of entity IDs
- `timePoint` (optional): ISO datetime for time-series query

**Response:**
```json
{
  "nodes": [
    {
      "id": "entity_1",
      "label": "海王集团股份有限公司",
      "type": "公司",
      "ontologyTypeId": "1",
      "color": "#1890FF",
      "properties": {...}
    }
  ],
  "edges": [
    {
      "id": "rel_1",
      "source": "entity_1",
      "target": "entity_2",
      "label": "拥有",
      "color": "#1890FF",
      "properties": {...}
    }
  ]
}
```

#### POST /api/graph/peripheral-search
Perform peripheral search from selected entities.

**Request Body:**
```json
{
  "entityIds": [1, 2],
  "relationTypeIds": [1, 2],
  "depth": 2,
  "timePoint": "2024-01-01T00:00:00"
}
```

**Response:** Same as GET /api/graph/data

#### GET /api/graph/relation-types/{ontologyTypeId}
Get available relation types for an ontology type.

**Response:**
```json
[
  {
    "id": 1,
    "name": "拥有",
    "description": "公司拥有子公司",
    "sourceType": {...},
    "targetType": {...},
    "color": "#1890FF"
  }
]
```

#### GET /api/graph/actions/{ontologyTypeId}
Get available actions for an ontology type.

**Response:**
```json
[
  {
    "id": 1,
    "name": "查看详情",
    "description": "查看公司详细信息",
    "icon": "info-circle",
    "actionType": "view",
    "config": "{\"url\":\"/company/detail\"}"
  }
]
```

#### POST /api/graph/entity
Create a new entity instance.

**Request Body:**
```json
{
  "name": "新公司",
  "description": "公司描述",
  "ontologyTypeId": 1,
  "properties": {
    "address": "北京市",
    "phone": "123456789"
  }
}
```

#### GET /api/graph/entities/{ontologyTypeId}
Get all entities of a specific type.

#### GET /api/graph/entity/{entityId}
Get entity details by ID.

### Ontology APIs

#### GET /api/ontology/types
Get all ontology types.

#### GET /api/ontology/types/{id}
Get ontology type by ID.

#### POST /api/ontology/types
Create a new ontology type.

## Configuration

### Application Properties

See `src/main/resources/application.yml` for full configuration.

Key configurations:
```yaml
spring:
  datasource:
    url: ${DB_URL:jdbc:h2:mem:ontology}
    username: ${DB_USERNAME:sa}
    password: ${DB_PASSWORD:}

  redis:
    host: ${REDIS_HOST:localhost}
    port: ${REDIS_PORT:6379}

  jpa:
    hibernate:
      ddl-auto: ${JPA_DDL_AUTO:update}

app:
  cache:
    ttl: 3600
  graph:
    max-depth: 5
```

### Environment Variables

- `DB_URL` - Database JDBC URL
- `DB_USERNAME` - Database username
- `DB_PASSWORD` - Database password
- `DB_DRIVER` - Database driver class
- `REDIS_HOST` - Redis host
- `REDIS_PORT` - Redis port
- `REDIS_PASSWORD` - Redis password
- `JPA_DDL_AUTO` - Hibernate DDL auto mode
- `SERVER_PORT` - Server port (default: 8080)

## Database

### Schema

Execute SQL scripts in order:
1. `sql/01_init_schema.sql` - Create schema
2. `sql/02_sample_data.sql` - Load sample data

### H2 Console (Development)

Access H2 console at: `http://localhost:8080/api/h2-console`

- JDBC URL: `jdbc:h2:mem:ontology`
- Username: `sa`
- Password: (empty)

### MySQL (Production)

1. Create database:
```sql
CREATE DATABASE ontology_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Update `application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ontology_db
    username: your_username
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
```

3. Execute SQL scripts:
```bash
mysql -u username -p ontology_db < sql/01_init_schema.sql
mysql -u username -p ontology_db < sql/02_sample_data.sql
```

## Running

### Development Mode
```bash
mvn spring-boot:run
```

### Production Mode
```bash
mvn clean package
java -jar target/graph-ontology-explorer-1.0.0.jar
```

### With Custom Configuration
```bash
java -jar target/graph-ontology-explorer-1.0.0.jar \
  --spring.datasource.url=jdbc:mysql://localhost:3306/ontology_db \
  --spring.datasource.username=root \
  --spring.datasource.password=password
```

## Testing

```bash
mvn test
```

## Caching

Redis is used for caching:
- Ontology types (cache key: `ontologyTypes`)
- Relation types (cache key: `relationType:{typeId}`)

Cache TTL is configurable via `app.cache.ttl` (default: 3600 seconds).

## Time-Series Support

The `relationship` table supports time-series queries:

- `valid_from` - Relationship start time
- `valid_to` - Relationship end time (NULL = currently valid)

Query relationships at specific time:
```java
relationshipRepository.findByEntityIdsAtTime(entityIds, timePoint);
```

## Building

### Build JAR
```bash
mvn clean package
```

### Skip Tests
```bash
mvn clean package -DskipTests
```

### Run Specific Profile
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=prod
```

## Deployment

### Standalone JAR
```bash
java -jar target/graph-ontology-explorer-1.0.0.jar
```

### As System Service (Linux)
Create `/etc/systemd/system/ontology-explorer.service`:
```ini
[Unit]
Description=Graph Ontology Explorer
After=syslog.target

[Service]
User=ontology
ExecStart=/usr/bin/java -jar /opt/ontology-explorer/graph-ontology-explorer-1.0.0.jar
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable ontology-explorer
sudo systemctl start ontology-explorer
```

## Monitoring

Access actuator endpoints (if enabled):
- Health: `http://localhost:8080/api/actuator/health`
- Metrics: `http://localhost:8080/api/actuator/metrics`
- Info: `http://localhost:8080/api/actuator/info`
