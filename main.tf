terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------------
# NameCheck S3 Bucket
# -----------------------------
module "namecheck_s3" {
  source = "git::https://gitlab.cloud-city/data-platform/terraform-core.git//modules/s3_bucket?depth=1&ref=feature/CDM-3293/IAMRoleServiceforS3andMSK"

  owner            = var.owner
  aws_region       = var.aws_region
  environment      = var.environment
  project          = var.project

  enable_cloudtrail = var.enable_cloudtrail
  kms_key           = var.kms_key
  tags              = var.tags
}

# -----------------------------
# ESO IAM Role (docs-style ESO)
# -----------------------------
module "iam_role_eso" {
  source = "git::https://gitlab.cloud-city/data-platform/terraform-core.git//modules/iam_role_service_account?depth=1&ref=feature/CDM-3293/IAMRoleServiceforS3andMSK"

  # naming / context
  owner       = var.owner
  environment = var.environment
  project     = var.project
  aws_region  = var.aws_region
  name_short  = var.name_short
  account_id  = var.account_id

  # IRSA
  oidc_provider_arn    = var.oidc_provider_arn
  oidc_provider_url    = var.oidc_provider_url
  k8s_namespace        = var.k8s_namespace
  service_account_name = var.service_account_name_eso

  # Policy selector
  selected_policies = var.eso_selected_policies    # ["eso"]

  # ESO docs-style inputs
  eso_secret_name_prefixes = var.eso_secret_name_prefixes
  eso_allow_list_secrets   = var.eso_allow_list_secrets
  eso_kms_key_arns         = var.eso_kms_key_arns
  eso_explicit_secret_arns = var.eso_explicit_secret_arns

  # Optional extra attachments
  policy_arns = var.policy_arns
  tags        = var.tags
}

# ---------------------------------------------
# App IAM Role (S3 + optional MSK, with logs)
# ---------------------------------------------
module "iam_role_namecheck" {
  source = "git::https://gitlab.cloud-city/data-platform/terraform-core.git//modules/iam_role_service_account?depth=1&ref=feature/CDM-3293/IAMRoleServiceforS3andMSK"

  # naming / context
  owner       = var.owner
  environment = var.environment
  project     = var.project
  aws_region  = var.aws_region
  name_short  = var.service_name_short      # e.g., "response"
  account_id  = var.account_id

  # IRSA
  oidc_provider_arn    = var.oidc_provider_arn
  oidc_provider_url    = var.oidc_provider_url
  k8s_namespace        = var.k8s_namespace
  service_account_name = var.service_account_name

  # Policy selector for app role
  selected_policies = var.service_selected_policies  # ["s3", "msk"] or ["s3"]

  # S3 bundle (expects bucket NAMES)
  s3_buckets = [module.namecheck_s3.bucket_name]

  # MSK bundle (only used if "msk" is selected)
  msk_cluster_arn = var.msk_cluster_arn

  # Optional extras
  policy_arns = var.policy_arns
  tags        = var.tags
}
