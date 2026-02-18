module "network" {
  source             = "./modules/network"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "server" {
  source    = "./modules/server"
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.subnet_id
}

module "eks" {
  source         = "./modules/eks"
  public_subnets = module.network.public_subnets 
}
