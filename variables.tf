variable "user_principal_name" {
  type        = string
  description = "Enter your principle name"
}

variable "display_name" {
  type        = string
  description = "Enter the name to be displayed on portal"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "user_profile" {
  type        = string
  description = "Enter user profile ( administrator/developer/tester )"
}


variable "user_role" {
  type = map
  default = {
    administrator = "Contributor"
    tester        = "Reader"
    developer     = "Reader"
  }
}

variable "enviornment" {
  type = map
  default = {
    administrator = "Production"
    tester        = "Testing"
    developer     = "Development"
  }
}




variable "vnet_address_space" {
  type = list(string)
  default = ["10.0.0.0/16"]
  description = "CIDR block / Virtual network address space"
}

variable "subnet_address_prefixes" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDR block / subnet address space"
}

variable "subnet_count" {
  type = map
  default = {
    administrator = 2
    tester        = 1
    developer     = 1
  }
}

variable "group_name" {
  type = map
  default = {
    administrator = "Administrator"
    tester        = "Tester"
    developer     = "Developer"
  }
}

variable "account_tier" {
  type = string
  default = ""
  description = "Account tier of storage account ( Standard / Premium )"
}

variable "account_replication_type" {
  type = string
  default = "LRS"
  description = " Defines the type of replication to use for this storage account (LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS)"
}

variable "quota" {
  type = number
  description = "The maximum size of the share, in gigabytes."
  default = 1000
}

variable "vmss_instance_count" {
  type = map
  description = "number of virtual machines in virtual machine scale set"
  default = {
    administrator = 2
    tester        = 2
    developer     = 2
  }
}

variable "vmss_instance_size"{
  type = map
  description = "Th size ( SKU ) of virtual machines in virtual machine scale set"
  default = {
    administrator = "Standard_B2ms"   #2CPU, 8GB Ram
    tester        = "Standard_B1s"     #1CPU, 1GB Ram
    developer     = "Standard_B1s"        #1CPU, GB Ram
  }
}

variable "vm_username" {
  type = string
  default = "gslab"
  description = "virtual machine username"
}

variable "vm_password" {
  type = string
  default = "gsLab!123@#$%^&*()"
  description = "default password for the virtual machine"
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}



variable "storage_account_type"{
  type = map
  description = "The Type of Storage Account which should back this the Internal OS Disk."
  default = {
    administrator = "Premium_LRS"  
    tester        = "Standard_LRS"     
    developer     = "Standard_LRS"
  }
}

variable "domain" {
  type = string
  description = "domain/subscription email of the account"
}

variable "given_name"{}
variable "surname"{}
variable "company_name"{}
variable "job_title"{}
variable "mobile"{}
variable "department" {}









 # given_name = ""
  # surname = ""
  # company_name = ""
  # job_title = ""
  # department = ""
  # mobile = ""