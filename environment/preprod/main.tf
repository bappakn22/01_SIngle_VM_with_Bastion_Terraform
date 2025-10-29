module "rg" {
  source              = "../../module/01_azurerm_resource_group"
  resource_group_name = "bastion-rg"
  location            = "East US"
}

module "vnet" {
  depends_on = [ module.rg ]
  source              = "../../module/02_azurerm_virtual_network"
  vnet_name           = "my-vnet"
  vnet_location       = "East US"
  resource_group_name = "bastion-rg"
  vnet_address_space  = ["10.0.0.0/16"]
}

module "vm_subnet" {
  depends_on = [ module.vnet ]
  source              = "../../module/03_azurerm_subnet"
  subnet_name         = "my-subnet"
  address_prefixes    = ["10.0.1.0/24"]
  vnet_name           = "my-vnet"
  resource_group_name = "bastion-rg"
}

module "bastion_subnet" {
  depends_on = [ module.vnet ]
  source              = "../../module/03_azurerm_subnet"
  subnet_name         = "AzureBastionSubnet"
  address_prefixes    = ["10.0.2.0/24"]
  vnet_name           = "my-vnet"
  resource_group_name = "bastion-rg"
}

module "public_ip" {
  depends_on = [ module.bastion_subnet ]
  source              = "../../module/04_azurerm_public_ip"
  public_ip_name      = "my-public-ip"
  resource_group_name = "bastion-rg"
  location            = "East US"
}

module "nic" {
  depends_on = [ module.vm_subnet ]
  source              = "../../module/05_azurerm_virtual_machine"
  nic_name            = "my-nic"
  resource_group_name = "bastion-rg"
  location            = "East US"
  subnet_id           = data.azurerm_subnet.pipsubnet.id
  vm_name             = "bastion-vm"
  admin_username      = data.azurerm_key_vault_secret.kvsecretuser.value
  admin_password      = data.azurerm_key_vault_secret.kvsecretpw.value
}


module "my_bastion" {
  depends_on = [ module.public_ip, module.bastion_subnet ]
  source               = "../../module/06_azurerm_bastion_host"
  bastion_name         = "my-bastion"
  location             = "East US"
  resource_group_name  = "bastion-rg"
  subnet_id            = data.azurerm_subnet.bastion_subnet.id
  public_ip_address_id = data.azurerm_public_ip.pipdata.id
}