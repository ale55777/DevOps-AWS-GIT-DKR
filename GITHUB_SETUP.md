# 🚀 GitHub Setup Instructions

## ✅ Git Repository Initialized!

Your code has been committed locally. Now follow these steps to push to GitHub and activate the CI/CD pipeline.

---

## Step 1: Create GitHub Repository

### Option A: Using GitHub CLI (Recommended)

```powershell
# Install GitHub CLI if you haven't
# Download from: https://cli.github.com/

# Login to GitHub
gh auth login

# Create repository and push
gh repo create devops-multicloud-project --public --source=. --remote=origin --push
```

### Option B: Manual Method

1. **Go to GitHub**: https://github.com/new
2. **Repository name**: `devops-multicloud-project`
3. **Visibility**: Public (or Private)
4. **DO NOT** initialize with README, .gitignore, or license
5. Click **Create repository**

Then run:
```powershell
git remote add origin https://github.com/YOUR_USERNAME/devops-multicloud-project.git
git branch -M main
git push -u origin main
```

---

## Step 2: Add GitHub Secrets

The CI/CD pipeline needs these secrets to work. Add them in your GitHub repository:

**Go to**: Repository → Settings → Secrets and variables → Actions → New repository secret

### Required Secrets:

#### 1. **DOCKERHUB_USERNAME**
- **Value**: Your DockerHub username
- **How to get**: Your username from hub.docker.com

#### 2. **DOCKERHUB_TOKEN**
- **Value**: DockerHub access token
- **How to get**:
  1. Go to https://hub.docker.com/settings/security
  2. Click "New Access Token"
  3. Name: "GitHub Actions"
  4. Permissions: Read, Write, Delete
  5. Copy the token

#### 3. **KUBE_CONFIG** (Optional - for deployment)
- **Value**: Base64-encoded kubeconfig
- **How to get**:
  ```powershell
  # First deploy infrastructure with Terraform
  # Then configure kubectl for your cluster
  
  # For AWS:
  aws eks update-kubeconfig --region us-east-1 --name devops-eks-cluster
  
  # For Azure:
  az aks get-credentials --resource-group devops-multicloud-rg --name devops-aks-cluster
  
  # For GCP:
  gcloud container clusters get-credentials devops-gke-cluster-dev --zone us-east1-b
  
  # Then encode it:
  kubectl config view --flatten --minify > kubeconfig.yaml
  $content = Get-Content kubeconfig.yaml -Raw
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
  $base64 = [Convert]::ToBase64String($bytes)
  $base64 | Set-Clipboard
  # Now paste into GitHub secret
  ```

#### 4. **SONAR_TOKEN** (Optional - can skip SonarQube)
- **Value**: SonarQube authentication token
- **How to get**: From your SonarQube server
- **Note**: You can comment out the SonarQube steps in the workflow if you don't have it

#### 5. **SONAR_HOST_URL** (Optional)
- **Value**: Your SonarQube server URL
- **Example**: `https://sonarqube.example.com`

---

## Step 3: Update Workflow File (if needed)

The workflow is already in `.github/workflows/ci-cd.yml`

### Optional: Skip SonarQube

If you don't have SonarQube, comment out these sections in `.github/workflows/ci-cd.yml`:

```yaml
# Comment out lines 31-48 (SonarQube Scan job)
# Comment out line 52 (needs: code-quality in test job)
```

Or simply remove the `SONAR_TOKEN` and `SONAR_HOST_URL` references.

---

## Step 4: Push Workflow to GitHub

```powershell
git add .github/workflows/ci-cd.yml
git commit -m "Add GitHub Actions CI/CD workflow"
git push
```

---

## Step 5: Watch the Pipeline Run! 🎉

1. Go to your GitHub repository
2. Click on **Actions** tab
3. You should see the workflow running!

The pipeline will:
- ✅ Run code quality checks (ESLint)
- ✅ Run tests with coverage
- ✅ Build Docker image
- ✅ Scan for vulnerabilities (Trivy)
- ✅ Push to GitHub Container Registry (GHCR)
- ✅ Push to DockerHub (if secrets configured)
- ✅ Deploy to Kubernetes (if KUBE_CONFIG configured)

---

## 🎯 Quick Start (Minimal Setup)

If you just want to see the pipeline work without deployment:

### Minimum Required Secrets:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

### Steps:
```powershell
# 1. Create GitHub repo and push
gh repo create devops-multicloud-project --public --source=. --push

# 2. Add DockerHub secrets via GitHub UI

# 3. Push workflow
git add .github/workflows/ci-cd.yml
git commit -m "Add CI/CD workflow"
git push

# 4. Watch it run in Actions tab!
```

The pipeline will build and push your Docker image automatically!

---

## 📊 What the Pipeline Does

### On Every Push/PR:
1. **Code Quality** (~1 min)
   - Runs ESLint
   - Checks code formatting

2. **Tests** (~2 min)
   - Runs Jest tests
   - Generates coverage report
   - Uploads to Codecov

3. **Build** (~2 min)
   - Builds Docker image
   - Uses layer caching for speed

4. **Security Scan** (~1 min)
   - Scans with Trivy
   - Checks for vulnerabilities
   - Uploads results to GitHub Security

### On Push to Main:
5. **Push** (~30 sec)
   - Pushes to GHCR
   - Pushes to DockerHub

6. **Deploy** (~2 min)
   - Deploys to Kubernetes
   - Verifies deployment

**Total Time**: ~8-10 minutes

---

## 🔧 Troubleshooting

### Pipeline Fails on SonarQube
**Solution**: Comment out SonarQube steps or add SONAR_TOKEN secret

### Pipeline Fails on Deploy
**Solution**: Make sure KUBE_CONFIG secret is set correctly

### Docker Push Fails
**Solution**: Check DOCKERHUB_USERNAME and DOCKERHUB_TOKEN are correct

### Tests Fail
**Solution**: Run tests locally first:
```powershell
cd phase2-cicd/sample-app
npm install
npm test
```

---

## 📝 Next Steps After Pipeline Works

1. **Deploy Infrastructure**:
   ```powershell
   cd phase1-iac/terraform/azure  # or aws/gcp
   terraform init
   terraform apply
   ```

2. **Add KUBE_CONFIG secret** to enable deployment

3. **Make a change** and push to trigger pipeline

4. **Watch your app deploy** automatically!

---

## 🎉 Success Indicators

You'll know it's working when:
- ✅ Green checkmark on GitHub Actions tab
- ✅ Docker image appears in GHCR/DockerHub
- ✅ Application deployed to Kubernetes (if configured)
- ✅ No errors in pipeline logs

---

## 📞 Need Help?

Check these files:
- `DEPLOYMENT_CHECKLIST.md` - Full deployment guide
- `EXECUTION_GUIDE.md` - Step-by-step instructions
- `QUICK_REFERENCE.md` - Quick commands

---

**Your CI/CD pipeline is ready to go! Just push to GitHub and add the secrets.** 🚀
