# Common Settings
owner       = "cdp"
environment = "dev"
aws_region  = "us-east-1"

# Service Settings
project             = "namecheck-new"
name_short          = "eso"        # ESO role short code
service_name_short  = "response"   # App role short code
account_id          = "976193220746"

# CloudTrail & Encryption (S3 module)
enable_cloudtrail = false
kms_key           = "arn:aws:kms:us-east-1:976193220746:key/fffeeeef-5cb7-4df5-8247-caec629db53d"

# Resource Tags
tags = {
  "env-type" = "dev"
  "sys-name" = "Consular Data Platform"
  "acronym"  = "CDP"
  "service"  = "namecheck"
  "fisma-id" = "n/a"
}

# Policy toggles
eso_selected_policies     = ["eso"]         # ESO: secrets + logs
service_selected_policies = ["s3", "msk"]   # App: S3 + MSK (+ logs)

# ESO docs-style scoping
eso_secret_name_prefixes = ["namecheck/"]
eso_allow_list_secrets   = true
eso_kms_key_arns         = ["arn:aws:kms:us-east-1:976193220746:key/fffeeeef-5cb7-4df5-8247-caec629db53d"]
eso_explicit_secret_arns = []

# OIDC / IRSA
oidc_provider_arn = "arn:aws:iam::976193220746:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/8B35C73446155EFF7E5D07863B640A5F"
oidc_provider_url = "oidc.eks.us-east-1.amazonaws.com/id/8B35C73446155EFF7E5D07863B640A5F"
k8s_namespace     = "cdp"

# Service accounts (names exactly as requested)
service_account_name_eso = "namecheck-service-eso-service-account"
service_account_name     = "namecheck-service-account"

# MSK
msk_cluster_arn = "arn:aws:kafka:us-east-1:976193220746:cluster/cdp-dev-msk-cluster-use1-msk/dda1f4e9-6c54-976b-b1d6f065d7a2-12"

# Optional extra policy ARNs
policy_arns = [
  "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
]
