# To generate Random password
resource "random_string" "fqdn" {
  length  = 24
  special = true
  upper   = true
  number  = true
}


resource "azuread_user" "user" {
  user_principal_name   = "${var.user_principal_name}@vidyapatne421gmail.onmicrosoft.com"
  display_name          = var.display_name
  password              = random_string.fqdn.result
  force_password_change = true
  given_name            = var.given_name
  surname               = var.surname
  company_name          = var.company_name
  job_title             = var.job_title
  department            = var.department
  mobile                = var.mobile_number
}

# TO get Current Subscription
data "azurerm_subscription" "primary" {
}

# To get Existing roles ( Owner/Contributor/Reader )
data "azurerm_role_definition" "role" {
  name  = var.user_role[var.user_profile] # administrator => Contributor , developer => Reader
  scope = data.azurerm_subscription.primary.id
}



# To create Resource group for user
resource "azurerm_resource_group" "rg" {
  name     = "${var.display_name}-${var.project_name}-ResourceGroup"
  location = var.location
  tags     = local.common_tags
}


resource "azurerm_role_assignment" "role_assignment" {
  scope              = azurerm_resource_group.rg.id
  role_definition_id = data.azurerm_role_definition.role.id
  principal_id       = azuread_user.user.object_id
}


data "azuread_group" "group" {
  display_name     = var.group_name[var.user_profile]
  security_enabled = true
}



resource "azuread_group_member" "group_member" {
  group_object_id  = data.azuread_group.group.id
  member_object_id = azuread_user.user.object_id
}


# TO Create Virtual network

resource "azurerm_virtual_network" "example_vnet" {
  name                = "${var.display_name}-${var.project_name}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}



# Create a subnets within the virtual network
resource "azurerm_subnet" "subnet" {
  count                = var.subnet_count[var.user_profile]
  name                 = "${var.display_name}-${var.project_name}-subnet-${format("%02d", count.index)}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = [element(var.subnet_address_prefixes, count.index)]
}


#  To create public ip's
resource "azurerm_public_ip" "public_ip" {
  count               = var.subnet_count[var.user_profile]
  name                = "public-ip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = var.allocation_method

  tags = local.common_tags
}


# To create network interfaces
resource "azurerm_network_interface" "example" {
  count               = var.subnet_count[var.user_profile]
  name                = "nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfiguration-${count.index + 1}"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, count.index)
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = element(azurerm_public_ip.public_ip.*.id, count.index)
  }
}




# LINUX VIRTUAL MACHINE PROVISIONING


resource "azurerm_linux_virtual_machine" "example" {
  count                           = var.subnet_count[var.user_profile]
  name                            = var.virtual_machine_prefix == "" ? "${var.display_name}-${var.project_name}-VM-${count.index + 1}" : "${var.virtual_machine_prefix}-VM-${count.index + 1}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size[var.user_profile]
  admin_username                  = var.vm_username == "" ? var.vm_user : var.vm_username
  admin_password                  = var.vm_password == "" ? var.vm_pwd : var.vm_password
  disable_password_authentication = false
  network_interface_ids = [
    element(azurerm_network_interface.example.*.id, count.index)
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type[var.user_profile]
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  # Provisioner for Adding hosts to ansible tower inventory
  provisioner "local-exec" {
    command = "tower-cli host create --name ${element(azurerm_public_ip.public_ip.*.ip_address, count.index)} --inventory 3"
  }

}


# Created Null Resource for launching a job template using local-exec.
resource "null_resource" "launch_job_template" {
  provisioner "local-exec" {
    command = "tower-cli job launch --job-template=9"
  }
  depends_on = [
    azurerm_linux_virtual_machine.example
  ]
}


# Create Null resource for executing python script for sending an email to user.
resource "null_resource" "send_email" {
  provisioner "local-exec" {
    command = "python3 send_email.py ${var.display_name} ${var.user_email} ${var.user_principal_name}@vidyaptne.com ${random_string.fqdn.result} ${var.vm_username} ${var.vm_password} ${azurerm_public_ip.public_ip.*.id} ${var.mobile_number}"
  }
  depends_on = [
    azurerm_linux_virtual_machine.example
  ]
}


# Create Storage Account for user
# resource "azurerm_storage_account" "storage_account" {
#   name                     = lower("${var.display_name}gslab")
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = local.account_tier # Production => Premium | Dev,Test => Standard
#   account_replication_type = var.account_replication_type
#   tags                     = local.common_tags
# }

# # To create Container Storage
# resource "azurerm_storage_container" "storage_container" {
#   name                 = lower("${var.display_name}-storagecontainer")
#   storage_account_name = azurerm_storage_account.storage_account.name
# }












