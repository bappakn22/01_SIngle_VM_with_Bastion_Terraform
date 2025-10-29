data "azurerm_key_vault" "kv" {
  name                = "mtijori"
  resource_group_name = "bappa-state-rg"
}

data "azurerm_key_vault_secret" "kvsecretuser" {
  name         = "tuser"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "kvsecretpw" {
  name         = "tpass"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_public_ip" "pipdata" {
  depends_on          = [module.public_ip]
  name                = "my-public-ip"
  resource_group_name = "bastion-rg"
}

data "azurerm_subnet" "pipsubnet" {
  depends_on           = [module.vm_subnet]
  name                 = "my-subnet"
  virtual_network_name = "my-vnet"
  resource_group_name  = "bastion-rg"
}

data "azurerm_subnet" "bastion_subnet" {
  depends_on           = [module.bastion_subnet]
  name                 = "AzureBastionSubnet"
  virtual_network_name = "my-vnet"
  resource_group_name  = "bastion-rg"
}