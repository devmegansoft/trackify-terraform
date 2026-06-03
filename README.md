# Trackify Terraform

Infrastructure for Timesheet Portal on GCP. **One Terraform root per environment** (`dev`, `qa`, `prod`).

Only **`cloudbuild.yaml`** at repo root is YAML.

## Layout (recommended pattern)

```text
trackify-terraform/
├── cloudbuild.yaml                 # Pipeline (set _TF_ENV = dev | qa | prod)
├── modules/                        # Shared GCP modules (do NOT copy per env)
│   ├── cloud_run/
│   ├── cloud_storage/
│   ├── cloud_sql/
│   └── pubsub/
└── environments/
    ├── dev/                        # ← Terraform root for dev
    │   ├── backend.tf              # State: gs://.../portal/dev
    │   ├── providers.tf
    │   ├── variables.tf
    │   ├── locals.tf
    │   ├── apis.tf
    │   ├── iam.tf
    │   ├── cloud_storage.tf        # GCS
    │   ├── pubsub.tf               # Pub/Sub
    │   ├── cloud_sql.tf            # Cloud SQL (optional)
    │   ├── cloud_run.tf            # All Cloud Run services
    │   ├── outputs.tf
    │   └── terraform.tfvars
    ├── qa/                         # Same structure, separate state prefix
    └── prod/
```

### Why this structure?

| Your idea | Verdict |
|-----------|---------|
| Environment folders (`dev/qa/prod`) | **Correct** — separate state, separate config |
| GCP service `.tf` files inside each env | **Correct** — easy to find `cloud_run.tf`, `cloud_sql.tf` |
| Common modules outside env folders | **Correct** — `modules/` at repo root, referenced as `../../modules/...` |

### Do not

- Put `.tf` modules inside each environment (duplication)
- Share one state file across dev/qa/prod
- Mix environment values in a single root without workspaces

## Deploy timesheet-service (dev)

1. Build image → Artifact Registry.
2. Edit **`environments/dev/cloud_run.tf`** — update `container_image` tag.
3. Edit **`environments/dev/terraform.tfvars`** — DB settings (`cloud_sql_enabled`, passwords).
4. Merge to `main`.

```bash
cd trackify-terraform
gcloud builds submit . --config=cloudbuild.yaml --project=ivory-cycle-466320-r8
```

Deploy **qa** or **prod**:

```bash
gcloud builds submit . --config=cloudbuild.yaml \
  --substitutions=_TF_ENV=qa \
  --project=ivory-cycle-466320-r8
```

(Create `environments/qa/terraform.tfvars` from `.example` first.)

## Enable a service

In `environments/<env>/cloud_run.tf`:

```hcl
locals {
  approval_service_enabled = true
}
```

Set `container_image` in the same file → merge.

## Local Terraform

```bash
cd environments/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Bootstrap (once)

```bash
gcloud storage buckets create gs://ivory-cycle-466320-r8-terraform-state \
  --location=us-central1 --uniform-bucket-level-access --project=ivory-cycle-466320-r8

cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
```

## State isolation

| Environment | GCS prefix |
|-------------|------------|
| dev | `portal/dev` |
| qa | `portal/qa` |
| prod | `portal/prod` |

## Modules

| Module | GCP resource |
|--------|----------------|
| `cloud_run` | Cloud Run v2 + SA + IAM |
| `cloud_storage` | GCS buckets |
| `cloud_sql` | Cloud SQL PostgreSQL |
| `pubsub` | Topics + subscriptions |

## Environment defaults

| Env | Cloud Run services | Notes |
|-----|-------------------|--------|
| dev | timesheet + approval-consumer enabled | Active development |
| qa | all disabled | Enable when QA is ready |
| prod | all disabled | Enable when prod is ready |
