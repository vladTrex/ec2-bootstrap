# EC2 Bootstrap - Minimal Pet Project

Simple project for learning basic backend and infrastructure skills.

## Project Structure

```
.
├── server.js              # Express app with /health and /data endpoints
├── package.json           # Node.js dependencies
├── Dockerfile             # Docker image for the app
├── docker-compose.yml     # Docker Compose configuration
├── terraform/             # Terraform configuration for AWS
│   ├── main.tf           # Main resources (EC2, Security Group)
│   ├── variables.tf      # Terraform variables
│   └── terraform.tfvars.example  # Configuration example
└── README.md             # This file
```

## Local Development

1. Install dependencies:
```bash
npm install
```

2. Start server:
```bash
npm start
```

3. Test endpoints:
- http://localhost:3030/health
- http://localhost:3030/data

## Docker

### Build image:
```bash
docker build -t ec2-bootstrap:latest .
```

### Run container:
```bash
docker run -p 3030:3030 ec2-bootstrap:latest
```

### Docker Compose:
```bash
docker compose up
```

### Run tests in Docker:

**Option 1: Using Docker Compose (recommended)**
```bash
docker compose run --rm test
```

**Option 2: Using Docker directly**
```bash
docker build -t ec2-bootstrap:latest .
docker run --rm ec2-bootstrap:latest npm test
```

**Option 3: Run tests in running container**
```bash
# Rebuild image first if needed
docker compose build
docker compose up -d
docker exec ec2-bootstrap npm test
```

**Note:** If you get "Missing script: test" error, rebuild the Docker image:
```bash
docker compose build --no-cache
```

## AWS Infrastructure (Terraform)

### Prerequisites:
- AWS CLI configured
- Terraform installed
- SSH key created in AWS (EC2 Key Pairs)

### GitHub Secrets for CI/CD

If you plan to use GitHub Actions for AWS deployment, configure the required secrets. See [SECRETS.md](./SECRETS.md) for the complete list.

### Test AWS Connection (Ping)

Before deploying infrastructure, test your AWS connection:

```bash
cd terraform/ping-test
terraform init
terraform apply
```

This will output your AWS account ID, user ID, and ARN to verify the connection works with your `tf-user` profile configured in `~/.aws/config`.

### Usage:

1. Navigate to terraform directory:
```bash
cd terraform
```

2. Create `terraform.tfvars` from `terraform.tfvars.example`:
```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` and specify:
   - `key_name` - your SSH key name in AWS
   - `ami_id` - AMI ID for Amazon Linux 2023 (or leave empty for auto-detection)

4. Find AMI ID for Amazon Linux 2023:
```bash
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-*" \
  --query 'Images | sort_by(@, &CreationDate) | [-1].[ImageId,Name]' \
  --output table
```

5. Initialize Terraform:
```bash
terraform init
```

6. Review plan:
```bash
terraform plan
```

7. Apply configuration:
```bash
terraform apply
```

8. After completion, Terraform will output:
   - `instance_public_ip` - public IP of the instance
   - `app_url` - URL to access the application

### Deploying Docker Image to EC2:

After creating the instance:

1. Build Docker image locally:
```bash
docker build -t ec2-bootstrap:latest .
```

2. Save image to file:
```bash
docker save ec2-bootstrap:latest | gzip > ec2-bootstrap.tar.gz
```

3. Copy to EC2:
```bash
scp -i your-key.pem ec2-bootstrap.tar.gz ec2-user@<PUBLIC_IP>:~/
```

4. Connect to EC2:
```bash
ssh -i your-key.pem ec2-user@<PUBLIC_IP>
```

5. Load image and run:
```bash
docker load < ec2-bootstrap.tar.gz
docker run -d --name ec2-bootstrap --restart unless-stopped -p 3030:3030 ec2-bootstrap:latest
```

Alternatively, use Docker Hub or AWS ECR for image storage.

### Cleanup:

```bash
terraform destroy
```

## Testing

### Run tests locally:
```bash
npm test
```

Tests use Jest and Supertest to verify all API endpoints.

### GitHub Actions

#### Tests

Tests run automatically on:
- Push to `main` or `develop` branches
- Pull Requests to `main` or `develop` branches

The workflow includes two test jobs:

1. **Test (Direct)** - Fast unit tests running directly with npm
   - Tests code logic quickly
   - Runs on multiple Node.js versions (18.x, 20.x)
   - Faster execution

2. **Test (Docker)** - Integration tests in Docker container
   - Validates Dockerfile works correctly
   - Tests in production-like environment
   - Ensures Docker image can run tests

**Why both?**
- Direct tests: Fast feedback during development
- Docker tests: Ensures deployment image works correctly

Workflow file: `.github/workflows/test.yml`

#### Docker Build

Docker image is automatically built and pushed to GitHub Container Registry (GHCR) on:
- Push to `main` or `develop` branches (pushes to registry)
- Pull Requests to `main` or `develop` branches (builds only, no push)
- Manual trigger via **Actions** → **Build Docker Image** → **Run workflow**

The build workflow:
- Builds Docker image using Docker Buildx
- Pushes to `ghcr.io/<owner>/<repo>` registry
- Uses GitHub Actions cache for faster builds
- Creates tags: `latest`, branch name, commit SHA
- Runs tests inside the built image (on PRs)

**Pulling the image:**
```bash
docker pull ghcr.io/<your-username>/ec2-bootstrap:latest
```

**Note:** Make sure the package is set to public in GitHub repository settings → Packages, or authenticate with:
```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

Workflow file: `.github/workflows/build.yml`

## API Endpoints

- `GET /` - API information
- `GET /health` - Health check endpoint
- `GET /data` - Sample data endpoint

## Git Flow

Simple Git flow:
- `main` - main branch
- Create feature branches for new features
- Use meaningful commit messages

## License

MIT
