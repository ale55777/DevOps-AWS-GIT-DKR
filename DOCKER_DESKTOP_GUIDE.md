# 🐳 Docker Desktop Deployment Guide

## Complete Setup for Local Development and Testing

---

## ✅ Prerequisites

1. **Docker Desktop** installed and running
2. **Git** installed
3. **Node.js** installed (for local testing)
4. Repository cloned from GitHub

---

## 🚀 Quick Start - Deploy Everything Locally

### Step 1: Start Docker Desktop

1. Open Docker Desktop
2. Wait for it to fully start (whale icon should be steady)
3. Verify it's running:
   ```powershell
   docker --version
   docker ps
   ```

### Step 2: Build the Sample Application

```powershell
# Navigate to sample app
cd E:\DEV\devops-multicloud-project\phase2-cicd\sample-app

# Install dependencies
npm install

# Run tests to verify everything works
npm test

# Build Docker image
docker build -t devops-sample-app:latest .

# Verify image was created
docker images | findstr devops-sample-app
```

### Step 3: Run the Application

```powershell
# Run the container
docker run -d `
  --name devops-app `
  -p 3000:3000 `
  -e NODE_ENV=production `
  devops-sample-app:latest

# Check if it's running
docker ps

# View logs
docker logs devops-app

# Test the application
curl http://localhost:3000
curl http://localhost:3000/health
curl http://localhost:3000/api/info
```

### Step 4: Access the Application

Open your browser and go to:
- **Main Page**: http://localhost:3000
- **Health Check**: http://localhost:3000/health
- **API Info**: http://localhost:3000/api/info

---

## 🔧 Docker Compose Setup (Recommended)

I've created a `docker-compose.yml` file in the project root. Use it to run everything together:

```powershell
# Navigate to project root
cd E:\DEV\devops-multicloud-project

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Services Included:
- ✅ **app**: Your Node.js application (port 3000)
- ✅ **mysql**: MySQL database (port 3306)
- ✅ **redis**: Redis cache (port 6379)

---

## 🎯 Docker Desktop GUI Management

### View Running Containers:
1. Open Docker Desktop
2. Click **Containers** tab
3. See all running containers
4. Click on a container to:
   - View logs
   - Inspect details
   - Open terminal
   - Stop/Start/Restart

### View Images:
1. Click **Images** tab
2. See all built images
3. Run, delete, or inspect images

### View Volumes:
1. Click **Volumes** tab
2. See persistent data
3. Delete unused volumes

---

## 🧪 Testing the Deployment

### Test the Application:

```powershell
# Test health endpoint
curl http://localhost:3000/health

# Expected response:
# {"status":"healthy","uptime":123.456,"timestamp":"2025-12-12T..."}

# Test main endpoint
curl http://localhost:3000

# Test API info
curl http://localhost:3000/api/info

# Test echo endpoint
curl -X POST http://localhost:3000/api/echo `
  -H "Content-Type: application/json" `
  -d '{\"message\":\"Hello Docker!\"}'
```

### Test Database Connection (if using MySQL):

```powershell
# Connect to MySQL container
docker exec -it devops-mysql mysql -u devops -pChangeMe123! devopsdb

# Run SQL commands
SHOW DATABASES;
USE devopsdb;
SHOW TABLES;
EXIT;
```

### Test Redis (if using):

```powershell
# Connect to Redis
docker exec -it devops-redis redis-cli

# Test commands
PING
SET test "Hello Redis"
GET test
EXIT
```

---

## 📊 Monitoring and Logs

### View Application Logs:

```powershell
# Real-time logs
docker logs -f devops-app

# Last 100 lines
docker logs --tail 100 devops-app

# Logs with timestamps
docker logs -t devops-app
```

### View Resource Usage:

```powershell
# All containers
docker stats

# Specific container
docker stats devops-app

# One-time snapshot
docker stats --no-stream
```

### Inspect Container:

```powershell
# Full details
docker inspect devops-app

# Get IP address
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' devops-app

# Get environment variables
docker inspect -f '{{.Config.Env}}' devops-app
```

---

## 🔄 Development Workflow

### For Active Development:

```powershell
# 1. Make code changes in phase2-cicd/sample-app/

# 2. Rebuild image
docker build -t devops-sample-app:latest phase2-cicd/sample-app/

# 3. Stop old container
docker stop devops-app
docker rm devops-app

# 4. Run new container
docker run -d --name devops-app -p 3000:3000 devops-sample-app:latest

# Or use docker-compose:
docker-compose up -d --build
```

### With Live Reload (Development Mode):

```powershell
# Run with volume mount for live reload
docker run -d `
  --name devops-app-dev `
  -p 3000:3000 `
  -v ${PWD}/phase2-cicd/sample-app:/app `
  -e NODE_ENV=development `
  devops-sample-app:latest `
  npm run dev
```

---

## 🐛 Troubleshooting

### Container Won't Start:

