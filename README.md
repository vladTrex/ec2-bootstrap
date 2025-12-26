# EC2 Bootstrap

Minimal pet project for learning backend and infrastructure skills.

## Quick Start

```bash
npm install
npm start
```

Test endpoints:
- http://localhost:3030/health
- http://localhost:3030/data

## Docker

```bash
docker build -t ec2-bootstrap:latest .
docker run -p 3030:3030 ec2-bootstrap:latest
```

Or with Docker Compose:
```bash
docker compose up
```

Run tests in Docker:
```bash
docker compose run --rm test
```

## AWS Infrastructure (Terraform)

### Test Connection

```bash
cd terraform/ping-test
terraform init
terraform apply
```

### Deploy EC2

1. Create `terraform.tfvars`:
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` and set `key_name`

3. Deploy:
```bash
terraform init
terraform plan
terraform apply
```

## Testing

```bash
npm test
```

GitHub Actions automatically runs tests on push/PR.

## Docker Image (GHCR)

Build and push manually via **Actions** → **Build Docker Image** → **Run workflow**.

Pull locally:
```bash
docker pull ghcr.io/<your-username>/ec2-bootstrap:latest
```

## API Endpoints

- `GET /` - API information
- `GET /health` - Health check
- `GET /data` - Sample data

## License

MIT
