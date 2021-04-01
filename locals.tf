locals {
  common_tags = {
    Environment = var.enviornment[var.user_profile]
    Owner       = var.display_name
    Project = var.project_name
  }
}

locals {
  account_tier = var.enviornment[var.user_profile] == "Production" ? "Premium" : "Standard"
  quota        = var.enviornment[var.user_profile] == "Production" ? 10000 : 1000
}