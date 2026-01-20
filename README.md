# Graph Ontology Explorer (本体管理系统)

A graph-based ontology exploration system inspired by Palantir Vertex, built with Spring Boot 3.x backend and Vue 3 frontend with AntV X6 graph visualization.

![System Architecture](https://img.shields.io/badge/Backend-Spring_Boot_3.x-green)
![Frontend](https://img.shields.io/badge/Frontend-Vue_3-blue)
![Graph](https://img.shields.io/badge/Graph-AntV_X6-orange)
![Database](https://img.shields.io/badge/Database-MySQL/H2-yellow)

## Features

### 1. Graph Visualization (图谱可视化)
- **AntV X6** powered interactive canvas
- Drag-and-drop nodes
- Auto-layout with Dagre algorithm
- Zoom and pan controls
- Multi-select support

### 2. Peripheral Search (周边搜索)
- Click on object types to trigger peripheral search
- Select related object types from dropdown
- Load connected entities to graph with auto-layout
- Configurable search depth (1-5 levels)
- Filter by relationship types

### 3. Entity Detail Panel (对象属性面板)
- Left-click on entity instance to view properties
- Display all entity attributes in left panel
- Real-time data loading

### 4. Timeline Feature (时间轴功能)
- Time-series relationship data support
- Drag timeline to refresh canvas data
- Preset time nodes (today, month, year, all)
- Historical and future relationship queries

### 5. Ontology Actions (本体动作)
- Click action button on selected entity
- Popup shows ontology-related actions
- Configurable action types per ontology

### 6. Add Objects (新增对象)
- Show ontology object instance popup
- Support multi-select entities
- Add multiple entities to canvas at once
- Auto-layout after adding

## Technology Stack

### Backend
- **Spring Boot 3.2.1** - Core framework
- **Spring Data JPA** - Data persistence
- **MySQL** - Production database
- **H2** - Development database
- **Redis** - Caching layer
- **Maven** - Build tool

### Frontend
- **Vue 3** - UI framework
- **AntV X6** - Graph visualization
- **Element Plus** - UI components
- **ECharts** - Charts (optional)
- **Axios** - HTTP client
- **Vite** - Build tool

## Project Structure

```
graph-ontology-explorer/
├── backend/                    # Spring Boot backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/ontology/explorer/
│   │   │   │   ├── config/           # Configuration classes
│   │   │   │   ├── controller/       # REST API controllers
│   │   │   │   ├── service/          # Business logic
│   │   │   │   ├── repository/       # Data access layer
│   │   │   │   ├── model/            # Entity models
│   │   │   │   └── dto/              # Data transfer objects
│   │   │   └── resources/
│   │   │       └── application.yml   # Application configuration
│   ├── sql/                   # SQL scripts
│   │   ├── 01_init_schema.sql
│   │   ├── 02_sample_data.sql
│   │   └── README.md
│   └── pom.xml
├── frontend/                  # Vue 3 frontend
│   ├── src/
│   │   ├── api/              # API clients
│   │   ├── components/       # Vue components
│   │   ├── views/            # Page views
│   │   ├── router/           # Vue router
│   │   ├── utils/            # Utilities
│   │   ├── App.vue           # Root component
│   │   └── main.js           # Entry point
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
└── README.md
```

## Quick Start

### Prerequisites
- Java 17 or higher
- Node.js 16 or higher
- Maven 3.6+
- MySQL 8.0+ (optional, H2 is used by default)
- Redis (optional)

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Configure database (optional, uses H2 by default):
Edit `src/main/resources/application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ontology_db
    username: your_username
    password: your_password
```

3. Build and run:
```bash
mvn clean install
mvn spring-boot:run
```

Backend will start at: `http://localhost:8080`

4. Execute SQL scripts (optional for sample data):
```bash
# If using MySQL, execute the scripts in sql/ directory
mysql -u username -p database_name < sql/01_init_schema.sql
mysql -u username -p database_name < sql/02_sample_data.sql
```

### Frontend Setup

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Run development server:
```bash
npm run dev
```

Frontend will start at: `http://localhost:3000`

4. Build for production:
```bash
npm run build
```

## API Documentation

### Ontology APIs

#### Get All Ontology Types
```
GET /api/ontology/types
```

#### Get Ontology Type by ID
```
GET /api/ontology/types/{id}
```

#### Create Ontology Type
```
POST /api/ontology/types
Body: {
  "name": "公司",
  "description": "企业法人实体",
  "icon": "building",
  "color": "#1890FF"
}
```

### Graph APIs

#### Get Graph Data
```
GET /api/graph/data?entityIds=1,2,3&timePoint=2024-01-01T00:00:00
```

#### Peripheral Search
```
POST /api/graph/peripheral-search
Body: {
  "entityIds": [1, 2],
  "relationTypeIds": [1, 2],
  "depth": 2,
  "timePoint": "2024-01-01T00:00:00"
}
```

#### Get Relation Types for Ontology Type
```
GET /api/graph/relation-types/{ontologyTypeId}
```

#### Get Actions for Ontology Type
```
GET /api/graph/actions/{ontologyTypeId}
```

#### Create Entity
```
POST /api/graph/entity
Body: {
  "name": "新公司",
  "description": "公司描述",
  "ontologyTypeId": 1,
  "properties": {
    "address": "北京市",
    "phone": "123456789"
  }
}
```

#### Get Entities by Type
```
GET /api/graph/entities/{ontologyTypeId}
```

#### Get Entity by ID
```
GET /api/graph/entity/{entityId}
```

## Database Schema

### Tables

1. **ontology_type** - Ontology type definitions
2. **entity_instance** - Entity instances
3. **relation_type** - Relationship type definitions
4. **relationship** - Entity relationships with time-series support
5. **ontology_action** - Actions associated with ontology types

See `backend/sql/01_init_schema.sql` for complete schema.

## Configuration

### Database Configuration
Configure in `backend/src/main/resources/application.yml`:
```yaml
spring:
  datasource:
    url: ${DB_URL:jdbc:h2:mem:ontology}
    username: ${DB_USERNAME:sa}
    password: ${DB_PASSWORD:}
```

Or use environment variables:
- `DB_URL`
- `DB_USERNAME`
- `DB_PASSWORD`
- `DB_DRIVER`

### Redis Configuration
```yaml
spring:
  redis:
    host: ${REDIS_HOST:localhost}
    port: ${REDIS_PORT:6379}
    password: ${REDIS_PASSWORD:}
```

Or use environment variables:
- `REDIS_HOST`
- `REDIS_PORT`
- `REDIS_PASSWORD`

## Features in Detail

### 1. Peripheral Search
When you click on an object type and select "周边搜索":
1. System loads available relationship types for that object type
2. You can select specific relationship types or search all
3. Configure search depth (1-5 levels)
4. Results are added to the canvas with auto-layout

### 2. Timeline Feature
The timeline slider allows you to:
- View graph state at any point in time
- Relationships have `valid_from` and `valid_to` timestamps
- Drag slider to see historical or future relationships
- Filter graph based on time ranges

### 3. Entity Properties
When you left-click on an entity:
- Left panel shows detailed information
- Properties are displayed in key-value format
- Real-time data loading from backend

### 4. Actions
When you click the action button:
- System loads available actions for that ontology type
- Actions can be configured per type (view, edit, report, etc.)
- Custom action handlers can be implemented

### 5. Multi-select Add
When adding objects:
1. Select ontology type
2. System loads available instances
3. Multi-select entities to add
4. All selected entities are added to canvas at once

## Development

### Backend Development
```bash
cd backend
mvn spring-boot:run
```

Hot reload is enabled with Spring Boot DevTools.

### Frontend Development
```bash
cd frontend
npm run dev
```

Vite provides hot module replacement (HMR).

### Build for Production

Backend:
```bash
cd backend
mvn clean package
java -jar target/graph-ontology-explorer-1.0.0.jar
```

Frontend:
```bash
cd frontend
npm run build
# Output in dist/ directory
```

## Deployment

### Docker Deployment (Optional)

Create `Dockerfile` for backend:
```dockerfile
FROM openjdk:17-jdk-slim
COPY target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

Create `docker-compose.yml`:
```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DB_URL=jdbc:mysql://mysql:3306/ontology_db
      - REDIS_HOST=redis

  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_DATABASE=ontology_db
      - MYSQL_ROOT_PASSWORD=root

  redis:
    image: redis:7-alpine
```

## Troubleshooting

### Backend Issues

**Problem**: Cannot connect to database
**Solution**: Check `application.yml` configuration and ensure database is running

**Problem**: Port 8080 already in use
**Solution**: Change port in `application.yml` or kill the process using port 8080

### Frontend Issues

**Problem**: Cannot connect to backend API
**Solution**: Check proxy configuration in `vite.config.js`

**Problem**: Graph not rendering
**Solution**: Ensure AntV X6 dependencies are installed correctly

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues and questions:
- Create an issue in the repository
- Email: support@example.com

## Acknowledgments

- Inspired by Palantir Vertex
- Built with AntV X6 graph visualization
- Uses Spring Boot and Vue 3 ecosystem