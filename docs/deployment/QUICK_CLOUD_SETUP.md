# 🚀 CricketApp - Quick Cloud Deployment

## Your Problem ✅ SOLVED

Your phone can't connect to your computer's backend because:
- ❌ `10.0.2.2` only works for Android emulator, not physical phones
- ❌ Your computer is not accessible from your phone's network

**Solution:** Deploy backend to cloud (AWS/GCP/Azure) - Takes 30 minutes!

---

## 🎯 Recommended: AWS Free Tier (Easiest)

### What You Get FREE for 12 Months:
- ✅ EC2 Server (Your Go Backend)
- ✅ PostgreSQL Database (RDS)
- ✅ Perfect for mobile testing
- ✅ No credit card charges during free tier

---

## 📋 Step-by-Step (30 Minutes)

### Step 1: Create AWS Account (5 mins)
1. Go to https://aws.amazon.com/free/
2. Click "Create a Free Account"
3. Fill in your details
4. Verify email
5. Add payment method (won't be charged in free tier)

### Step 2: Launch EC2 Instance (10 mins)

**Login to AWS Console → EC2 → Launch Instance**

**Settings:**
```
Name: cricketapp-backend
AMI: Ubuntu Server 22.04 LTS (Free tier eligible)
Instance Type: t2.micro (Free tier eligible)
Key Pair: Create new → Download .pem file (SAVE THIS!)
Storage: 20GB

Security Group (IMPORTANT!):
  - SSH (Port 22): Your IP only
  - Custom TCP (Port 8080): 0.0.0.0/0 (Anywhere)
```

Click **Launch Instance** ✅

### Step 3: Setup PostgreSQL Database (10 mins)

**AWS Console → RDS → Create Database**

**Settings:**
```
Engine: PostgreSQL 15
Template: Free tier
DB Instance: db.t2.micro
DB Instance Identifier: cricketapp-db
Master Username: admin
Master Password: YourStrongPassword123! (SAVE THIS!)
Storage: 20GB
Public Access: No
VPC Security Group: Create new → Allow from EC2 security group
Initial Database Name: cricketapp_db
```

Click **Create Database** ✅

**Wait 5-10 minutes for database to be ready**

### Step 4: Upload Backend Code (5 mins)

**From your Windows computer:**

```powershell
# Navigate to your project
cd C:\Users\ASUS\Documents\CricketApp\backend

# Upload to EC2 (replace YOUR-KEY.pem and YOUR-EC2-IP)
scp -i "C:\path\to\YOUR-KEY.pem" -r * ubuntu@YOUR-EC2-IP:~/cricketapp/
```

**Or use WinSCP (easier for Windows):**
1. Download WinSCP: https://winscp.net/
2. Connect to your EC2 instance
3. Drag and drop `backend` folder

### Step 5: Configure Backend (5 mins)

**SSH into EC2:**
```bash
# From PowerShell (replace YOUR-KEY.pem and YOUR-EC2-IP)
ssh -i "C:\path\to\YOUR-KEY.pem" ubuntu@YOUR-EC2-IP
```

**Update Configuration:**
```bash
cd ~/cricketapp
nano config/config.yaml
```

**Update these values:**
```yaml
database:
  host: "YOUR-RDS-ENDPOINT.region.rds.amazonaws.com"  # From RDS Console
  port: 5432
  user: "admin"
  password: "YourStrongPassword123!"  # What you set in Step 3
  dbname: "cricketapp_db"
  sslmode: "require"

server:
  port: "8080"
  allowed_origins:
    - "*"

jwt:
  secret: "change-this-to-a-random-string-for-production"
  expiration: 24h
```

Save: `Ctrl+X`, `Y`, `Enter`

### Step 6: Deploy! (5 mins)

**Run deployment script:**
```bash
cd ~/cricketapp
chmod +x deploy-aws.sh
./deploy-aws.sh
```

**The script will:**
- ✅ Install Docker
- ✅ Install Docker Compose
- ✅ Start your backend
- ✅ Show you the public URL

**Wait for it to finish and note your PUBLIC IP!**

### Step 7: Update Flutter App (5 mins)

**On your Windows computer:**

1. **Edit API Config:**
   ```
   File: frontend/lib/core/config/api_config.dart
   ```

2. **Update these lines:**
   ```dart
   static const bool USE_CLOUD_BACKEND = true;  // Change to true
   static const String _cloudBackendUrl = 'http://YOUR_EC2_IP:8080/api/v1';  // Your EC2 IP
   ```

3. **Rebuild APK:**
   ```bash
   cd C:\Users\ASUS\Documents\CricketApp\frontend
   flutter clean
   flutter build apk --debug
   ```

4. **Install on Phone:**
   - Transfer APK from `build/app/outputs/flutter-apk/app-debug.apk`
   - Install on your phone
   - Try login/register - IT SHOULD WORK NOW! ✅

---

## 🧪 Testing

**1. Test backend is running:**
```bash
# From browser or curl
http://YOUR_EC2_IP:8080/health
```

**2. Test from your phone:**
- Open app
- Try to register new account
- Try to login

---

## 🆘 Troubleshooting

### "Can't connect to backend"
```bash
# SSH to EC2
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Check if Docker is running
docker ps

# Check logs
cd cricketapp
docker-compose logs -f

# Restart if needed
docker-compose restart
```

### "Database connection failed"
- Check RDS endpoint is correct in config
- Verify security group allows EC2 to access RDS
- Test connection: `psql -h endpoint -U admin -d cricketapp_db`

### "Still can't login from phone"
- Verify EC2 security group allows port 8080
- Check Flutter app has correct IP
- Verify you rebuilt APK after changing config
- Check phone has internet connection

---

## 💰 Cost Estimate

**First 12 Months:** $0 (Free tier)

**After 12 Months:**
- EC2 t2.micro: ~$8.50/month
- RDS db.t2.micro: ~$12/month
- Total: ~$20/month

**To stay free longer:**
- Use only 750 hours/month (don't run 24/7)
- Or migrate to Google Cloud's always-free tier

---

## 🔐 Security Notes

**Before going live (production):**
- [ ] Change JWT secret to random string
- [ ] Use strong database password
- [ ] Restrict SSH to your IP only
- [ ] Setup HTTPS with SSL certificate
- [ ] Enable database backups
- [ ] Setup CloudWatch monitoring

---

## 🎉 Success!

Once deployed, your app will work on:
- ✅ Your phone (physical device)
- ✅ Friends' phones
- ✅ Any device with internet
- ✅ Android emulator
- ✅ iOS devices (after rebuilding for iOS)

---

## 📞 Need Help?

**Common Issues:**
- Can't find RDS endpoint: RDS Console → Your DB → Connectivity & Security → Endpoint
- Can't SSH to EC2: Check key file permissions, use correct IP
- App still shows network error: Double-check Flutter config and rebuild APK

**Still stuck?** Check the full guide: `CLOUD_DEPLOYMENT_GUIDE.md`

---

## ⏭️ What's Next?

After successful deployment:
1. ✅ Test all app features
2. ✅ Invite friends to test
3. ✅ Get a custom domain (optional)
4. ✅ Setup HTTPS (optional)
5. ✅ Add monitoring (optional)

**You're ready to go! Start with Step 1 above.** 🚀
