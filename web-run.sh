#!/bin/bash

##############################################################################
# Employee Maintainer - Web Run Script
# Runs the Spring Boot application locally with proper checks
##############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Employee Maintainer - Web Run            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Parse command line arguments
PROFILE="default"
SKIP_BUILD=false
DEBUG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --mysql)
            PROFILE="mysql"
            shift
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --debug)
            DEBUG=true
            shift
            ;;
        --help)
            echo "Usage: ./web-run.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --mysql           Use MySQL database (default: H2 in-memory)"
            echo "  --skip-build      Skip building, use existing JAR"
            echo "  --debug           Run in debug mode with verbose output"
            echo "  --help            Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./web-run.sh                 # Run with H2 (default)"
            echo "  ./web-run.sh --mysql         # Run with MySQL"
            echo "  ./web-run.sh --skip-build    # Use existing build"
            echo "  ./web-run.sh --debug         # Debug mode"
            exit 0
            ;;
        *)
            echo -e "${RED}✗ Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Navigate to project directory
cd "$SCRIPT_DIR"

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo -e "${RED}✗ Java is not installed or not in PATH${NC}"
    echo "Please install Java 17 or later"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | grep -oP 'version "\K[^"]*' | head -c 2)
echo -e "${GREEN}✓ Java ${JAVA_VERSION} found${NC}"
echo ""

# Build if not skipped
if [ "$SKIP_BUILD" = false ]; then
    echo -e "${YELLOW}Building application...${NC}"
    if ! mvn clean package -q -DskipTests; then
        echo -e "${RED}✗ Build failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Build successful${NC}"
    echo ""
fi

# Find the JAR file
JAR_FILE=$(find "$SCRIPT_DIR/target" -maxdepth 1 -name "*.jar" -type f | head -n 1)

if [ -z "$JAR_FILE" ]; then
    echo -e "${RED}✗ No JAR file found in target directory${NC}"
    echo "Try running: ./build.sh"
    exit 1
fi

JAR_SIZE=$(du -h "$JAR_FILE" | cut -f1)
echo -e "${CYAN}Application JAR:${NC} $(basename "$JAR_FILE") ($JAR_SIZE)"
echo ""

# Prepare Java options
JAVA_OPTS="-Xms256m -Xmx512m"

if [ "$DEBUG" = true ]; then
    JAVA_OPTS="$JAVA_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=n"
    echo -e "${YELLOW}Debug mode enabled on port 5005${NC}"
fi

# Determine profile
SPRING_PROFILE=""
if [ "$PROFILE" = "mysql" ]; then
    SPRING_PROFILE="--spring.profiles.active=mysql"
    echo -e "${CYAN}Database:${NC} MySQL"
else
    echo -e "${CYAN}Database:${NC} H2 (in-memory)"
fi

echo ""
echo -e "${BLUE}Starting application...${NC}"
echo -e "${CYAN}Endpoint:${NC} http://localhost:8080/api/v1/employees"
echo -e "${CYAN}API Docs:${NC} http://localhost:8080/api/swagger-ui.html"
if [ "$PROFILE" = "default" ]; then
    echo -e "${CYAN}H2 Console:${NC} http://localhost:8080/api/h2-console"
fi
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
echo ""

# Run the application
java $JAVA_OPTS -jar "$JAR_FILE" $SPRING_PROFILE
