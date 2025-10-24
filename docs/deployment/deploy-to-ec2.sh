#!/bin/bash
set -e

echo "🚀 Cricket App Backend Deployment"
echo "=================================="

# Update system
echo "📦 Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker ubuntu
    rm get-docker.sh
fi

# Install Docker Compose
echo "📦 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Start Docker
echo "▶️  Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Extract backend code
echo "📂 Extracting backend code..."
mkdir -p ~/cricket-backend
tar -xzf ~/backend-deploy.tar.gz -C ~/cricket-backend
cd ~/cricket-backend

# Build and start
echo "🏗️  Building Docker image..."
sudo docker build -t cricket-backend:latest .

echo "🚀 Starting application..."
sudo docker-compose -f docker-compose.prod.yml --env-file .env up -d

# Wait for startup
echo "⏳ Waiting for application to start..."
sleep 10

# Check health
echo "🏥 Checking application health..."
if curl -f http://localhost:8080/api/v1/health; then
    echo ""
    echo "✅ Deployment successful!"
    echo "🌐 Backend is running at: http://13.233.117.234:8080"
    echo "📊 API Docs: http://13.233.117.234:8080/api/v1/health"
else
    echo ""
    echo "❌ Health check failed. Checking logs..."
    sudo docker-compose -f docker-compose.prod.yml logs --tail=50
    exit 1
fi

echo ""
echo "📋 Useful commands:"
echo "  View logs: cd ~/cricket-backend && sudo docker-compose -f docker-compose.prod.yml logs -f"
echo "  Restart: cd ~/cricket-backend && sudo docker-compose -f docker-compose.prod.yml restart"
echo "  Stop: cd ~/cricket-backend && sudo docker-compose -f docker-compose.prod.yml down"
