provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  region       = var.region
  private_key  = var.private_key
}

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = ">=3.5.1"

  compartment_id          = var.compartment_ocid
  create_internet_gateway = true
  label_prefix            = "hashi"
  vcn_dns_label           = "hashi"
  vcn_name                = "vcn"
  lockdown_default_seclist = false
  subnets = {
    first = module.vcn_subnet.subnet_id
  }
}

module "vcn_subnet" {
  source         = "oracle-terraform-modules/vcn/oci//modules/subnet"
  version        = ">=3.5.1"
  compartment_id = var.compartment_ocid
  vcn_id         = module.vcn.vcn_id
  ig_route_id    = module.vcn.ig_route_id
  nat_route_id   = module.vcn.nat_route_id
}

