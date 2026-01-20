# SQL Scripts Management

This directory contains SQL scripts for the Graph Ontology Explorer database.

## Scripts Execution Order

Execute the scripts in the following order:

1. **01_init_schema.sql** - Creates the database schema
   - Creates all tables (ontology_type, entity_instance, relation_type, relationship, ontology_action)
   - Sets up indexes and foreign key constraints
   - Supports time-series data with valid_from and valid_to columns

2. **02_sample_data.sql** - Populates sample data
   - Inserts ontology types (公司, 供应商, 经销商, etc.)
   - Inserts sample entities (海王集团, suppliers, distributors)
   - Creates relationships with time-series support
   - Adds ontology actions

## How to Execute

### For H2 Database (Development)
The application will auto-create tables using JPA when running with H2.
You can manually execute SQL via H2 Console at: http://localhost:8080/api/h2-console

### For MySQL (Production)
```bash
# Connect to MySQL
mysql -u username -p database_name

# Execute schema
source 01_init_schema.sql

# Execute sample data
source 02_sample_data.sql
```

### Using MySQL Workbench
1. Open MySQL Workbench
2. Connect to your database
3. File -> Run SQL Script
4. Select and execute scripts in order

## Database Configuration

Configure database connection in `application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ontology_db
    username: your_username
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
```

## Time-Series Features

The `relationship` table supports time-series data:
- `valid_from`: When the relationship starts
- `valid_to`: When the relationship ends (NULL means currently valid)

This allows querying graph state at any point in time.

## Notes

- Scripts are designed to be idempotent (can be run multiple times)
- Always backup your database before executing schema changes
- Adjust AUTO_INCREMENT values if needed for your environment
