module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "vnet" {
  source     = "../../modules/azurerm_virtual_network"
  vnets      = var.vnets
  depends_on = [module.resource_group]
}
module "subnets" {
  source     = "../../modules/azurerm_subnet"
  subnets    = var.subnets
  depends_on = [module.vnet]

}
module "public_ips" {
  source     = "../../modules/azurerm_public_ip"
  public_ips = var.public_ips
  depends_on = [module.subnets]


}
module "vms" {
  source     = "../../modules/azurerm_virtual_machine"
  vms        = var.vms
  depends_on = [module.subnets]


}