resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource_action" "ssh_dev_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_dev_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = "dev-ssh-key"
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
}

resource "azapi_resource_action" "ssh_prod_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_prod_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = "prod-ssh-key"
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
}

output "key_data" {
  value = azapi_resource_action.ssh_dev_public_key_gen.output.publicKey
}
output "key_data" {
  value = azapi_resource_action.ssh_prod_public_key_gen.output.publicKey
}


resource "azapi_resource_action" "ssh_VM_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_VM_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = "BuildVM-ssh-key"
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
}

output "key_data" {
  value = azapi_resource_action.ssh_VM_public_key_gen.output.publicKey
}
