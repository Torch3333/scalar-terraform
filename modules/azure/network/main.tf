module "name_generator" {
  source = "../../universal/name-generator"
  name   = var.name
}

resource "azurerm_resource_group" "default" {
  name     = module.name_generator.name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.default]
  name                = module.name_generator.name
  location            = var.location
  address_space       = [local.network.cidr]
  resource_group_name = azurerm_resource_group.default.name
  dns_servers         = []

  tags = {
    Terraform = "true"
    Name      = module.name_generator.name
  }
}

resource "azurerm_subnet" "subnet" {
  count = length(local.subnet_names)

  name                 = local.subnet_names[count.index]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.default.name
  address_prefix       = local.subnet_prefixes[count.index]

  lifecycle {
    ignore_changes = [network_security_group_id]
  }
}

resource "azurerm_dns_zone" "dns" {
  name                             = var.internal_root_dns
  resource_group_name              = azurerm_resource_group.default.name
  zone_type                        = "Private"
  registration_virtual_network_ids = [azurerm_virtual_network.vnet.id]
}

module "bastion" {
  source = "./bastion"

  network_name     = module.name_generator.name
  network_id       = azurerm_virtual_network.vnet.id
  network_cidr     = local.network.cidr
  network_dns      = azurerm_dns_zone.dns.id
  location         = var.location
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  user_name        = local.network.user_name
  subnet_id        = azurerm_subnet.subnet[0].id

}
