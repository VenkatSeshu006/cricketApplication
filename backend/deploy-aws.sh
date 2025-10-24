#!/bin/bash

# CricketApp - AWS EC2 Quick Deployment Script
# This script automates the deployment of your CricketApp backend to AWS EC2

set -e  # Exit on error

echo "🚀 CricketApp AWS Deployment Script"
echo "===================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if running on EC2 instance
if [ ! -f ~/.aws_deployed ]; then
    print_info "First time deployment detected"
fi

# Update system
print_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y
print_success "System updated"

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    print_info "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker ubuntu
    print_success "Docker installed"
else
    print_success "Docker already installed"
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    print_info "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose installed"
else
    print_success "Docker Compose already installed"
fi

# Create app directory
APP_DIR="/home/ubuntu/cricketapp"
if [ ! -d "$APP_DIR" ]; then
    print_info "Creating application directory..."
    mkdir -p "$APP_DIR"
    cd "$APP_DIR"
else
    print_info "Application directory exists"
    cd "$APP_DIR"
fi

# Check if backend code exists
if [ ! -f "docker-compose.yml" ]; then
    print_error "Backend code not found!"
    print_info "Please upload your backend code to $APP_DIR"
    print_info "From your Windows machine, run:"
    echo "    scp -i your-key.pem -r C:\\Users\\ASUS\\Documents\\CricketApp\\backend ubuntu@YOUR_EC2_IP:~/cricketapp/"
    exit 1
fi

# Check if config file exists and has been updated
if [ -f "config/config.yaml" ]; then
    if grep -q "your-rds-endpoint" config/config.yaml; then
        print_error "Configuration not updated!"
        print_info "Please update config/config.yaml with your RDS endpoint"
        exit 1
    fi
    print_success "Configuration file found"
else
    print_error "config/config.yaml not found!"
    exit 1
fi

# Stop existing containers
print_info "Stopping existing containers..."
docker-compose down 2>/dev/null || true

# Build and start containers
print_info "Building and starting containers..."
docker-compose up -d --build

# Wait for backend to be ready
print_info "Waiting for backend to be ready..."
sleep 10

# Check if backend is running
if curl -f http://localhost:8080/health > /dev/null 2>&1; then
    print_success "Backend is running!"
    
    # Get public IP
    PUBLIC_IP=$(curl -s ifconfig.me)
    
    echo ""
    echo "=================================="
    print_success "Deployment Complete!"
    echo "=================================="
    echo ""
    echo "Your backend is now accessible at:"
    echo "  🌐 http://$PUBLIC_IP:8080"
    echo ""
    echo "Health Check:"
    echo "  ✅ http://$PUBLIC_IP:8080/health"
    echo ""
    echo "API Endpoints:"
    echo "  📝 Register: http://$PUBLIC_IP:8080/api/v1/auth/register"
    echo "  🔑 Login:    http://$PUBLIC_IP:8080/api/v1/auth/login"
    echo ""
    echo "Next Steps:"
    echo "  1. Update Flutter app API config with:"
    echo "     http://$PUBLIC_IP:8080/api/v1"
    echo ""
    echo "  2. In frontend/lib/core/config/api_config.dart, set:"
    echo "     USE_CLOUD_BACKEND = true"
    echo "     _cloudBackendUrl = 'http://$PUBLIC_IP:8080/api/v1'"
    echo ""
    echo "  3. Rebuild APK:"
    echo "     flutter clean && flutter build apk --debug"
    echo ""
    echo "  4. Install on your phone and test!"
    echo ""
    
    # Mark as deployed
    touch ~/.aws_deployed
    
else
    print_error "Backend failed to start!"
    print_info "Checking logs..."
    docker-compose logs
    exit 1
fi

# Show logs
print_info "Showing backend logs (Ctrl+C to exit)..."
docker-compose logs -f
