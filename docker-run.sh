#!/bin/bash

##############################################################################
# Employee Maintainer - Docker Run Script
# Runs the Spring Boot application using Docker Compose
##############################################################################

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
echo -e "${BLUE}║  Employee Maintainer - Docker Run         ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Parse command line arguments
BUILD_IMAGE=false
DETACHED=true
MYSQL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --build)
            BUILD_IMAGE=true
            shift
            ;;
        --foreground)
            DETACHED=false
            shift
            ;;
        --mysql)
            MYSQL=true
            shift
            ;;
        --help)
            echo "Usage: ./docker-run.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --build         Build Docker image before running"
            echo "  --foreground    Run in foreground (default: background/detached)"
            echo "  --mysql         Include MySQL database (default: H2 only)"
            echo "  --help          Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./docker-run.sh                  # Run container in background"
            echo "  ./docker-run.sh --foreground     # Run in foreground"
            echo "  ./docker-run.sh --build          # Build and run"
            echo "  ./docker-run.sh --mysql          # Run with MySQL"
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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed or not in PATH${NC}"
    echo "Please install Docker from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo -e "${GREEN}✓ Docker found${NC}: $(docker --version)"
echo ""

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose is not installed or not in PATH${NC}"
    echo "Please install Docker Compose"
    exit 1
fi

echo -e "${GREEN}✓ Docker Compose found${NC}: $(docker-compose --version)"
echo ""

# Build image if requested
if [ "$BUILD_IMAGE" = true ]; then
    echo -e "${YELLOW}Building Docker image...${NC}"
    if ! docker build -t employeemaintainer:latest .; then
        echo -e "${RED}✗ Docker build failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Docker image built${NC}"
    echo ""
fi

# Check if image exists
if ! docker images | grep -q "employeemaintainer.*latest"; then
    echo -e "${YELLOW}⚠ Docker image 'employeemaintainer:latest' not found${NC}"
    echo "Building image now..."
    if ! docker build -t employeemaintainer:latest .; then
        echo -e "${RED}✗ Docker build failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Docker image built${NC}"
    echo ""
fi

# Stop any running containers
echo -e "${YELLOW}Checking for existing containers...${NC}"
if docker-compose ps | grep -q "employee-api"; then
    echo -e "${YELLOW}Stopping existing containers...${NC}"
    docker-compose down --remove-orphans
    sleep 2
    echo -e "${GREEN}✓ Stopped${NC}"
    echo ""
fi

# Set compose file based on database choice
COMPOSE_FILE="docker-compose.yml"

# Prepare docker-compose command
COMPOSE_CMD="docker-compose -f $COMPOSE_FILE up"

if [ "$DETACHED" = true ]; then
    COMPOSE_CMD="$COMPOSE_CMD -d"
fi

echo -e "${BLUE}Starting application with Docker Compose...${NC}"
echo -e "${CYAN}Database:${NC} H2 (in-memory)"

if [ "$MYSQL" = true ]; then
    echo -e "${YELLOW}Note:${NC} MySQL support requires additional docker-compose configuration"
fi

echo ""
echo -e "${YELLOW}Executing:${NC} $COMPOSE_CMD"
echo ""

# Run docker-compose
if eval "$COMPOSE_CMD"; then
    echo ""
    
    if [ "$DETACHED" = true ]; then
        # Wait for container to be healthy
        echo -e "${YELLOW}Waiting for application to start...${NC}"
        sleep 5
        
        # Check health
        if docker-compose ps | grep -q "employee-api"; then
            STATUS=$(docker-compose ps | grep "employee-api" | awk '{print $NF}')
            echo -e "${GREEN}✓ Container is running${NC} ($STATUS)"
        fi
    fi
    
    echo ""
    echo -e "${GREEN}✓ Application started successfully!${NC}"
    echo ""
    echo -e "${BLUE}Access points:${NC}"
    echo "  • API Base URL: http://localhost:8080/api/v1/employees"
    echo "  • Swagger Docs: http://localhost:8080/api/swagger-ui.html"
    echo "  • H2 Console: http://localhost:8080/api/h2-console"
    echo ""
    echo -e "${BLUE}Useful commands:${NC}"
    echo "  • View logs: docker-compose logs -f employee-api"
    echo "  • Stop app: ./docker-stop.sh"
    echo "  • List containers: docker-compose ps"
    echo "  • Execute shell: docker-compose exec employee-api sh"
    echo ""
    
    if [ "$DETACHED" = false ]; then
        echo -e "${YELLOW}Running in foreground. Press Ctrl+C to stop...${NC}"
    fi
else
    echo ""
    echo -e "${RED}✗ Failed to start application!${NC}"
    echo "Try checking logs: docker-compose logs"
    exit 1
fi
