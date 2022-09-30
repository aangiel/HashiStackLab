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

  compartment_id           = var.compartment_ocid
  create_internet_gateway  = true
  label_prefix             = "hashi"
  vcn_dns_label            = "vcn"
  vcn_name                 = "vcn"
  lockdown_default_seclist = false
  subnets = {
    subnet = {
      cidr_block = "10.0.1.0/24"
      dns_label  = "subnet"
    }
  }
}


