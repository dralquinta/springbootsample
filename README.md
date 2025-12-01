# Employee Maintainer API

A modern, production-ready REST API for Employee Management built with Spring Boot 3.2, Java 17, and deployed on Oracle Cloud Infrastructure.

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Build Scripts](#build-scripts)
- [Run Scripts](#run-scripts)
- [Docker Scripts](#docker-scripts)
- [API Endpoints](#api-endpoints)
- [Project Structure](#project-structure)
- [Technologies](#technologies)
- [Development](#development)
- [Deployment](#deployment)

## 🎯 Overview

The Employee Maintainer API is a modern microservice that provides RESTful endpoints for managing employee information. It features:

- ✨ **Spring Boot 3.2** with Java 17
- 🗄️ **H2 In-Memory Database** (no setup required)
- 📚 **Swagger/OpenAPI Documentation**
- 🔒 **Input Validation** with Jakarta validation
- 🏗️ **RESTful API** with best practices
- 📦 **Docker Support** with containerization
- ☁️ **OCI Ready** with OCIR push capability
- 🧪 **Mock Data** auto-loaded on startup
- 🚀 **Production Ready** architecture

## 🚀 Quick Start

### Prerequisites

- Java 17 or later
- Maven 3.6+
- Docker (optional, for containerization)
- Git

### 1. Build the Application

```bash
./build.sh
```

**Options:**
```bash
./build.sh --clean              # Clean build
./build.sh --skip-tests         # Skip tests
./build.sh --docker             # Build Docker image
./build.sh --docker-tag v1.0.0  # Build with custom tag
```

### 2. Run the Application

**Option A: Direct Java**
```bash
java -jar target/employeemaintainer-1.0.0.jar
```

**Option B: Using web-run.sh (recommended)**
```bash
./web-run.sh
```

**Option C: Docker Compose**
```bash
./docker-run.sh
```

### 3. Access the Application

- **API**: http://localhost:8080/api/v1/employees
- **Swagger UI**: http://localhost:8080/api/swagger-ui.html
- **H2 Console**: http://localhost:8080/api/h2-console

## 🛠️ Build Scripts

### build.sh - Maven Build Script

Compiles the application using Maven with optional Docker support.

**Usage:**
```bash
./build.sh [OPTIONS]
```

**Options:**
- `--clean` - Clean build (removes target directory)
- `--skip-tests` - Skip running tests
- `--docker` - Build Docker image after Maven build
- `--docker-tag TAG` - Build Docker image with custom tag

**Examples:**
```bash
# Standard build
./build.sh

# Clean build without tests
./build.sh --clean --skip-tests

# Build and create Docker image
./build.sh --docker

# Build and tag as v1.0.0
./build.sh --docker-tag v1.0.0
```

**Output:**
- JAR file: `target/employeemaintainer-1.0.0.jar` (53MB)
- Docker image: `employeemaintainer:TAG` (237MB)

## 🏃 Run Scripts

### web-run.sh - Local Development Runner

Builds and runs the application locally with H2 in-memory database.

**Usage:**
```bash
./web-run.sh [OPTIONS]
```

**Options:**
- `--skip-build` - Use existing JAR (faster)
- `--foreground` - Run in foreground (default: background)
- `--debug` - Enable debug mode (port 5005)
- `--mysql` - Use MySQL instead of H2 (if configured)

**Examples:**
```bash
# Build and run (default)
./web-run.sh

# Run faster with existing build
./web-run.sh --skip-build

# Debug mode
./web-run.sh --debug

# Run in foreground
./web-run.sh --foreground
```

**Access Points:**
- API: http://localhost:8080/api/v1/employees
- Swagger: http://localhost:8080/api/swagger-ui.html
- H2 Console: http://localhost:8080/api/h2-console
- Debug Port: 5005 (with --debug)

## 🐳 Docker Scripts

### docker-run.sh - Start with Docker Compose

Runs the application using Docker Compose.

**Usage:**
```bash
./docker-run.sh [OPTIONS]
```

**Options:**
- `--build` - Build Docker image before running
- `--foreground` - Run in foreground (default: background)
- `--mysql` - Include MySQL database

**Examples:**
```bash
# Run with existing image
./docker-run.sh

# Build and run
./docker-run.sh --build

# Run in foreground
./docker-run.sh --foreground
```

### docker-stop.sh - Stop Docker Containers

Stops and removes Docker containers.

**Usage:**
```bash
./docker-stop.sh [OPTIONS]
```

**Options:**
- `--volumes` - Also remove volumes (delete data)
- `--all` - Remove containers, volumes, and images

**Examples:**
```bash
# Stop containers
./docker-stop.sh

# Stop and remove volumes
./docker-stop.sh --volumes

# Clean everything
./docker-stop.sh --all
```

### docker-push.sh - Push to Oracle Cloud OCIR

Pushes Docker image to Oracle Cloud Infrastructure Registry (OCIR) with auto-tag detection.

**Usage:**
```bash
./docker-push.sh --region <region> --user <user> --password <token> --repository <repo> [OPTIONS]
```

**Required Arguments:**
- `--region REGION` - OCIR region (e.g., phx.ocir.io, iad.ocir.io)
- `--user USER` - OCI username (TenantID/oracleidentitycloudservice/USERNAME)
- `--password TOKEN` - OCI auth token
- `--repository REPO` - OCIR repository (e.g., tenant/myapp)

**Optional Arguments:**
- `--tag TAG` - Override auto-detected tag
- `--build` - Build image before pushing

**Examples:**

```bash
# Auto-detect local image tag and push
./docker-push.sh \
  --region phx.ocir.io \
  --user TenantID/oracleidentitycloudservice/user@example.com \
  --password 'auth_token_here' \
  --repository tenant/myapp

# Push with custom tag
./docker-push.sh \
  --region iad.ocir.io \
  --user TenantID/oracleidentitycloudservice/user@example.com \
  --password 'token' \
  --repository tenant/myapp \
  --tag v1.0.0

# Build and push
./docker-push.sh \
  --region fra.ocir.io \
  --user TenantID/oracleidentitycloudservice/user@example.com \
  --password 'token' \
  --repository tenant/myapp \
  --build
```

**OCIR Regions:**
- phx.ocir.io - US Phoenix
- iad.ocir.io - US Ashburn (IAD)
- fra.ocir.io - Frankfurt
- lhr.ocir.io - London
- syd.ocir.io - Sydney
- icn.ocir.io - Seoul
- nrt.ocir.io - Tokyo
- bom.ocir.io - Mumbai
- gru.ocir.io - São Paulo

**Auto-Tag Detection:**
The script automatically detects the local image tag (typically `latest`) without requiring a rebuild. Just build once and push multiple times to different registries!

## 📡 API Endpoints

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
    "jobTitle": "Senior Software Engineer"
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
    "name": "Jane Smith",
    "email": "jane.smith@company.com",
    "jobTitle": "Principal Engineer"
  }'
```

**Delete employee:**
```bash
curl -X DELETE http://localhost:8080/api/v1/employees/1
```

### API Documentation

Access the interactive Swagger UI at:
```
http://localhost:8080/api/swagger-ui.html
```

Or view the OpenAPI JSON at:
```
http://localhost:8080/api/v3/api-docs
```

## 📂 Project Structure

```
src/
├── main/
│   ├── java/com/startups/sample/backend/employeemaintainer/
│   │   ├── EmployeemaintainerApplication.java    # Main entry point
│   │   ├── config/
│   │   │   └── DataInitializer.java              # Mock data loader
│   │   ├── controller/
│   │   │   └── EmployeeResource.java             # REST endpoints
│   │   ├── service/
│   │   │   └── EmployeeService.java              # Business logic
│   │   ├── repo/
│   │   │   └── EmployeeRepo.java                 # Data repository
│   │   ├── model/
│   │   │   └── Employee.java                     # Entity model
│   │   └── CustomExceptions/
│   │       └── UserNotFoundException.java         # Custom exception
│   └── resources/
│       ├── application.properties                 # H2 config
│       └── application-mysql.properties          # MySQL config
├── test/
│   └── java/.../EmployeemaintainerApplicationTests.java
├── pom.xml                                        # Maven config
├── Dockerfile                                     # Docker image config
├── docker-compose.yml                             # Docker Compose config
├── build.sh                                       # Build script
├── web-run.sh                                     # Web run script
├── docker-run.sh                                  # Docker run script
├── docker-stop.sh                                 # Docker stop script
└── docker-push.sh                                 # Docker push script
```

## 🔧 Technologies

### Core
- **Spring Boot** 3.2.0
- **Java** 17
- **Maven** 3.6+

### Data
- **Spring Data JPA** - Data access layer
- **Hibernate** 6.3.1 - ORM framework
- **H2 Database** 2.2.x - In-memory database
- **MySQL** 8.2.x - Optional production database

### API
- **Spring Web** - RESTful API support
- **Springdoc OpenAPI** 2.1.0 - API documentation
- **Jakarta Validation** - Input validation

### Development
- **Lombok** - Boilerplate reduction
- **Docker** 28.2+ - Containerization
- **Docker Compose** - Multi-container orchestration

## 💻 Development

### Compile

```bash
mvn clean compile
```

### Run Tests

```bash
mvn test
```

### Run Application

```bash
mvn spring-boot:run
```

### Check Dependencies

```bash
mvn dependency:tree
```

### Format Code

```bash
mvn spotless:apply
```

## ☁️ Deployment

### Local Development

```bash
# Build
./build.sh --skip-tests

# Run
./web-run.sh
```

### Docker Compose (Local)

```bash
# Build Docker image
./build.sh --docker

# Run with Docker Compose
./docker-run.sh

# Stop
./docker-stop.sh
```

### Oracle Cloud (OKE)

```bash
# 1. Build image
./build.sh --docker

# 2. Push to OCIR
./docker-push.sh \
  --region phx.ocir.io \
  --user TenantID/oracleidentitycloudservice/user@example.com \
  --password 'auth_token' \
  --repository tenant/employee-api

# 3. Deploy to OKE
kubectl apply -f deployment.yaml

# 4. Update image
kubectl set image deployment/employee-api \
  employee-api=phx.ocir.io/tenant/employee-api/employeemaintainer:latest
```

## 📊 Mock Data

The application automatically loads 5 mock employees on startup:

1. **John Smith** - Senior Software Engineer
2. **Maria Garcia** - Product Manager
3. **David Chen** - DevOps Engineer
4. **Sarah Wilson** - UX/UI Designer
5. **Robert Johnson** - QA Lead

Access via API: `GET http://localhost:8080/api/v1/employees`

## 🔐 Security

### Database Selection

**Development (Default):**
- H2 in-memory database
- No setup required
- Data lost on restart

**Production:**
```bash
java -jar target/*.jar --spring.profiles.active=mysql
```

Update credentials in `application-mysql.properties`:
```properties
spring.datasource.url=jdbc:mysql://your-host:3306/employeemaintainer
spring.datasource.username=your-user
spring.datasource.password=your-password
```

### OCIR Credentials

⚠️ **Never commit credentials to version control!**

Use environment variables:
```bash
export OCIR_PASSWORD=$(cat ~/.oci/auth_token)

./docker-push.sh \
  --region phx.ocir.io \
  --user "$OCIR_USER" \
  --password "$OCIR_PASSWORD" \
  --repository "$OCIR_REPO"
```

## 📝 Configuration

### Application Properties

**H2 (Default):**
```properties
spring.datasource.url=jdbc:h2:mem:employeedb
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
```

**MySQL (Production):**
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/employeemaintainer
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
```

### Logging

Set log levels in `application.properties`:
```properties
logging.level.root=INFO
logging.level.com.startups.sample.backend=DEBUG
```

## 🐛 Troubleshooting

### Build Fails
```bash
# Clean and rebuild
./build.sh --clean

# Check Java version
java -version

# Check Maven
mvn --version
```

### Application Won't Start
```bash
# Check port 8080 is available
lsof -i :8080

# Kill process on port 8080
kill -9 <PID>
```

### Docker Issues
```bash
# Check Docker is running
docker ps

# View logs
docker-compose logs -f employee-api

# Rebuild without cache
./build.sh --docker --clean
```

### OCIR Push Fails
```bash
# Verify credentials
echo $OCIR_USER

# Test Docker login
echo "password" | docker login -u "user" --password-stdin phx.ocir.io

# Check repository exists
# OCI Console > Container Registries > Repositories
```

## 📚 Additional Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JPA Guide](https://spring.io/projects/spring-data-jpa)
- [Docker Documentation](https://docs.docker.com/)
- [OCI Container Registry](https://docs.oracle.com/en-us/iaas/Content/Registry/home.htm)
- [OKE Documentation](https://docs.oracle.com/en-us/iaas/Content/ContEng/home.htm)

## 📄 License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs: `docker-compose logs`
3. Create an issue in the repository
4. Contact: support@example.com

## ✨ Version History

### v1.0.0 (Current)
- Modern Spring Boot 3.2 with Java 17
- H2 in-memory database with mock data
- RESTful API with OpenAPI documentation
- Docker and Docker Compose support
- OCIR push capability with auto-tag detection
- Comprehensive build and deployment scripts
- Fully documented and production-ready

---

**Last Updated:** December 1, 2025  
**Maintained By:** Employee Maintainer Team
