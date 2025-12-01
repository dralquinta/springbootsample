# Docker Push to OCIR Script Guide

## Overview

The `docker-push.sh` script automates pushing your Docker image to Oracle Cloud Infrastructure Registry (OCIR). It can auto-detect local image tags for seamless pushing without rebuilding.

## Key Feature: Auto-Tag Detection

The script automatically detects the tag of an already-built local image (typically `latest`) and uses it for OCIR without requiring a full rebuild.

### How It Works

1. **Build once with build.sh:**
   ```bash
   ./build.sh --docker              # Creates employeemaintainer:latest
   ```

2. **Push with auto-detection:**
   ```bash
   ./docker-push.sh \
     --region phx.ocir.io \
     --user TenantID/oracleidentitycloudservice/user@example.com \
     --password 'auth_token' \
     --repository tenant/myapp
   # Script automatically detects and uses 'latest' tag
   ```

The script will tag your local image as `phx.ocir.io/tenant/myapp/employeemaintainer:latest` automatically.

## Prerequisites

- Docker installed and running
- OCI account with OCIR access
- Auth token created in OCI Console
- Repository created in OCIR

## Getting Your OCIR Credentials

### 1. Create an Auth Token

1. Log in to OCI Console
2. Navigate to **User Settings** (click your profile icon)
3. Click **Auth Tokens** in the left menu
4. Click **Generate Token**
5. Give it a description (e.g., "Docker Push")
6. Copy the generated token immediately (you won't be able to see it again)

### 2. Get Your Username

Format: `TenantID/oracleidentitycloudservice/USERNAME@EMAIL.COM`

Example: `my-tenancy/oracleidentitycloudservice/john.doe@example.com`

### 3. Create a Repository

1. In OCI Console, navigate to **Container Registries** > **Repositories**
2. Click **Create Repository**
3. Enter repository name (e.g., `myapp`)
4. Note the full path format: `tenant/repository`

## OCIR Regions

| Region | OCIR URL |
|--------|----------|
| US Phoenix | phx.ocir.io |
| US Ashburn (IAD) | iad.ocir.io |
| Frankfurt | fra.ocir.io |
| London | lhr.ocir.io |
| Sydney | syd.ocir.io |
| Seoul | icn.ocir.io |
| Tokyo | nrt.ocir.io |
| Mumbai | bom.ocir.io |
| São Paulo | gru.ocir.io |

## Usage

### Basic Usage

```bash
./docker-push.sh \
  --region phx.ocir.io \
  --user TenantID/oracleidentitycloudservice/username@example.com \
  --password 'auth_token_here' \
  --repository tenant/myapp
```

### With Custom Tag

```bash
./docker-push.sh \
  --region phx.ocir.io \
  --user TenantID/oracleidentitycloudservice/username@example.com \
  --password 'auth_token_here' \
  --repository tenant/myapp \
  --tag v1.0.0
```

### Build and Push

```bash
./docker-push.sh \
  --region phx.ocir.io \
  --user TenantID/oracleidentitycloudservice/username@example.com \
  --password 'auth_token_here' \
  --repository tenant/myapp \
  --build
```

### Using Environment Variables (Secure)

```bash
export OCIR_REGION="phx.ocir.io"
export OCIR_USER="TenantID/oracleidentitycloudservice/username@example.com"
export OCIR_PASSWORD="auth_token_here"
export OCIR_REPO="tenant/myapp"

./docker-push.sh \
  --region "$OCIR_REGION" \
  --user "$OCIR_USER" \
  --password "$OCIR_PASSWORD" \
  --repository "$OCIR_REPO"
```

## Security Best Practices

⚠️ **IMPORTANT:**

1. **Never commit credentials to version control**
   - Never put auth tokens or passwords in files committed to git
   - Use `.gitignore` to exclude credential files

2. **Use environment variables for sensitive data**
   ```bash
   export OCIR_PASSWORD=$(cat /path/to/secret/token)
   ```

3. **Rotate auth tokens regularly**
   - Delete old tokens in OCI Console
   - Create new tokens periodically

4. **Use a secure credential manager**
   - Consider using `pass`, `keepass`, or similar for local development
   - Use OCI Vault for production deployments

5. **Restrict token permissions**
   - Create separate tokens for different purposes
   - Use the minimum required permissions

## Troubleshooting

### "Failed to log in to OCIR"

**Possible causes:**
- Invalid region: Check OCIR region format (should be `region.ocir.io`)
- Invalid credentials: Verify username and auth token
- Expired token: Create a new auth token
- Network issues: Check your internet connection

### "Docker image not found"

**Solution:**
- Build the image first: `./build.sh --docker`
- Or use `--build` flag: `./docker-push.sh --build ...`

### "Repository not found"

**Solution:**
- Create the repository in OCIR first
- Ensure you have the correct repository path

## Complete Workflow

```bash
# 1. Build the application
./build.sh --skip-tests

# 2. Build Docker image
./build.sh --docker

# 3. Push to OCIR
./docker-push.sh \
  --region phx.ocir.io \
  --user TenantID/oracleidentitycloudservice/username@example.com \
  --password 'auth_token' \
  --repository tenant/employee-api \
  --tag v1.0.0

# 4. Pull and run from OCIR
docker pull phx.ocir.io/tenant/employee-api/employeemaintainer:v1.0.0
docker run -p 8080:8080 phx.ocir.io/tenant/employee-api/employeemaintainer:v1.0.0
```

## Using with OKE (Oracle Kubernetes Engine)

```bash
# Update your Kubernetes deployment
kubectl set image deployment/myapp \
  myapp=phx.ocir.io/tenant/employee-api/employeemaintainer:v1.0.0

# Or use in your deployment YAML
# image: phx.ocir.io/tenant/employee-api/employeemaintainer:v1.0.0
```

## Additional Resources

- [Oracle Cloud Infrastructure Registry Documentation](https://docs.oracle.com/en-us/iaas/Content/Registry/home.htm)
- [Docker Login Documentation](https://docs.docker.com/engine/reference/commandline/login/)
- [OKE Documentation](https://docs.oracle.com/en-us/iaas/Content/ContEng/home.htm)

## Support

For issues with OCIR or OCI:
- Check OCI Status Page: https://status.oracle.com/
- Review OCI IAM policies
- Contact OCI Support: https://www.oracle.com/cloud/support/
