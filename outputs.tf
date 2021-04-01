# output "subscription" {
#   value = data.azurerm_subscription.primary.id
# }

# output "object_id" {
#   value = azuread_user.user.object_id
# }




output "azure_portal_username" {
  value       = "${var.user_principal_name}@ ${var.domain}"
  description = "username of the user"
}

output "azure_portal_password" {
  value       = random_string.fqdn.result
  description = "Users Initial Password"
}

output "vm_username" {
  value       = azurerm_linux_virtual_machine.example[0].admin_username
  description = "username of the user"
}

output "vm_password" {
  value       = azurerm_linux_virtual_machine.example[0].admin_password
  description = "Users Initial Password"
}

output "public_ip_addresses" {
  value = azurerm_public_ip.public_ip.*.ip_address
}



# output "display_name" {
#   value = var.display_name
# }
