#!/bin/bash

##############################################################################
# Employee Maintainer - Docker Stop Script
# Stops and removes the Docker Compose application
##############################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Employee Maintainer - Docker Stop        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Parse command line arguments
REMOVE_VOLUMES=false
REMOVE_IMAGES=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --volumes)
            REMOVE_VOLUMES=true
            shift
            ;;
        --all)
            REMOVE_VOLUMES=true
            REMOVE_IMAGES=true
            shift
            ;;
        --help)
            echo "Usage: ./docker-stop.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --volumes    Also remove volumes (delete data)"
            echo "  --all        Remove containers, volumes, and images"
            echo "  --help       Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./docker-stop.sh              # Stop containers"
            echo "  ./docker-stop.sh --volumes    # Stop and remove volumes"
            echo "  ./docker-stop.sh --all        # Clean everything"
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

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose is not installed or not in PATH${NC}"
    exit 1
fi

# Check if containers are running
if ! docker-compose ps | grep -q "employee-api"; then
    echo -e "${YELLOW}⚠ No running containers found${NC}"
    echo ""
    
    if [ "$REMOVE_VOLUMES" = true ] || [ "$REMOVE_IMAGES" = true ]; then
        echo -e "${YELLOW}Proceeding with cleanup...${NC}"
        echo ""
    else
        exit 0
    fi
else
    echo -e "${YELLOW}Stopping containers...${NC}"
    docker-compose stop
    echo -e "${GREEN}✓ Containers stopped${NC}"
    echo ""
fi

# Remove containers
echo -e "${YELLOW}Removing containers...${NC}"
COMPOSE_DOWN_CMD="docker-compose down"

if [ "$REMOVE_VOLUMES" = true ]; then
    COMPOSE_DOWN_CMD="$COMPOSE_DOWN_CMD -v"
fi

if [ "$REMOVE_IMAGES" = true ]; then
    COMPOSE_DOWN_CMD="$COMPOSE_DOWN_CMD --rmi all"
fi

if eval "$COMPOSE_DOWN_CMD"; then
    echo -e "${GREEN}✓ Containers removed${NC}"
else
    echo -e "${RED}✗ Failed to remove containers${NC}"
    exit 1
fi

# Remove images if requested
if [ "$REMOVE_IMAGES" = true ]; then
    echo ""
    echo -e "${YELLOW}Removing Docker images...${NC}"
    
    if docker rmi employeemaintainer:latest 2>/dev/null; then
        echo -e "${GREEN}✓ Docker images removed${NC}"
    else
        echo -e "${YELLOW}⚠ Could not remove all images${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✓ Application stopped and cleaned up!${NC}"
echo ""

# Show status
RUNNING=$(docker ps | grep -c "employee-api" || true)
STOPPED=$(docker ps -a | grep -c "employee-api" || true)

if [ "$RUNNING" -eq 0 ] && [ "$STOPPED" -eq 0 ]; then
    echo -e "${BLUE}Status:${NC} No containers found (all cleaned)"
else
    if [ "$RUNNING" -gt 0 ]; then
        echo -e "${YELLOW}⚠ Still running: $RUNNING container(s)${NC}"
    fi
    if [ "$STOPPED" -gt 0 ]; then
        echo -e "${YELLOW}Stopped: $STOPPED container(s)${NC}"
    fi
fi

echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo "  • Start app again: ./docker-run.sh"
echo "  • List all containers: docker ps -a"
echo "  • View images: docker images | grep employeemaintainer"
echo ""
