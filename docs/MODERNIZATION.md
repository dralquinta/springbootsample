# Employee Maintainer API

Modern REST API for managing employees with a clean, production-ready architecture.

## Features

- ✨ **Spring Boot 3.2.0** with Java 17
- 🗄️ **H2 In-Memory Database** (no external DB needed for development)
- 📚 **Swagger/OpenAPI Documentation** available at `/api/swagger-ui.html`
- 🔒 **Input Validation** with Jakarta validation
- 📝 **Lombok** for clean code
- 🏗️ **RESTful API** with best practices
- 🧪 **Mock Data** automatically loaded on startup

## Getting Started

### Prerequisites

- Java 17 or later
- Maven 3.6+

### Building the Application

```bash
./build.sh
```

Or with options:
```bash
./build.sh --clean           # Clean build
./build.sh --skip-tests      # Skip tests
./build.sh --help            # Show all options
```

### Running the Application

```bash
java -jar target/employeemaintainer-1.0.0.jar
```

The application will start on `http://localhost:8080`

## API Endpoints

### Base URL
```
http://localhost:8080/api/v1/employees
```

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Get all employees |
| GET | `/{id}` | Get employee by ID |
| POST | `/` | Create new employee |
| PUT | `/{id}` | Update employee |
| DELETE | `/{id}` | Delete employee |

### Example Requests

**Get all employees:**
```bash
curl http://localhost:8080/api/v1/employees
```

**Create employee:**
```bash
curl -X POST http://localhost:8080/api/v1/employees \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Doe",
    "email": "jane.doe@company.com",
    "jobTitle": "Software Engineer"
  }'
```

**Get employee by ID:**
```bash
curl http://localhost:8080/api/v1/employees/1
```

**Update employee:**
```bash
curl -X PUT http://localhost:8080/api/v1/employees/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Doe",
    "email": "jane.doe@company.com",
    "jobTitle": "Senior Software Engineer"
  }'
```

**Delete employee:**
```bash
curl -X DELETE http://localhost:8080/api/v1/employees/1
```

## Documentation

### Swagger/OpenAPI

Access the interactive API documentation at:
```
http://localhost:8080/api/swagger-ui.html
```

Or view the OpenAPI JSON:
```
http://localhost:8080/api/v3/api-docs
```

### H2 Database Console

For development/debugging, access the H2 console at:
```
http://localhost:8080/api/h2-console
```

Connection details:
- **URL**: `jdbc:h2:mem:employeedb`
- **User**: `sa`
- **Password**: (leave blank)

## Mock Data

The application automatically loads 5 mock employees on startup:

1. **John Smith** - Senior Software Engineer
2. **Maria Garcia** - Product Manager
3. **David Chen** - DevOps Engineer
4. **Sarah Wilson** - UX/UI Designer
5. **Robert Johnson** - QA Lead

## Database Configuration

### Development (Default)

Uses H2 in-memory database. No setup required.

### Production (MySQL)

To use MySQL, run the application with the `mysql` profile:

```bash
java -jar target/employeemaintainer-1.0.0.jar --spring.profiles.active=mysql
```

Update database credentials in `application-mysql.properties`:

```properties
spring.datasource.url=jdbc:mysql://your-host:3306/employeemaintainer
spring.datasource.username=your-user
spring.datasource.password=your-password
```

## Project Structure

```
src/main/
├── java/com/startups/sample/backend/employeemaintainer/
│   ├── EmployeemaintainerApplication.java    # Main application class
│   ├── config/
│   │   └── DataInitializer.java              # Mock data initialization
│   ├── controller/
│   │   └── EmployeeResource.java             # REST endpoints
│   ├── service/
│   │   └── EmployeeService.java              # Business logic
│   ├── repo/
│   │   └── EmployeeRepo.java                 # Data repository
│   ├── model/
│   │   └── Employee.java                     # Entity model
│   └── CustomExceptions/
│       └── UserNotFoundException.java         # Custom exception
└── resources/
    ├── application.properties                 # H2 configuration
    └── application-mysql.properties          # MySQL configuration
```

## Development

### Compile

```bash
mvn clean compile
```

### Run Tests

```bash
mvn test
```

### Format Code

```bash
mvn spotless:apply
```

## Build Artifacts

- **JAR**: `target/employeemaintainer-1.0.0.jar`
- **Sources**: `target/employeemaintainer-1.0.0-sources.jar`

## Technologies

- **Spring Boot** 3.2.0
- **Spring Data JPA** - Data access
- **Hibernate** - ORM
- **H2 Database** - In-memory database
- **Lombok** - Boilerplate reduction
- **Springdoc OpenAPI** - API documentation
- **Jakarta Persistence** - JPA specification
- **Jakarta Validation** - Input validation

## Version History

### v1.0.0 (Current)
- Initial release
- Modernized Spring Boot 3.2 with Java 17
- H2 in-memory database
- RESTful API with OpenAPI documentation
- Mock data initialization
- Optional MySQL support

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.

## Support

For issues or questions, please create an issue in the repository.
