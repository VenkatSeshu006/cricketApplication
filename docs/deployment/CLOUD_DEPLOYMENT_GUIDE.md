# CricketApp - Cloud Deployment Guide
**Date:** October 24, 2025

---

## 🚀 AWS Deployment (RECOMMENDED - Free for 12 months)

### Why AWS?
- ✅ 12 months free tier
- ✅ Best for Go + PostgreSQL combo
- ✅ Easy to setup
- ✅ Good for mobile app backend
- ✅ Your backend is already Docker-ready

---

## 📋 AWS Deployment Steps

### Step 1: Create AWS Account (5 mins)
1. Go to https://aws.amazon.com/free/
2. Sign up with your free account
3. Verify email and payment method (won't be charged in free tier)

### Step 2: Launch EC2 Instance (10 mins)

**Instance Configuration:**
- **AMI:** Ubuntu Server 22.04 LTS (Free tier eligible)
- **Instance Type:** t2.micro (1 vCPU, 1GB RAM)
- **Storage:** 20GB (Free tier allows up to 30GB)
- **Security Group:** 
  - Port 22 (SSH) - Your IP only
  - Port 8080 (Backend API) - 0.0.0.0/0 (anywhere)
  - Port 5432 (PostgreSQL) - Only from EC2 security group

### Step 3: Setup RDS PostgreSQL (10 mins)

**Database Configuration:**
- **Engine:** PostgreSQL 15
- **Instance Class:** db.t2.micro (Free tier)
- **Storage:** 20GB
- **Username:** cricketapp_admin
- **Database Name:** cricketapp_db
- **Public Access:** No (only EC2 can access)

### Step 4: Deploy Backend (15 mins)

**SSH into EC2:**
```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

**Install Docker & Docker Compose:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout and login again for docker group to take effect
exit
```

**Clone Your Repository:**
```bash
# If you have it on GitHub
git clone https://github.com/your-username/CricketApp.git
cd CricketApp/backend

# OR upload via SCP from your computer
# From your Windows machine:
# scp -i your-key.pem -r C:\Users\ASUS\Documents\CricketApp\backend ubuntu@your-ec2-ip:~/
```

**Update Configuration:**
```bash
# Edit config file
nano config/config.yaml
```

**Update with RDS details:**
```yaml
database:
  host: "your-rds-endpoint.region.rds.amazonaws.com"
  port: 5432
  user: "cricketapp_admin"
  password: "your-db-password"
  dbname: "cricketapp_db"
  sslmode: "require"

server:
  port: "8080"
  allowed_origins:
    - "*"  # For testing, restrict in production

jwt:
  secret: "your-super-secret-jwt-key-change-this-in-production"
  expiration: 24h
```

**Start Backend:**
```bash
# Using Docker Compose
docker-compose up -d

# Check logs
docker-compose logs -f

# Check if running
curl http://localhost:8080/health
```

### Step 5: Update Flutter App (5 mins)

**Update API Config:**

Edit: `frontend/lib/core/config/api_config.dart`

```dart
class ApiConfig {
  // Replace with your EC2 public IP
  static const String _productionBackendUrl = 'http://YOUR_EC2_PUBLIC_IP:8080/api/v1';

  static String get baseUrl {
    // Use production URL for mobile app
    return _productionBackendUrl;
  }
  
  // ... rest of the code
}
```

**Rebuild APK:**
```bash
cd frontend
flutter clean
flutter pub get
flutter build apk --debug
```

**Install new APK on your phone and test!**

---

## 🎯 Alternative: Google Cloud (Also Good)

### Why Google Cloud?
- ✅ $300 credit for 90 days
- ✅ Always free tier after credit expires
- ✅ Cloud Run (serverless) - easier deployment

### Google Cloud Run Deployment

**Quick Steps:**

1. **Enable Cloud Run API:**
   - Go to Google Cloud Console
   - Enable Cloud Run API

2. **Install Google Cloud SDK:**
   ```bash
   # On your Windows machine
   # Download from: https://cloud.google.com/sdk/docs/install
   ```

3. **Deploy with Docker:**
   ```bash
   cd backend
   
   # Build and push to Google Container Registry
   gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/cricketapp-backend
   
   # Deploy to Cloud Run
   gcloud run deploy cricketapp-backend \
     --image gcr.io/YOUR_PROJECT_ID/cricketapp-backend \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated \
     --set-env-vars "DATABASE_HOST=YOUR_CLOUD_SQL_IP,DATABASE_PORT=5432"
   ```

4. **Setup Cloud SQL (PostgreSQL):**
   - Create PostgreSQL instance
   - Note the connection string
   - Update backend environment variables

---

## 🔵 Azure (Student Subscription)

### Why Azure?
- ✅ Free $100 credit
- ✅ Good for students
- ✅ App Service supports Docker

### Azure App Service Deployment

**Quick Steps:**

1. **Create Resource Group:**
   ```bash
   az group create --name CricketApp-RG --location eastus
   ```

2. **Create PostgreSQL Database:**
   ```bash
   az postgres flexible-server create \
     --resource-group CricketApp-RG \
     --name cricketapp-db \
     --location eastus \
     --admin-user adminuser \
     --admin-password YourPassword123! \
     --sku-name Standard_B1ms \
     --tier Burstable \
     --version 15
   ```

3. **Deploy Container to App Service:**
   ```bash
   az appservice plan create \
     --name CricketApp-Plan \
     --resource-group CricketApp-RG \
     --is-linux \
     --sku B1
   
   az webapp create \
     --resource-group CricketApp-RG \
     --plan CricketApp-Plan \
     --name cricketapp-backend \
     --deployment-container-image-name your-dockerhub-username/cricketapp:latest
   ```

---

## 📊 Comparison

| Feature | AWS EC2 | Google Cloud Run | Azure App Service |
|---------|---------|------------------|-------------------|
| **Free Tier** | 12 months | Always free (with limits) | $100 credit |
| **Setup Complexity** | Medium | Easy | Medium |
| **Cost After Free** | ~$10-20/month | Pay per use (~$5-10) | ~$15-25/month |
| **Best For** | Full control | Serverless/auto-scale | Enterprise/Students |
| **Docker Support** | ✅ Yes | ✅ Yes | ✅ Yes |
| **PostgreSQL** | RDS Free tier | Cloud SQL | Azure Database |
| **Recommended?** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 🎯 My Recommendation

**Use AWS EC2 + RDS for your CricketApp:**

### Reasons:
1. ✅ **12 months completely free** (perfect for development/testing)
2. ✅ **Your backend is ready** (Docker setup already done)
3. ✅ **Simple to understand** (one server, one database)
4. ✅ **Full control** (can SSH, debug, view logs)
5. ✅ **Scalable** (easy to upgrade later)

### Cost Estimate:
- **Months 1-12:** $0 (Free tier)
- **After 12 months:** ~$10-15/month (can optimize or switch)

---

## 🚀 Quick Start (AWS - 30 Minutes)

```bash
# 1. Create AWS Account (if you haven't)
# Go to https://aws.amazon.com/free/

# 2. Launch EC2 Instance
# - Ubuntu 22.04 LTS
# - t2.micro (Free tier)
# - Open port 8080

# 3. Setup RDS PostgreSQL
# - db.t2.micro (Free tier)
# - Note the endpoint

# 4. SSH to EC2 and run:
sudo apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 5. Upload your backend code
# 6. Update config with RDS endpoint
# 7. Run: docker-compose up -d

# 8. Get your EC2 public IP
curl ifconfig.me

# 9. Update Flutter app with: http://YOUR_EC2_IP:8080/api/v1
# 10. Rebuild APK and test!
```

---

## 🔒 Security Checklist

Before going live:

- [ ] Change JWT secret in config
- [ ] Use strong database password
- [ ] Restrict EC2 security group (not 0.0.0.0/0 for SSH)
- [ ] Enable HTTPS (use Let's Encrypt)
- [ ] Setup database backups
- [ ] Enable CloudWatch monitoring
- [ ] Setup IAM roles properly
- [ ] Use environment variables (not hardcoded credentials)

---

## 📱 Testing After Deployment

1. **Test from browser:**
   ```
   http://YOUR_EC2_IP:8080/health
   ```

2. **Test from your phone:**
   - Rebuild APK with new URL
   - Install on phone
   - Try login/register

3. **Check logs if issues:**
   ```bash
   ssh ubuntu@your-ec2-ip
   cd backend
   docker-compose logs -f
   ```

---

## 🆘 Troubleshooting

### Can't connect to EC2:
- Check security group allows port 8080
- Check EC2 public IP is correct
- Ensure backend is running: `docker ps`

### Can't connect to database:
- Check RDS security group allows EC2
- Verify database endpoint in config
- Test connection: `psql -h endpoint -U user -d dbname`

### App still shows network error:
- Verify backend health: `curl http://YOUR_IP:8080/health`
- Check Flutter app has correct URL
- Rebuild APK after URL change
- Check phone has internet connection

---

## 💡 Next Steps After AWS Setup

1. **Get a Domain Name** (optional):
   - Use Route 53 or Namecheap
   - Point to your EC2 IP
   - Update Flutter app to use domain

2. **Setup HTTPS:**
   - Install Nginx on EC2
   - Get SSL certificate from Let's Encrypt
   - Configure reverse proxy

3. **Setup CI/CD:**
   - GitHub Actions for auto-deployment
   - Push code → Auto deploy to EC2

4. **Monitor Your App:**
   - CloudWatch for logs
   - Setup alerts for errors
   - Monitor costs

---

**Ready to deploy? Start with AWS - it's the easiest for your setup!** 🚀
