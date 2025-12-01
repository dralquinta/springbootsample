FROM eclipse-temurin:17-jre-alpine

LABEL maintainer="Employee Maintainer Team"
LABEL description="Modern Employee Management REST API"

WORKDIR /app

# Copy the built JAR
COPY target/employeemaintainer-*.jar app.jar

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/api/v1/employees || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
