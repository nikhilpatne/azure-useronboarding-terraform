# output "subscription" {
#   value = data.azurerm_subscription.primary.id
# }

# output "object_id" {
#   value = azuread_user.user.object_id
# }




output "username" {
  value = "${var.user_principal_name}@ ${var.domain}"
  description = "username of the user"
}

output "password" {
  value       = random_string.fqdn.result
  description = "Users Initial Password"
}


# output "display_name" {
#   value = var.display_name
# }
