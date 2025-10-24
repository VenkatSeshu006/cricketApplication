#!/bin/bash
set -e

echo "🚀 Cricket App Backend Deployment Script"
echo "========================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
RDS_ENDPOINT="cricket-app-db.c5qs0k4sk65n.ap-south-1.rds.amazonaws.com"
RDS_PASSWORD="Crick456"
JWT_SECRET=$(openssl rand -base64 32)

echo "📦 Step 1: Installing system dependencies..."
sudo apt update
sudo apt install -y docker.io docker-compose postgresql-client

echo "🐳 Step 2: Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

echo "📂 Step 3: Setting up project directory..."
mkdir -p ~/cricket-backend
cd ~/cricket-backend
tar -xzf ~/backend-deploy.tar.gz

echo "🔧 Step 4: Creating .env file..."
cat > .env << EOF
# Server Configuration
PORT=8080
ENV=production

# Database Configuration
DB_HOST=${RDS_ENDPOINT}
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=${RDS_PASSWORD}
DB_NAME=cricketapp

# JWT Configuration
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=168h

# CORS
ALLOWED_ORIGINS=*
EOF

echo "✅ .env file created"

echo "🗄️  Step 5: Testing database connection..."
if PGPASSWORD=${RDS_PASSWORD} psql -h ${RDS_ENDPOINT} -U postgres -d cricketapp -c "SELECT 1;" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Database connection successful${NC}"
else
    echo -e "${RED}✗ Database connection failed${NC}"
    echo "Please check your RDS endpoint and credentials"
    exit 1
fi

echo "🔨 Step 6: Building Docker image..."
docker build -t cricket-backend:latest .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image built successfully${NC}"
else
    echo -e "${RED}✗ Docker build failed${NC}"
    exit 1
fi

echo "📝 Step 7: Creating docker-compose.prod.yml..."
cat > docker-compose.prod.yml << 'EOF'
version: '3.8'

services:
  backend:
    image: cricket-backend:latest
    ports:
      - "8080:8080"
    env_file:
      - .env
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8080/api/v1/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
EOF

echo "🚀 Step 8: Starting backend service..."
docker-compose -f docker-compose.prod.yml up -d

echo "⏳ Waiting for service to start..."
sleep 10

echo "🏥 Step 9: Health check..."
if curl -f http://localhost:8080/api/v1/health; then
    echo -e "\n${GREEN}✅ DEPLOYMENT SUCCESSFUL!${NC}"
    echo ""
    echo "================================================"
    echo "🎉 Backend is running on:"
    echo "   http://13.233.117.234:8080/api/v1"
    echo ""
    echo "📋 Useful commands:"
    echo "   View logs:    docker-compose -f docker-compose.prod.yml logs -f"
    echo "   Restart:      docker-compose -f docker-compose.prod.yml restart"
    echo "   Stop:         docker-compose -f docker-compose.prod.yml down"
    echo "   Status:       docker ps"
    echo "================================================"
else
    echo -e "\n${RED}❌ DEPLOYMENT FAILED${NC}"
    echo "Checking logs..."
    docker-compose -f docker-compose.prod.yml logs --tail=50
    exit 1
fi
