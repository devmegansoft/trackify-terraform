# Environments

Each subfolder is a **standalone Terraform root** with its own state.

| Folder | State prefix | Purpose |
|--------|--------------|---------|
| `dev/` | `portal/dev` | Development |
| `qa/` | `portal/qa` | QA / staging |
| `prod/` | `portal/prod` | Production |

## Files inside each environment

| File | GCP service |
|------|-------------|
| `cloud_run.tf` | All Cloud Run microservices |
| `cloud_storage.tf` | GCS buckets |
| `pubsub.tf` | Pub/Sub topics & subscriptions |
| `cloud_sql.tf` | Cloud SQL PostgreSQL |
| `apis.tf` | API enablement |
| `iam.tf` | Cloud Build IAM |
| `terraform.tfvars` | Environment-specific values (gitignored) |

Shared modules: `../../modules/`

## First-time setup per environment

```bash
cp terraform.tfvars.example terraform.tfvars
# edit values
terraform init
terraform plan -var-file=terraform.tfvars
```
