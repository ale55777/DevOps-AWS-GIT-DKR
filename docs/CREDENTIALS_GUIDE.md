# 🔑 Required Credentials and Setup Guide

## What You Need from Each Cloud Provider

This guide explains exactly what credentials and information you need to deploy your infrastructure.

---

## 📋 Quick Summary

### **For Local Deployment (Terraform + Ansible):**
- ✅ AWS Access Keys
- ✅ Azure Service Principal
- ✅ GCP Service Account Key
- ✅ SSH Keys for servers

### **For CI/CD Pipeline:**
- ✅ DockerHub credentials (already have this)
- ✅ Kubernetes config (after deploying infrastructure)

---

## 1️⃣ AWS Credentials

### What You Need:
1. **AWS Access Key ID**
2. **AWS Secret Access Key**
3. **AWS Region** (default: us-east-1)

### How to Get Them:

#### Step 1: Create IAM User
1. Go to AWS Console: https://console.aws.amazon.com/
2. Navigate to **IAM** → **Users** → **Add users**
3. Username: `terraform-user`
4. Access type: ✅ **Programmatic access**
5. Click **Next: Permissions**

#### Step 2: Attach Policies
Attach these policies:
- ✅ `AdministratorAccess` (for demo/learning)
  
  **OR** for production, create custom policy with:
  - EC2 Full Access
  - VPC Full Access
  - EKS Full Access
  - S3 Full Access
  - RDS Full Access
  - IAM Limited Access

#### Step 3: Get Credentials
1. Click **Create user**
2. **IMPORTANT**: Copy and save:
   - Access Key ID: `AKIA...`
   - Secret Access Key: `wJalrXUtn...`
3. **You won't see the secret key again!**

### How to Configure:

```powershell
# Method 1: Using AWS CLI
aws configure
# Enter:
# - AWS Access Key ID: AKIA...
# - AWS Secret Access Key: wJalrXUtn...
# - Default region: us-east-1
# - Default output format: json

# Method 2: Manual configuration
# Create file: C:\Users\YOUR_USERNAME\.aws\credentials
[default]
aws_access_key_id = AKIA...
aws_secret_access_key = wJalrXUtn...

# Create file: C:\Users\YOUR_USERNAME\.aws\config
[default]
region = us-east-1
output = json
```

### Verify Setup:
```powershell
aws sts get-caller-identity
# Should show your account ID and user ARN
```

---

## 2️⃣ Azure Credentials

### What You Need:
1. **Subscription ID**
2. **Client ID** (Application ID)
3. **Client Secret** (Password)
4. **Tenant ID**

### How to Get Them:

#### Step 1: Get Subscription ID
1. Go to Azure Portal: https://portal.azure.com/
2. Search for **Subscriptions**
3. Copy your **Subscription ID**

#### Step 2: Create Service Principal
```powershell
# Login to Azure
az login

# Create service principal
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Output will be:
{
  "appId": "12345678-1234-1234-1234-123456789abc",      # This is CLIENT_ID
  "displayName": "terraform-sp",
  "password": "abcdefgh-1234-5678-90ab-cdefghijklmn",   # This is CLIENT_SECRET
  "tenant": "87654321-4321-4321-4321-210987654321"      # This is TENANT_ID
}
```

**IMPORTANT**: Save all these values immediately!

### How to Configure:

```powershell
# Method 1: Environment Variables (Recommended)
$env:ARM_CLIENT_ID = "12345678-1234-1234-1234-123456789abc"
$env:ARM_CLIENT_SECRET = "abcdefgh-1234-5678-90ab-cdefghijklmn"
$env:ARM_SUBSCRIPTION_ID = "YOUR_SUBSCRIPTION_ID"
$env:ARM_TENANT_ID = "87654321-4321-4321-4321-210987654321"

# Method 2: Add to PowerShell Profile
notepad $PROFILE
# Add the above lines to the file

# Method 3: Create terraform.tfvars in azure folder
# File: phase1-iac/terraform/azure/terraform.tfvars
subscription_id = "YOUR_SUBSCRIPTION_ID"
```

### Verify Setup:
```powershell
az account show
# Should show your subscription details
```

---

## 3️⃣ GCP Credentials

### What You Need:
1. **Project ID**
2. **Service Account Key** (JSON file)