```powershell
# Check logs
docker logs devops-app

# Check if port is already in use
netstat -ano | findstr :3000

# Kill process using port (if needed)
taskkill /PID <PID> /F
```

### Image Build Fails:

```powershell
# Build without cache
docker build --no-cache -t devops-sample-app:latest phase2-cicd/sample-app/

# Check Dockerfile syntax
docker build --progress=plain -t devops-sample-app:latest phase2-cicd/sample-app/
```

### Container Exits Immediately:

```powershell
# Run in foreground to see errors
docker run --rm -it devops-sample-app:latest

# Check exit code
docker ps -a | findstr devops-app
docker inspect devops-app | findstr ExitCode
```

### Can't Access Application:

```powershell
# Verify container is running
docker ps

# Verify port mapping
docker port devops-app

# Test from inside container
docker exec devops-app curl http://localhost:3000/health

# Check firewall
# Windows Defender Firewall → Allow an app
```

---

## 🧹 Cleanup Commands

### Remove Everything:

```powershell
# Stop all containers
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

# Remove all images
docker rmi $(docker images -q)

# Remove all volumes
docker volume prune -f

# Remove all networks
docker network prune -f

# Complete cleanup
docker system prune -a --volumes -f
```

### Remove Project Containers Only:

```powershell
# Using docker-compose
docker-compose down -v

# Manual cleanup
docker stop devops-app devops-mysql devops-redis
docker rm devops-app devops-mysql devops-redis
docker rmi devops-sample-app:latest
```

---

## 🚀 Push to Docker Hub

### Step 1: Login to Docker Hub

```powershell
docker login
# Enter username and password
```

### Step 2: Tag Your Image

```powershell
# Tag with your Docker Hub username
docker tag devops-sample-app:latest YOUR_USERNAME/devops-sample-app:latest
docker tag devops-sample-app:latest YOUR_USERNAME/devops-sample-app:v1.0.0
```

### Step 3: Push to Docker Hub

```powershell
# Push latest
docker push YOUR_USERNAME/devops-sample-app:latest

# Push versioned
docker push YOUR_USERNAME/devops-sample-app:v1.0.0
```

### Step 4: Verify on Docker Hub

1. Go to https://hub.docker.com/
2. Click on your repository
3. See your image listed

---

## 📦 Multi-Container Application

### Full Stack Deployment:

```powershell
# Start everything
docker-compose up -d

# Scale the application
docker-compose up -d --scale app=3

# View all services
docker-compose ps

# View logs for specific service
docker-compose logs -f app

# Execute command in service
docker-compose exec app sh

# Restart a service
docker-compose restart app
```

---

## 🎯 Production-Like Setup

### With Environment Variables:

Create `.env` file:
```env
NODE_ENV=production
PORT=3000
DB_HOST=devops-mysql
DB_PORT=3306
DB_NAME=devopsdb
DB_USER=devops
DB_PASSWORD=ChangeMe123!
REDIS_HOST=devops-redis
REDIS_PORT=6379
```

Run with env file:
```powershell
docker run -d `
  --name devops-app `
  -p 3000:3000 `
  --env-file .env `
  devops-sample-app:latest
```

### With Health Checks:

```powershell
docker run -d `
  --name devops-app `
  -p 3000:3000 `
  --health-cmd="node healthcheck.js" `
  --health-interval=30s `
  --health-timeout=3s `
  --health-retries=3 `
  devops-sample-app:latest

# Check health status
docker inspect --format='{{.State.Health.Status}}' devops-app
```

---

## 📊 Performance Monitoring

### Resource Limits:

```powershell
# Run with resource limits
docker run -d `
  --name devops-app `
  -p 3000:3000 `
  --memory="256m" `
  --cpus="0.5" `
  devops-sample-app:latest

# Check resource usage
docker stats devops-app
```

### View Container Metrics:

```powershell
# CPU and memory
docker stats --no-stream devops-app

# Disk usage
docker system df

# Container size
docker ps -s
```

---

## 🎉 Success Checklist

After deployment, verify:

- [ ] ✅ Docker Desktop is running
- [ ] ✅ Container is running: `docker ps`
- [ ] ✅ Application responds: http://localhost:3000
- [ ] ✅ Health check passes: http://localhost:3000/health
- [ ] ✅ Logs show no errors: `docker logs devops-app`
- [ ] ✅ Tests pass: `npm test`
- [ ] ✅ Image pushed to Docker Hub (optional)

---

## 📞 Quick Reference

### Essential Commands:

```powershell
# Build
docker build -t devops-sample-app .

# Run
docker run -d -p 3000:3000 --name devops-app devops-sample-app

# Logs
docker logs -f devops-app

# Stop
docker stop devops-app

# Remove
docker rm devops-app

# Compose
docker-compose up -d
docker-compose down
```

---

**Your Docker Desktop deployment is ready! 🐳**

Start with `docker-compose up -d` and access your app at http://localhost:3000
