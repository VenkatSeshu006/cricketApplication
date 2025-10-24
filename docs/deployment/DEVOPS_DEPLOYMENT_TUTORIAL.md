# 🎓 Complete DevOps Deployment Tutorial

**Learn by Doing: Deploy Your Cricket App to AWS**

---

## 📚 **Table of Contents**

1. [Understanding DevOps](#understanding-devops)
2. [AWS Infrastructure Setup](#aws-infrastructure-setup)
3. [Server Configuration](#server-configuration)
4. [Docker Deployment](#docker-deployment)
5. [Database Management](#database-management)
6. [CI/CD Concepts](#cicd-concepts)
7. [Monitoring & Logging](#monitoring--logging)
8. [Security Best Practices](#security-best-practices)

---

## 🎯 **Understanding DevOps**

### **What is DevOps?**
DevOps = **Development** + **Operations**

**Key Responsibilities:**
- 🚀 Deploy applications to production
- 🔧 Maintain infrastructure (servers, databases)
- 📊 Monitor application health
- 🔒 Ensure security & compliance
- ⚡ Automate repetitive tasks
- 🔄 Implement CI/CD pipelines

### **DevOps Tools You'll Learn Today:**
1. **AWS EC2** - Virtual servers (IaaS)
2. **AWS RDS** - Managed databases (PaaS)
3. **Docker** - Containerization
4. **SSH** - Secure remote access
5. **Git** - Version control
6. **Linux** - Server operating system
7. **Bash** - Shell scripting

### **Career Benefits:**
- 💰 High salaries ($80k-$150k+)
- 🌍 Remote-friendly roles
- 📈 High demand (shortage of skilled DevOps engineers)
- 🔄 Works with all tech stacks
- 🎓 Continuous learning opportunities

---

## 🏗️ **AWS Infrastructure Setup**

### **Step 1: Understanding AWS Services**

#### **EC2 (Elastic Compute Cloud)**
- Virtual machines in the cloud
- **Use Case**: Run your backend application
- **Cost**: t2.micro = FREE for 12 months (750 hours/month)
- **Alternatives**: Digital Ocean Droplets, Azure VMs, Google Compute Engine

#### **RDS (Relational Database Service)**
- Managed PostgreSQL/MySQL/etc
- **Use Case**: Store your app data
- **Cost**: db.t3.micro = FREE for 12 months
- **Benefits**: 
  - Automatic backups
  - Auto-scaling storage
  - Security patches
  - High availability

#### **Security Groups**
- Virtual firewalls
- Control inbound/outbound traffic
- **Think of it as**: Door locks for your servers

---

### **Step 2: Launch EC2 Instance (Practical)**

#### **2.1: Create EC2 Instance**

1. **AWS Console** → Search "EC2" → **Launch Instance**

2. **Choose Configuration:**
   ```
   Name: cricket-app-backend
   OS: Ubuntu 22.04 LTS (Why? Most popular, great community support)
   Instance Type: t2.micro (1 vCPU, 1GB RAM - free tier)
   ```

3. **Create SSH Key Pair:**
   - **What is SSH?** Secure Shell - encrypted connection to servers
   - **Key Pair**: Like a password, but more secure (public-private key cryptography)
   
   ```
   Name: cricket-app-key
   Type: RSA (encryption algorithm)
   Format: .pem (for Mac/Linux/Windows)
   ```
   
   **⚠️ IMPORTANT**: Download and save this file!
   - Location: `C:\Users\ASUS\.ssh\cricket-app-key.pem`
   - You can NEVER download it again

4. **Security Group Rules:**
   ```
   Rule 1: SSH (Port 22)
   - Purpose: Remote access to server
   - Source: My IP (your home IP - security best practice)
   
   Rule 2: Custom TCP (Port 8080)
   - Purpose: Backend API access
   - Source: 0.0.0.0/0 (anywhere - for testing)
   - Production: Restrict to specific IPs
   
   Rule 3: HTTPS (Port 443) - Optional for SSL
   - Purpose: Encrypted API access
   - Source: 0.0.0.0/0
   ```

5. **Storage:**
   ```
   8 GB gp3 SSD (General Purpose)
   - Fast enough for small apps
   - Free tier eligible
   ```

6. **Launch & Wait** (2-3 minutes)

#### **2.2: Understanding Instance Details**

Once running, note:
- **Public IPv4**: `3.84.123.45` (example)
  - This is your server's address on the internet
  - Changes if you stop/start instance (use Elastic IP for static)
- **Private IP**: `172.31.x.x` (internal AWS network)
- **Instance ID**: `i-0abc123def456` (unique identifier)

---

### **Step 3: Launch RDS PostgreSQL (Practical)**

#### **3.1: Why RDS Instead of Local PostgreSQL?**

**RDS Benefits:**
✅ Automatic backups (point-in-time recovery)
✅ Auto-patching (security updates)
✅ High availability (99.95% uptime SLA)
✅ Easy scaling (upgrade with one click)
✅ Monitoring included (CloudWatch)

**Local PostgreSQL on EC2:**
❌ You manage everything
❌ Manual backups
❌ Manual security patches
❌ Single point of failure

**DevOps Decision**: Use managed services when possible - focus on app, not infrastructure.

#### **3.2: Create RDS Instance**

1. **AWS Console** → Search "RDS" → **Create Database**

2. **Engine Options:**
   ```
   Database: PostgreSQL 15.x
   Why? - Latest stable version
        - Best performance
        - JSON support (great for APIs)
   ```

3. **Templates:**
   ```
   ✅ Free Tier
   - Limits: 750 hours/month, 20GB storage
   - Perfect for learning & small apps
   ```

4. **Settings:**
   ```
   DB Identifier: cricket-app-db
   Master Username: postgres (convention)
   Master Password: [Create strong password]
   
   Password Requirements:
   - Minimum 8 characters
   - Include: uppercase, lowercase, numbers
   - Example: CricketApp2025!
   
   ⚠️ SAVE THIS PASSWORD! You'll need it.
   ```

5. **Instance Configuration:**
   ```
   Class: db.t3.micro
   - 2 vCPUs, 1GB RAM
   - Burstable performance (good for variable workloads)
   
   Storage: 20 GB gp3
   - Auto-scaling: OFF (to stay in free tier)
   ```

6. **Connectivity:**
   ```
   VPC: Default (Virtual Private Cloud - your private network)
   Public Access: YES (for testing - in production, use private)
   Security Group: Create new "cricket-db-sg"
   Availability Zone: No preference (AWS chooses best)
   ```

7. **Database Options:**
   ```
   Initial Database Name: cricketapp
   - Creates database automatically
   - Without this, only 'postgres' database exists
   
   Port: 5432 (PostgreSQL default)
   Backup: 7 days retention
   Monitoring: Enhanced monitoring (optional)
   ```

8. **Create & Wait** (5-10 minutes)

#### **3.3: Understanding RDS Endpoint**

Once available, note:
```
Endpoint: cricket-app-db.c9x8y7z6.us-east-1.rds.amazonaws.com
Port: 5432

This is your database address. Format:
[instance-name].[random-id].[region].rds.amazonaws.com
```

---

### **Step 4: Configure Security Groups (Networking)**

#### **4.1: Understanding Security Groups**

**Concept**: Like firewall rules
- **Inbound**: Traffic coming TO your server
- **Outbound**: Traffic going FROM your server (usually allow all)
- **Stateful**: If you allow inbound, response is automatically allowed

#### **4.2: Allow EC2 to Access RDS**

**Problem**: By default, RDS blocks all connections

**Solution**: Add EC2 security group to RDS inbound rules

1. **RDS Dashboard** → Your database → **VPC Security Groups**
2. **Edit Inbound Rules** → **Add Rule**:
   ```
   Type: PostgreSQL
   Port: 5432
   Source: [Select EC2 security group from dropdown]
   Description: Allow backend to access database
   ```

**Why This Works:**
- EC2 instance has security group A
- RDS allows connections from security group A
- Result: EC2 can connect to RDS, but others can't

**Security Benefit**: Even if someone knows your RDS endpoint, they can't connect from their PC.

---

## 🔧 **Server Configuration**

### **Step 5: Connect to EC2 via SSH**

#### **5.1: Prepare SSH Key (Windows)**

```powershell
# Move key to .ssh folder (standard location)
New-Item -ItemType Directory -Force -Path "$HOME\.ssh"
Move-Item -Path "C:\Users\ASUS\Downloads\cricket-app-key.pem" -Destination "$HOME\.ssh\cricket-app-key.pem"

# Set proper permissions (important for security)
icacls "$HOME\.ssh\cricket-app-key.pem" /inheritance:r
icacls "$HOME\.ssh\cricket-app-key.pem" /grant:r "$env:USERNAME:(R)"
```

**Why?** SSH requires private keys to have restricted permissions (security requirement).

#### **5.2: Connect to Server**

```powershell
# Syntax: ssh -i [key-file] [username]@[server-ip]
ssh -i "$HOME\.ssh\cricket-app-key.pem" ubuntu@YOUR_EC2_PUBLIC_IP

# Example:
# ssh -i "$HOME\.ssh\cricket-app-key.pem" ubuntu@3.84.123.45
```

**Understanding the Command:**
- `-i`: Identity file (your private key)
- `ubuntu`: Default user for Ubuntu AMIs
- `YOUR_EC2_PUBLIC_IP`: Your server's public address

**First Connection:**
```
The authenticity of host '3.84.123.45' can't be established.
Are you sure you want to continue connecting (yes/no)?
```
Type: `yes` (this adds server to known hosts)

**Success Looks Like:**
```
Welcome to Ubuntu 22.04.3 LTS
ubuntu@ip-172-31-x-x:~$
```

You're now inside your cloud server! 🎉

#### **5.3: Understanding Linux Basics**

**Essential Commands:**
```bash
# Where am I?
pwd                 # Print working directory

# What's here?
ls -la              # List all files (including hidden)

# Navigate
cd /home/ubuntu     # Change directory
cd ..               # Go up one level
cd ~                # Go to home directory

# Create/Edit files
nano myfile.txt     # Text editor (Ctrl+X to exit)
vim myfile.txt      # Advanced editor (press 'i' to insert, ':wq' to save)

# File operations
cp file1 file2      # Copy
mv file1 file2      # Move/Rename
rm file1            # Delete
mkdir myfolder      # Create directory

# System info
df -h               # Disk space
free -h             # Memory usage
top                 # Running processes (press 'q' to quit)

# Network
curl https://api.example.com  # Make HTTP request
wget https://file.com/file    # Download file
netstat -tlnp       # See what's listening on ports
```

---

### **Step 6: Install Dependencies**

#### **6.1: Update System**

```bash
# Update package lists (like refreshing app store)
sudo apt update

# Upgrade installed packages
sudo apt upgrade -y
```

**What is `sudo`?**
- "Super User DO" - run as administrator
- Required for system changes
- `-y`: Auto-answer "yes" to prompts

#### **6.2: Install Docker**

**Why Docker?**
- ✅ Consistent environment (works on your PC, works on server)
- ✅ Easy updates (just pull new image)
- ✅ Isolation (app can't break system)
- ✅ Resource efficient (lighter than VMs)

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add ubuntu user to docker group (run docker without sudo)
sudo usermod -aG docker ubuntu

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker  # Auto-start on boot

# Verify installation
docker --version

# Test Docker
docker run hello-world
```

**Understanding Docker:**
- **Image**: Blueprint (like an APK file)
- **Container**: Running instance (like an app running)
- **Dockerfile**: Recipe to build image
- **Docker Compose**: Run multiple containers together

#### **6.3: Install Docker Compose**

```bash
# Download latest version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

#### **6.4: Install Git**

```bash
sudo apt install git -y
git --version
```

---

## 🐳 **Docker Deployment**

### **Step 7: Prepare Backend Code**

#### **7.1: Upload Code to Server**

**Option 1: Using Git (Recommended)**

```bash
# On EC2 server
cd ~
git clone https://github.com/YOUR_USERNAME/CricketApp.git
# Or if not on GitHub yet, we'll use Option 2
```

**Option 2: Using SCP from Windows (File Transfer)**

```powershell
# From your Windows PC (new PowerShell window)
cd C:\Users\ASUS\Documents\CricketApp

# Compress backend folder
Compress-Archive -Path .\backend\* -DestinationPath backend.zip

# Upload to EC2
scp -i "$HOME\.ssh\cricket-app-key.pem" backend.zip ubuntu@YOUR_EC2_IP:/home/ubuntu/

# Example:
# scp -i "$HOME\.ssh\cricket-app-key.pem" backend.zip ubuntu@3.84.123.45:/home/ubuntu/
```

**Back on EC2:**
```bash
# Install unzip
sudo apt install unzip -y

# Extract
unzip backend.zip -d cricket-backend
cd cricket-backend
```

#### **7.2: Create Environment Variables**

**Why .env file?**
- Store sensitive data (passwords, secrets)
- Different configs for dev/staging/production
- Never commit to Git (security)

```bash
# Create .env file
nano .env
```

**Copy this content (replace with YOUR values):**

```bash
# Server Configuration
PORT=8080
ENV=production

# Database Configuration (CHANGE THESE!)
DB_HOST=YOUR_RDS_ENDPOINT
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=YOUR_RDS_PASSWORD
DB_NAME=cricketapp

# JWT Configuration
JWT_SECRET=GENERATE_RANDOM_STRING_HERE
JWT_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=168h

# CORS (Allow your mobile app)
ALLOWED_ORIGINS=*
```

**Generate JWT Secret:**
```bash
# Random 32-character string
openssl rand -base64 32
# Output: 4Kf8HjN2pQ9rT1vW5xY7zA3bC6dE9fG2
```

**Save & Exit:**
- Press `Ctrl + X`
- Press `Y`
- Press `Enter`

#### **7.3: Understanding Docker Compose File**

Let's look at your `docker-compose.yml`:

```yaml
version: '3.8'

services:
  # PostgreSQL Database (for local development)
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  # Go Backend Application
  backend:
    build: .
    ports:
      - "8080:8080"
    environment:
      PORT: ${PORT}
      DB_HOST: postgres
      DB_PORT: ${DB_PORT}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      - postgres

volumes:
  postgres_data:
```

**For AWS, we need to modify this** because we're using RDS (not local PostgreSQL):

```bash
# Create new docker-compose file for production
nano docker-compose.prod.yml
```

**Content:**
```yaml
version: '3.8'

services:
  backend:
    build: .
    ports:
      - "8080:8080"
    environment:
      PORT: ${PORT}
      ENV: ${ENV}
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      JWT_SECRET: ${JWT_SECRET}
      JWT_EXPIRY: ${JWT_EXPIRY}
      REFRESH_TOKEN_EXPIRY: ${REFRESH_TOKEN_EXPIRY}
      ALLOWED_ORIGINS: ${ALLOWED_ORIGINS}
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

**Key Differences:**
- ❌ No PostgreSQL service (using RDS)
- ✅ DB_HOST points to RDS endpoint
- ✅ `restart: unless-stopped` (auto-restart on crash)
- ✅ Logging limits (prevent disk fill)

---

### **Step 8: Build & Deploy**

#### **8.1: Build Docker Image**

```bash
# Build the image
docker build -t cricket-backend:latest .

# This process:
# 1. Reads Dockerfile
# 2. Downloads Go dependencies
# 3. Compiles your code
# 4. Creates container image
```

**Understanding the Build Process:**
```dockerfile
# Your Dockerfile does this:
FROM golang:1.24-alpine AS builder    # Use Go 1.24
WORKDIR /app                          # Set working directory
COPY go.mod go.sum ./                 # Copy dependency files
RUN go mod download                   # Download dependencies
COPY . .                              # Copy all code
RUN go build -o main .                # Compile to binary

FROM alpine:latest                    # Minimal production image
COPY --from=builder /app/main .       # Copy binary only
CMD ["./main"]                        # Run on start
```

**Build Output:**
```
Step 1/10 : FROM golang:1.24-alpine AS builder
Step 2/10 : WORKDIR /app
...
Successfully built abc123def456
Successfully tagged cricket-backend:latest
```

#### **8.2: Run Database Migrations**

**What are Migrations?**
- SQL scripts that create/modify database schema
- Version control for database structure
- Run once to setup tables

```bash
# Check your migrations folder
ls internal/database/migrations/

# You should see .sql files like:
# 001_create_users_table.sql
# 002_create_matches_table.sql
# etc.
```

**Run migrations:**
```bash
# Option 1: Using migrate tool
curl -L https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-amd64.tar.gz | tar xvz
sudo mv migrate /usr/local/bin/

# Run migrations
migrate -path ./internal/database/migrations \
        -database "postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=require" \
        up

# Option 2: Let backend handle it (if coded to auto-migrate)
# Your backend should run migrations on startup
```

#### **8.3: Start Application**

```bash
# Start with Docker Compose
docker-compose -f docker-compose.prod.yml --env-file .env up -d

# Flags explained:
# -f: Use specific compose file
# --env-file: Load environment variables
# -d: Detached mode (runs in background)
```

**Check if running:**
```bash
# See running containers
docker ps

# Output:
CONTAINER ID   IMAGE                    STATUS          PORTS
abc123def456   cricket-backend:latest   Up 10 seconds   0.0.0.0:8080->8080/tcp
```

#### **8.4: Verify Deployment**

```bash
# Check logs
docker-compose -f docker-compose.prod.yml logs -f

# Look for:
✓ Connected to database
✓ Running migrations
✓ Server started on :8080

# Press Ctrl+C to exit logs

# Test health endpoint
curl http://localhost:8080/api/v1/health

# Should return:
{"status":"ok"}
```

**From your Windows PC:**
```powershell
# Test from outside (replace with your EC2 IP)
curl http://YOUR_EC2_IP:8080/api/v1/health
```

**Success!** Your backend is deployed! 🎉

---

## 🗄️ **Database Management**

### **Step 9: Managing RDS PostgreSQL**

#### **9.1: Connect to Database**

**From EC2:**
```bash
# Install PostgreSQL client
sudo apt install postgresql-client -y

# Connect to RDS
psql -h YOUR_RDS_ENDPOINT -U postgres -d cricketapp

# Enter password when prompted
```

**You're now in PostgreSQL shell:**
```sql
-- List all databases
\l

-- Connect to cricketapp
\c cricketapp

-- List all tables
\dt

-- See table structure
\d users

-- Query data
SELECT * FROM users LIMIT 5;

-- Exit
\q
```

#### **9.2: Common Database Tasks**

**Check Connection from Backend:**
```sql
-- See active connections
SELECT * FROM pg_stat_activity WHERE datname = 'cricketapp';
```

**Backup Database:**
```bash
# On EC2
pg_dump -h YOUR_RDS_ENDPOINT -U postgres -d cricketapp > backup_$(date +%Y%m%d).sql

# This creates: backup_20251024.sql
```

**Restore from Backup:**
```bash
psql -h YOUR_RDS_ENDPOINT -U postgres -d cricketapp < backup_20251024.sql
```

**Monitor Database Size:**
```sql
SELECT pg_size_pretty(pg_database_size('cricketapp'));
-- Output: 45 MB
```

---

## 🔄 **CI/CD Concepts**

### **Step 10: Continuous Integration/Deployment**

#### **10.1: What is CI/CD?**

**Continuous Integration (CI):**
- Automatically test code on every commit
- Tools: GitHub Actions, GitLab CI, Jenkins

**Continuous Deployment (CD):**
- Automatically deploy passing code to production
- Zero downtime deployments

#### **10.2: Manual Deployment Script**

Create update script for future deployments:

```bash
nano ~/deploy.sh
```

**Content:**
```bash
#!/bin/bash
set -e  # Exit on any error

echo "🚀 Deploying Cricket App Backend..."

# Navigate to project
cd ~/cricket-backend

# Pull latest code (if using Git)
# git pull origin main

# Stop running containers
echo "⏸️  Stopping current containers..."
docker-compose -f docker-compose.prod.yml down

# Rebuild image
echo "🏗️  Building new image..."
docker build -t cricket-backend:latest .

# Start containers
echo "▶️  Starting new containers..."
docker-compose -f docker-compose.prod.yml --env-file .env up -d

# Wait for health check
echo "🏥 Waiting for health check..."
sleep 10

# Test health endpoint
if curl -f http://localhost:8080/api/v1/health; then
    echo "✅ Deployment successful!"
else
    echo "❌ Deployment failed - rolling back..."
    # Could add rollback logic here
    exit 1
fi

# Show logs
echo "📋 Recent logs:"
docker-compose -f docker-compose.prod.yml logs --tail=50
```

**Make executable:**
```bash
chmod +x ~/deploy.sh
```

**Future deployments:**
```bash
./deploy.sh
```

#### **10.3: GitHub Actions CI/CD (Advanced)**

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to AWS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Deploy to EC2
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |
            cd ~/cricket-backend
            git pull
            ./deploy.sh
```

**Benefits:**
- Push to GitHub → Auto-deploys to AWS
- No manual SSH needed
- Audit trail of deployments

---

## 📊 **Monitoring & Logging**

### **Step 11: Application Monitoring**

#### **11.1: View Logs**

```bash
# Real-time logs
docker-compose -f docker-compose.prod.yml logs -f

# Last 100 lines
docker-compose -f docker-compose.prod.yml logs --tail=100

# Specific service logs
docker logs <container-id>

# Filter by time
docker logs --since 30m <container-id>
```

#### **11.2: System Monitoring**

```bash
# CPU & Memory
htop

# Disk usage
df -h

# Docker stats
docker stats
```

#### **11.3: Setup CloudWatch (AWS Monitoring)**

**Why?**
- Track CPU/Memory/Disk usage
- Set alarms (email when CPU > 80%)
- Store logs centrally

**Quick Setup:**
```bash
# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# Configure (follow AWS docs for detailed setup)
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

#### **11.4: Error Tracking**

**Log Important Events:**
```go
// In your Go code
log.Printf("INFO: User registered: %s", userID)
log.Printf("ERROR: Failed to connect to DB: %v", err)
log.Printf("WARN: Slow query detected: %s", query)
```

**Centralized Logging Solutions:**
- **ELK Stack** (Elasticsearch, Logstash, Kibana)
- **CloudWatch Logs**
- **Datadog**
- **New Relic**

---

## 🔒 **Security Best Practices**

### **Step 12: Hardening Your Deployment**

#### **12.1: Server Security**

```bash
# Update regularly
sudo apt update && sudo apt upgrade -y

# Setup firewall (UFW)
sudo ufw allow 22/tcp     # SSH
sudo ufw allow 8080/tcp   # Backend
sudo ufw enable

# Disable root login
sudo nano /etc/ssh/sshd_config
# Change: PermitRootLogin no
sudo systemctl restart ssh

# Auto security updates
sudo apt install unattended-upgrades -y
```

#### **12.2: Application Security**

**Environment Variables:**
```bash
# Never commit .env to Git!
echo ".env" >> .gitignore

# Restrict file permissions
chmod 600 .env
```

**JWT Best Practices:**
```bash
# Strong secret (32+ characters)
JWT_SECRET=$(openssl rand -base64 32)

# Short expiry (15 minutes)
JWT_EXPIRY=15m

# Use refresh tokens for long sessions
REFRESH_TOKEN_EXPIRY=168h
```

**Database Security:**
```sql
-- Create app-specific user (don't use postgres user)
CREATE USER cricketapp_user WITH PASSWORD 'strong_password';
GRANT CONNECT ON DATABASE cricketapp TO cricketapp_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cricketapp_user;
```

#### **12.3: HTTPS Setup (SSL)**

**Why HTTPS?**
- Encrypts data in transit
- Prevents man-in-the-middle attacks
- Required for production apps

**Using Let's Encrypt (Free SSL):**

```bash
# Install Certbot
sudo apt install certbot -y

# Get certificate (requires domain name)
sudo certbot certonly --standalone -d api.yourdomain.com

# Certificates saved to:
# /etc/letsencrypt/live/api.yourdomain.com/fullchain.pem
# /etc/letsencrypt/live/api.yourdomain.com/privkey.pem

# Auto-renew (cron job)
sudo crontab -e
# Add: 0 0 * * 0 certbot renew --quiet
```

**Setup Nginx Reverse Proxy:**
```bash
sudo apt install nginx -y

sudo nano /etc/nginx/sites-available/cricket-app
```

**Nginx Config:**
```nginx
server {
    listen 80;
    server_name api.yourdomain.com;
    return 301 https://$server_name$request_uri;  # Redirect to HTTPS
}

server {
    listen 443 ssl;
    server_name api.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/api.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/cricket-app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### **12.4: Backup Strategy**

**Automated RDS Backups:**
- RDS automatically backs up daily
- Retention: 7 days (configurable)
- Point-in-time recovery available

**Manual Backups:**
```bash
# Daily backup script
nano ~/backup.sh
```

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/ubuntu/backups"
mkdir -p $BACKUP_DIR

# Backup database
pg_dump -h YOUR_RDS_ENDPOINT -U postgres cricketapp > "$BACKUP_DIR/db_$DATE.sql"

# Backup application code
tar -czf "$BACKUP_DIR/app_$DATE.tar.gz" ~/cricket-backend

# Keep only last 7 days
find $BACKUP_DIR -type f -mtime +7 -delete

echo "✅ Backup completed: $DATE"
```

**Schedule with cron:**
```bash
crontab -e
# Add: 0 2 * * * ~/backup.sh  # Run daily at 2 AM
```

---

## 🎓 **DevOps Career Tips**

### **Skills to Master:**

**1. Cloud Platforms (pick one to start):**
- ☁️ AWS (most popular)
- 🌐 Azure (enterprise-focused)
- 🚀 Google Cloud (modern, developer-friendly)

**2. Containerization:**
- 🐳 Docker (essential)
- ☸️ Kubernetes (advanced orchestration)

**3. CI/CD:**
- GitHub Actions
- GitLab CI
- Jenkins

**4. Infrastructure as Code (IaC):**
- Terraform (multi-cloud)
- AWS CloudFormation
- Ansible (configuration management)

**5. Monitoring & Logging:**
- Prometheus + Grafana
- ELK Stack
- Datadog

**6. Scripting:**
- Bash (Linux automation)
- Python (automation, data processing)
- PowerShell (Windows)

### **Learning Path:**

**Month 1-2: Foundations**
- Linux basics
- Networking (TCP/IP, DNS, HTTP)
- Git version control
- Docker basics

**Month 3-4: Cloud**
- AWS fundamentals
- EC2, RDS, S3, IAM
- Deploy real projects
- Get AWS Certified Cloud Practitioner

**Month 5-6: Automation**
- CI/CD pipelines
- Infrastructure as Code
- Monitoring setup
- Get AWS Solutions Architect Associate

**Month 7-12: Advanced**
- Kubernetes
- Microservices architecture
- Security best practices
- High availability systems

### **Certification Path:**
1. ✅ AWS Certified Cloud Practitioner (entry)
2. ✅ AWS Certified Solutions Architect Associate
3. ✅ AWS Certified DevOps Engineer Professional
4. ✅ Certified Kubernetes Administrator (CKA)

### **Portfolio Projects:**
1. ✅ **This Cricket App** (full-stack deployment)
2. 🔄 CI/CD pipeline with auto-testing
3. 🎯 Kubernetes cluster (multi-service app)
4. 📊 Monitoring dashboard (Grafana)
5. 🔒 Zero-downtime deployment system

### **Salary Expectations (2025):**
- **Junior DevOps**: $60k-$85k
- **Mid-level**: $90k-$130k
- **Senior**: $130k-$180k
- **DevOps Architect**: $180k-$250k+

### **Job Boards:**
- LinkedIn Jobs
- Indeed
- AngelList (startups)
- We Work Remotely
- Remote.co

---

## 📝 **Quick Command Reference**

### **EC2 Connection**
```bash
ssh -i ~/.ssh/cricket-app-key.pem ubuntu@YOUR_EC2_IP
```

### **Docker Commands**
```bash
docker ps                          # List running containers
docker ps -a                       # List all containers
docker logs <container-id>         # View logs
docker exec -it <container-id> sh  # Enter container
docker-compose up -d               # Start services
docker-compose down                # Stop services
docker-compose restart             # Restart services
```

### **System Commands**
```bash
sudo systemctl status docker       # Check Docker status
sudo systemctl restart docker      # Restart Docker
df -h                             # Disk space
free -h                           # Memory usage
netstat -tlnp                     # Network ports
htop                              # System monitor
```

### **Database Commands**
```bash
psql -h RDS_ENDPOINT -U postgres -d cricketapp  # Connect
\dt                               # List tables
\d table_name                     # Table structure
SELECT * FROM users LIMIT 5;      # Query data
\q                                # Exit
```

---

## 🎯 **Next Steps for You**

### **Immediate (Today):**
1. ✅ Launch EC2 instance
2. ✅ Create RDS database
3. ✅ Deploy backend
4. ✅ Test API endpoints

### **This Week:**
1. 📱 Update Flutter app with EC2 IP
2. 📦 Build release APK
3. 🧪 Test all features on phone
4. 📊 Setup basic monitoring

### **This Month:**
1. 🔒 Add SSL certificate
2. 🌐 Buy domain name
3. 📈 Add CloudWatch monitoring
4. 🔄 Setup CI/CD pipeline

### **Next 3 Months:**
1. 📚 AWS Certified Cloud Practitioner
2. 🐳 Learn Kubernetes basics
3. 🏗️ Deploy with Terraform
4. 💼 Update resume, start applying

---

## 🆘 **Troubleshooting**

### **Can't connect to EC2:**
```bash
# Check security group allows SSH from your IP
# Verify key file permissions: chmod 400 ~/.ssh/key.pem
# Try: ssh -vvv (verbose mode)
```

### **Backend won't start:**
```bash
# Check logs
docker-compose logs

# Common issues:
# - Wrong DB credentials in .env
# - Port 8080 already in use
# - RDS security group blocking connection
```

### **Database connection failed:**
```bash
# Test from EC2:
telnet YOUR_RDS_ENDPOINT 5432

# If fails:
# - Check RDS security group
# - Verify RDS endpoint is correct
# - Check .env DB_HOST value
```

### **Out of memory:**
```bash
# Check usage
free -h

# Clear Docker cache
docker system prune -a

# Restart services
docker-compose restart
```

---

## 📚 **Resources**

### **AWS Documentation:**
- https://docs.aws.amazon.com/
- https://aws.amazon.com/free/ (free tier details)

### **Docker:**
- https://docs.docker.com/
- https://docker-curriculum.com/

### **DevOps Roadmap:**
- https://roadmap.sh/devops

### **Certifications:**
- https://aws.amazon.com/certification/
- https://www.cncf.io/certification/cka/

### **Communities:**
- r/devops (Reddit)
- DevOps Discord servers
- AWS Community Builders

---

## ✅ **You've Learned:**

✅ AWS infrastructure (EC2, RDS, Security Groups)
✅ Linux server administration
✅ Docker containerization
✅ Database management
✅ Deployment automation
✅ Security best practices
✅ Monitoring & logging
✅ DevOps career path

**You're now ready to:**
- Deploy production applications
- Manage cloud infrastructure
- Apply for Junior DevOps roles
- Continue learning advanced topics

---

**Let's deploy your app now!** 🚀

Provide your AWS details and I'll walk you through each command step by step.