### How to Get Them:

#### Step 1: Get Project ID
1. Go to GCP Console: https://console.cloud.google.com/
2. Click project dropdown at top
3. Copy your **Project ID** (not project name!)

#### Step 2: Create Service Account
1. Go to **IAM & Admin** → **Service Accounts**
2. Click **Create Service Account**
3. Name: `terraform-sa`
4. Click **Create and Continue**
5. Role: **Editor** (or **Owner** for full access)
6. Click **Done**

#### Step 3: Create Key
1. Click on the service account you just created
2. Go to **Keys** tab
3. Click **Add Key** → **Create new key**
4. Type: **JSON**
5. Click **Create**
6. **Save the JSON file** (e.g., `gcp-terraform-key.json`)

#### Step 4: Enable APIs
```powershell
gcloud auth login

# Set project
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable storage-api.googleapis.com
```

### How to Configure:

```powershell
# Method 1: Environment Variable (Recommended)
$env:GOOGLE_APPLICATION_CREDENTIALS = "C:\path\to\gcp-terraform-key.json"

# Method 2: Add to PowerShell Profile
notepad $PROFILE
# Add:
$env:GOOGLE_APPLICATION_CREDENTIALS = "C:\Users\YOUR_USERNAME\gcp-terraform-key.json"

# Method 3: Update variables.tf in GCP folder
# Edit: phase1-iac/terraform/gcp/variables.tf
# Change the default project_id to your actual project ID
```

### Verify Setup:
```powershell
gcloud auth application-default print-access-token
# Should print an access token
```

---

## 4️⃣ SSH Keys (For Ansible)

### What You Need:
1. **SSH Private Key**
2. **SSH Public Key**

### How to Generate:

```powershell
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "devops@example.com"
# Save to: C:\Users\YOUR_USERNAME\.ssh\id_rsa
# Press Enter for no passphrase (or set one)

# This creates:
# - Private key: C:\Users\YOUR_USERNAME\.ssh\id_rsa
# - Public key: C:\Users\YOUR_USERNAME\.ssh\id_rsa.pub
```

### How to Use:

1. **Add public key to cloud instances** when creating them
2. **Update Ansible inventory** with the private key path:

```ini
# Edit: phase1-iac/ansible/inventory/hosts
[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=C:\Users\YOUR_USERNAME\.ssh\id_rsa
ansible_python_interpreter=/usr/bin/python3
```

---

## 5️⃣ What to Update in Project Files

### AWS Files:

**File**: `phase1-iac/terraform/aws/variables.tf`

No changes needed! Default values are fine. But you can customize:
```hcl
variable "aws_region" {
  default = "us-east-1"  # Change if you want different region
}

variable "cluster_name" {
  default = "devops-eks-cluster"  # Change if you want different name
}
```

### Azure Files:

**File**: `phase1-iac/terraform/azure/variables.tf`

Update if needed:
```hcl
variable "location" {
  default = "East US"  # Change to your preferred region
}

variable "resource_group_name" {
  default = "devops-multicloud-rg"  # Change if you want different name
}
```

### GCP Files:

**File**: `phase1-iac/terraform/gcp/variables.tf`

**REQUIRED**: Update your project ID:
```hcl
variable "project_id" {
  default = "YOUR_ACTUAL_PROJECT_ID"  # ⚠️ MUST CHANGE THIS!
}

variable "region" {
  default = "us-east1"  # Change if you want different region
}
```

### Ansible Files:

**File**: `phase1-iac/ansible/inventory/hosts`

After deploying infrastructure, add your server IPs:
```ini
[aws_nodes]
aws-node-1 ansible_host=3.80.123.45  # Replace with actual EC2 IP

[azure_nodes]
azure-node-1 ansible_host=20.120.45.67  # Replace with actual Azure VM IP

[gcp_nodes]
gcp-node-1 ansible_host=35.190.12.34  # Replace with actual GCP VM IP
```

---

## 6️⃣ For CI/CD Pipeline (GitHub Secrets)

### Already Have:
- ✅ DOCKERHUB_USERNAME
- ✅ DOCKERHUB_TOKEN

### Optional (For Kubernetes Deployment):

**KUBE_CONFIG** - After deploying infrastructure:

```powershell
# For AWS EKS:
aws eks update-kubeconfig --region us-east-1 --name devops-eks-cluster

# For Azure AKS:
az aks get-credentials --resource-group devops-multicloud-rg --name devops-aks-cluster

# For GCP GKE:
gcloud container clusters get-credentials devops-gke-cluster-dev --zone us-east1-b

# Then encode for GitHub secret:
kubectl config view --flatten --minify > kubeconfig.yaml
$content = Get-Content kubeconfig.yaml -Raw
$bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
$base64 = [Convert]::ToBase64String($bytes)
$base64 | Set-Clipboard
# Paste into GitHub secret: KUBE_CONFIG
```

---

## 📝 Complete Setup Checklist

### Before Deploying Infrastructure:

#### AWS:
- [ ] Create IAM user with programmatic access
- [ ] Save Access Key ID and Secret Access Key
- [ ] Run `aws configure` to set up credentials
- [ ] Verify with `aws sts get-caller-identity`

#### Azure:
- [ ] Get Subscription ID from Azure Portal
- [ ] Create Service Principal with `az ad sp create-for-rbac`
- [ ] Save appId, password, tenant
- [ ] Set environment variables (ARM_CLIENT_ID, etc.)
- [ ] Verify with `az account show`

#### GCP:
- [ ] Get Project ID from GCP Console
- [ ] Create Service Account
- [ ] Download JSON key file
- [ ] Set GOOGLE_APPLICATION_CREDENTIALS environment variable
- [ ] Update project_id in variables.tf
- [ ] Enable required APIs
- [ ] Verify with `gcloud auth application-default print-access-token`

#### SSH:
- [ ] Generate SSH key pair with `ssh-keygen`
- [ ] Save private and public keys
- [ ] Update Ansible inventory with key path

---

## 🚀 Ready to Deploy?

Once you have all credentials configured, you can deploy:

```powershell
# AWS
cd E:\DEV\devops-multicloud-project\phase1-iac\terraform\aws
terraform init
terraform plan
terraform apply

# Azure
cd E:\DEV\devops-multicloud-project\phase1-iac\terraform\azure
terraform init
terraform plan
terraform apply

# GCP
cd E:\DEV\devops-multicloud-project\phase1-iac\terraform\gcp
terraform init
terraform plan
terraform apply
```

---

## ⚠️ Important Security Notes

1. **Never commit credentials to Git**
   - ✅ .gitignore already configured
   - ✅ Credentials files are excluded

2. **Use environment variables**
   - Safer than hardcoding
   - Easy to rotate

3. **Rotate keys regularly**
   - Change every 90 days
   - Especially for production

4. **Use least privilege**
   - Only grant necessary permissions
   - Create separate users for different purposes

5. **Enable MFA**
   - On all cloud accounts
   - Especially root/admin accounts

---

## 🆘 Troubleshooting

### "Access Denied" errors:
- Check credentials are correct
- Verify IAM permissions
- Ensure environment variables are set

### "Project not found" (GCP):
- Verify project ID is correct
- Check you're using project ID, not project name
- Ensure APIs are enabled

### "Subscription not found" (Azure):
- Verify subscription ID
- Check service principal has Contributor role
- Ensure you're logged into correct tenant

---

## 📞 Quick Reference

### Check Current Configuration:

```powershell
# AWS
aws configure list
aws sts get-caller-identity

# Azure
az account show
az account list

# GCP
gcloud config list
gcloud auth list
gcloud projects list
```

---

## ✅ Summary

**You need from each cloud:**

| Cloud | What You Need | How to Get |
|-------|---------------|------------|
| **AWS** | Access Key ID, Secret Key | IAM → Users → Create user |
| **Azure** | Client ID, Secret, Tenant, Subscription | `az ad sp create-for-rbac` |
| **GCP** | Project ID, Service Account JSON | IAM → Service Accounts → Create |
| **SSH** | Private/Public key pair | `ssh-keygen -t rsa -b 4096` |

**I don't need you to give me these credentials!** 

You'll configure them on your local machine using the commands above. The credentials stay on your computer and are used by Terraform to deploy infrastructure.

---

**Ready to set up your credentials? Follow the steps above for each cloud you want to use!** 🚀
