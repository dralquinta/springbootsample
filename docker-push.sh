#!/bin/bash

##############################################################################
# Employee Maintainer - Docker Push to OCIR Script
# Pushes Docker image to Oracle Cloud Infrastructure Registry
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

# Function to display help
show_help() {
    echo "Usage: ./docker-push.sh --region <region> --user <user> --password <password> --repository <repo> [OPTIONS]"
    echo ""
    echo "Required Arguments:"
    echo "  --region REGION         OCIR region (e.g., phx.ocir.io, iad.ocir.io, fra.ocir.io)"
    echo "  --user USER             OCI username (format: TenantID/oracleidentitycloudservice/USERNAME)"
    echo "  --password TOKEN        OCI auth token"
    echo "  --repository REPO       OCIR repository name (e.g., tenant/myapp)"
    echo ""
    echo "Optional Arguments:"
    echo "  --tag TAG               Docker image tag (auto-detected from local image if not specified)"
    echo "  --build                 Build Docker image before pushing"
    echo "  --help                  Show this help message"
    echo ""
    echo "Examples:"
    echo "  # Auto-detect tag from local image and push"
    echo "  ./docker-push.sh \\"
    echo "    --region phx.ocir.io \\"
    echo "    --user TenantID/oracleidentitycloudservice/username@example.com \\"
    echo "    --password 'auth_token_here' \\"
    echo "    --repository tenant/myapp"
    echo ""
    echo "  # Specify custom tag"
    echo "  ./docker-push.sh \\"
    echo "    --region iad.ocir.io \\"
    echo "    --user TenantID/oracleidentitycloudservice/user \\"
    echo "    --password 'token' \\"
    echo "    --repository tenant/myapp \\"
    echo "    --tag v1.0.0 --build"
    echo ""
    echo "OCIR Regions:"
    echo "  • phx.ocir.io  - US Phoenix"
    echo "  • iad.ocir.io  - US Ashburn (IAD)"
    echo "  • fra.ocir.io  - Frankfurt"
    echo "  • lhr.ocir.io  - London"
    echo "  • syd.ocir.io  - Sydney"
    echo "  • icn.ocir.io  - Seoul"
    echo "  • nrt.ocir.io  - Tokyo"
    echo "  • bom.ocir.io  - Mumbai"
    echo "  • gru.ocir.io  - São Paulo"
    echo ""
    echo "Notes:"
    echo "  • Create an auth token at: OCI Console > User Settings > Auth Tokens"
    echo "  • Username format: TenantID/oracleidentitycloudservice/username@email.com"
    echo "  • Store credentials securely, never commit to version control"
}

# Function to validate inputs
validate_inputs() {
    local errors=0
    
    if [ -z "$OCIR_REGION" ]; then
        echo -e "${RED}✗ --region is required${NC}"
        errors=$((errors + 1))
    fi
    
    if [ -z "$OCIR_USER" ]; then
        echo -e "${RED}✗ --user is required${NC}"
        errors=$((errors + 1))
    fi
    
    if [ -z "$OCIR_PASSWORD" ]; then
        echo -e "${RED}✗ --password is required${NC}"
        errors=$((errors + 1))
    fi
    
    if [ -z "$REPOSITORY" ]; then
        echo -e "${RED}✗ --repository is required${NC}"
        errors=$((errors + 1))
    fi
    
    if [ $errors -gt 0 ]; then
        echo ""
        echo "Use --help for usage information"
        return 1
    fi
    
    return 0
}

# Main script starts here
echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Employee Maintainer - Docker Push to OCIR           ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Default values
IMAGE_NAME="employeemaintainer"
IMAGE_TAG=""
OCIR_REGION=""
OCIR_USER=""
OCIR_PASSWORD=""
REPOSITORY=""
BUILD_IMAGE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --region)
            OCIR_REGION="$2"
            shift 2
            ;;
        --user)
            OCIR_USER="$2"
            shift 2
            ;;
        --password)
            OCIR_PASSWORD="$2"
            shift 2
            ;;
        --repository)
            REPOSITORY="$2"
            shift 2
            ;;
        --tag)
            IMAGE_TAG="$2"
            shift 2
            ;;
        --build)
            BUILD_IMAGE=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}✗ Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Validate inputs
if ! validate_inputs; then
    exit 1
fi

echo ""

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

# Auto-detect local image tag if not specified
if [ -z "$IMAGE_TAG" ]; then
    echo -e "${YELLOW}Detecting local image tags...${NC}"
    
    # Get the first tag of the image
    DETECTED_TAG=$(docker images --format "{{.Tag}}" --filter "reference=${IMAGE_NAME}" | head -n 1)
    
    if [ -z "$DETECTED_TAG" ]; then
        echo -e "${RED}✗ No local image found for '${IMAGE_NAME}'${NC}"
        echo "Build the image with: ./build.sh --docker"
        exit 1
    fi
    
    IMAGE_TAG="$DETECTED_TAG"
    echo -e "${GREEN}✓ Detected tag: ${IMAGE_TAG}${NC}"
    echo ""
