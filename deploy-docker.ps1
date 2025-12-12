# 🚀 Complete Deployment Automation Script
# Run this script to deploy everything automatically

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DevOps Multi-Cloud Project Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Docker Desktop
Write-Host "[1/5] Checking Docker Desktop..." -ForegroundColor Yellow
try {
    docker --version | Out-Null
    Write-Host "✓ Docker Desktop is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker Desktop is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and run this script again." -ForegroundColor Red
    exit 1
}

# Step 2: Build Docker Image
Write-Host ""
Write-Host "[2/5] Building Docker image..." -ForegroundColor Yellow
docker build -t devops-sample-app:latest phase2-cicd/sample-app
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Docker image built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Docker build failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Stop and remove old container if exists
Write-Host ""
Write-Host "[3/5] Cleaning up old containers..." -ForegroundColor Yellow
docker stop devops-app 2>$null
docker rm devops-app 2>$null
Write-Host "✓ Cleanup complete" -ForegroundColor Green

# Step 4: Run the container
Write-Host ""
Write-Host "[4/5] Starting application container..." -ForegroundColor Yellow
docker run -d `
  --name devops-app `
  -p 3000:3000 `
  -e NODE_ENV=production `
  devops-sample-app:latest

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Container started successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to start container!" -ForegroundColor Red
    exit 1
}

# Step 5: Wait and test
Write-Host ""
Write-Host "[5/5] Testing application..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Application is healthy!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Application may still be starting..." -ForegroundColor Yellow
}

# Display results
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Application URLs:" -ForegroundColor White
Write-Host "  • Main Page:    http://localhost:3000" -ForegroundColor Cyan
Write-Host "  • Health Check: http://localhost:3000/health" -ForegroundColor Cyan
Write-Host "  • API Info:     http://localhost:3000/api/info" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor White
Write-Host "  • View logs:    docker logs -f devops-app" -ForegroundColor Yellow
Write-Host "  • Stop app:     docker stop devops-app" -ForegroundColor Yellow
Write-Host "  • Restart app:  docker restart devops-app" -ForegroundColor Yellow
Write-Host "  • Remove app:   docker rm -f devops-app" -ForegroundColor Yellow
Write-Host ""
Write-Host "Opening application in browser..." -ForegroundColor Green
Start-Sleep -Seconds 2
Start-Process "http://localhost:3000"
