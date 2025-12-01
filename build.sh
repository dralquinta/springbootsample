#!/bin/bash

##############################################################################
# Employee Maintainer - Build Script
# This script builds the Spring Boot application using Maven
##############################################################################

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Employee Maintainer - Build Script       ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}✗ Maven is not installed or not in PATH${NC}"
    echo "Please install Maven from: https://maven.apache.org/download.cgi"
    exit 1
fi

echo -e "${GREEN}✓ Maven found${NC}: $(mvn --version | head -n 1)"
echo ""

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo -e "${RED}✗ Java is not installed or not in PATH${NC}"
    echo "Please install Java 17 or later"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | grep -oP 'version "\K[^"]*' | head -c 2)
echo -e "${GREEN}✓ Java found${NC}: Java $JAVA_VERSION"
echo ""

# Function to build Docker image
build_docker_image() {
    echo -e "${YELLOW}Building Docker image...${NC}"
    echo ""
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}✗ Docker is not installed or not in PATH${NC}"
        echo "Please install Docker from: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    DOCKER_VERSION=$(docker --version | grep -oP 'version \K[^,]*')
    echo -e "${GREEN}✓ Docker found${NC}: $DOCKER_VERSION"
    echo ""
    
    # Build Docker image
    IMAGE_NAME="employeemaintainer"
    FULL_TAG="${IMAGE_NAME}:${DOCKER_TAG}"
    
    echo -e "${YELLOW}Building:${NC} $FULL_TAG"
    
    if docker build -t "$FULL_TAG" .; then
        echo ""
        echo -e "${GREEN}✓ Docker image built successfully!${NC}"
        
        # Get image info
        IMAGE_SIZE=$(docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}" | grep "$FULL_TAG" | awk '{print $2}')
        echo -e "${GREEN}✓ Image:${NC} $FULL_TAG ($IMAGE_SIZE)"
        
        echo ""
        echo -e "${BLUE}Docker commands:${NC}"
        echo "  • Run: docker run -p 8080:8080 $FULL_TAG"
        echo "  • Push: docker push $FULL_TAG"
        echo "  • List: docker images | grep employeemaintainer"
        echo "  • Docker Compose: docker-compose up"
    else
        echo ""
        echo -e "${RED}✗ Docker image build failed!${NC}"
        exit 1
    fi
}

# Parse command line arguments
BUILD_TYPE="package"
SKIP_TESTS=false
BUILD_DOCKER=false
DOCKER_TAG="latest"

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        --clean)
            BUILD_TYPE="clean package"
            shift
            ;;
        --docker)
            BUILD_DOCKER=true
            shift
            ;;
        --docker-tag)
            BUILD_DOCKER=true
            DOCKER_TAG="$2"
            shift 2
            ;;
        --help)
            echo "Usage: ./build.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --clean              Clean build (removes target directory first)"
            echo "  --skip-tests         Skip running tests"
            echo "  --docker             Build Docker image after Maven build"
            echo "  --docker-tag TAG     Build Docker image with specific tag (implies --docker)"
            echo "  --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./build.sh                                   # Standard Maven build"
            echo "  ./build.sh --clean --skip-tests              # Clean build without tests"
            echo "  ./build.sh --docker                          # Build with Docker image"
            echo "  ./build.sh --docker-tag v1.0.0               # Build with custom tag"
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
echo -e "${BLUE}Building in:${NC} $(pwd)"
echo ""

# Build Maven command
MAVEN_CMD="mvn $BUILD_TYPE"

if [ "$SKIP_TESTS" = true ]; then
    MAVEN_CMD="$MAVEN_CMD -DskipTests"
fi

# Add common Maven options
MAVEN_CMD="$MAVEN_CMD -q"

echo -e "${YELLOW}Executing:${NC} $MAVEN_CMD"
echo ""

# Run Maven build
if eval "$MAVEN_CMD"; then
    echo ""
    echo -e "${GREEN}✓ Maven build successful!${NC}"
    
    # Find the built JAR file
    JAR_FILE=$(find target -maxdepth 1 -name "*.jar" -type f | head -n 1)
    
    if [ -n "$JAR_FILE" ]; then
        JAR_SIZE=$(du -h "$JAR_FILE" | cut -f1)
        echo -e "${GREEN}✓ Output:${NC} $JAR_FILE ($JAR_SIZE)"
    fi
    
    # Build Docker image if requested
    if [ "$BUILD_DOCKER" = true ]; then
        echo ""
        build_docker_image
    fi
    
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    if [ "$BUILD_DOCKER" = true ]; then
        echo "  • Run container: docker run -p 8080:8080 employeemaintainer:$DOCKER_TAG"
        echo "  • Use docker-compose: docker-compose up"
    else
        echo "  • Run the application: java -jar target/*.jar"
        echo "  • Or use the web-run script: ./web-run.sh"
        echo "  • Build Docker image: ./build.sh --docker"
    fi
    echo "  • View API docs: http://localhost:8080/api/swagger-ui.html"
    echo ""
else
    echo ""
    echo -e "${RED}✗ Maven build failed!${NC}"
    exit 1
fi