fi

# Build image if requested
if [ "$BUILD_IMAGE" = true ]; then
    echo -e "${YELLOW}Building Docker image...${NC}"
    if ! docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .; then
        echo -e "${RED}✗ Docker build failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Docker image built${NC}"
    echo ""
fi

# Check if image exists
if ! docker images | grep -q "${IMAGE_NAME}.*${IMAGE_TAG}"; then
    echo -e "${RED}✗ Docker image '${IMAGE_NAME}:${IMAGE_TAG}' not found${NC}"
    echo "Build the image with: ./build.sh --docker"
    exit 1
fi

echo -e "${GREEN}✓ Found Docker image${NC}: ${IMAGE_NAME}:${IMAGE_TAG}"
echo ""

# Construct OCIR image name
OCIR_FULL_IMAGE="${OCIR_REGION}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}"

echo -e "${BLUE}OCIR Configuration:${NC}"
echo "  • Region: $OCIR_REGION"
echo "  • Repository: $REPOSITORY"
echo "  • Image: $IMAGE_NAME:$IMAGE_TAG"
echo "  • Full path: $OCIR_FULL_IMAGE"
echo ""

# Validate region format
if ! [[ "$OCIR_REGION" =~ \.ocir\.io$ ]]; then
    echo -e "${YELLOW}⚠ Warning: Region may not be valid OCIR format${NC}"
    echo "Expected format: <region>.ocir.io (e.g., phx.ocir.io)"
    echo ""
fi

# Docker login to OCIR
echo -e "${YELLOW}Logging in to OCIR...${NC}"
if echo "$OCIR_PASSWORD" | docker login -u "$OCIR_USER" --password-stdin "$OCIR_REGION" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Successfully logged in to OCIR${NC}"
else
    echo -e "${RED}✗ Failed to log in to OCIR${NC}"
    echo "Please check your region, username, and password"
    exit 1
fi

echo ""

# Tag image for OCIR
echo -e "${YELLOW}Tagging image for OCIR...${NC}"
if docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "$OCIR_FULL_IMAGE"; then
    echo -e "${GREEN}✓ Image tagged${NC}: $OCIR_FULL_IMAGE"
else
    echo -e "${RED}✗ Failed to tag image${NC}"
    exit 1
fi

echo ""

# Push image to OCIR
echo -e "${YELLOW}Pushing image to OCIR...${NC}"
echo -e "${CYAN}This may take a few minutes...${NC}"
echo ""

if docker push "$OCIR_FULL_IMAGE"; then
    echo ""
    echo -e "${GREEN}✓ Image pushed successfully!${NC}"
    
    # Get image info
    IMAGE_SIZE=$(docker images "$OCIR_FULL_IMAGE" --format "{{.Size}}")
    
    echo ""
    echo -e "${BLUE}Push Summary:${NC}"
    echo "  • Local image: ${IMAGE_NAME}:${IMAGE_TAG}"
    echo "  • OCIR path: $OCIR_FULL_IMAGE"
    echo "  • Image size: $IMAGE_SIZE"
    echo ""
    
    echo -e "${BLUE}Next Steps:${NC}"
    echo "  • Deploy from OCIR:"
    echo "    docker pull $OCIR_FULL_IMAGE"
    echo "    docker run -p 8080:8080 $OCIR_FULL_IMAGE"
    echo ""
    echo "  • Create OKE deployment:"
    echo "    kubectl set image deployment/myapp myapp=$OCIR_FULL_IMAGE"
    echo ""
    echo "  • View in OCI Console:"
    echo "    https://console.us-phoenix-1.oraclecloud.com/artifacts/container-repos/"
    echo ""
    
else
    echo ""
    echo -e "${RED}✗ Failed to push image to OCIR${NC}"
    echo ""
    echo -e "${BLUE}Troubleshooting:${NC}"
    echo "  • Verify region is correct: $OCIR_REGION"
    echo "  • Check username format: TenantID/oracleidentitycloudservice/username"
    echo "  • Ensure auth token is valid and not expired"
    echo "  • Verify repository exists in OCIR"
    echo ""
    exit 1
fi

# Logout from OCIR
echo -e "${YELLOW}Logging out from OCIR...${NC}"
docker logout "$OCIR_REGION" > /dev/null 2>&1
echo -e "${GREEN}✓ Logged out${NC}"
echo ""

echo -e "${GREEN}✓ Docker push to OCIR completed successfully!${NC}"
echo ""
