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
}

module "vcn_subnet" {
  source         = "oracle-terraform-modules/vcn/oci//modules/subnet"
  version        = ">=3.5.1"
  compartment_id = var.compartment_ocid
  ig_route_id    = module.vcn.ig_route_id
  nat_route_id   = module.vcn.nat_route_id
  vcn_id         = module.vcn.vcn_id

  subnets = {
    subnet = {
      cidr_block = "10.0.1.0/24"
      dns_label  = "subnet"
    }
  }
}

module "arm-instances" {
  source  = "oracle-terraform-modules/compute-instance/oci"
  version = "2.4.0-RC1"

  ad_number                   = 2
  boot_volume_size_in_gbs     = 20
  compartment_ocid            = var.compartment_ocid
  instance_flex_memory_in_gbs = 12
  instance_flex_ocpus         = 2
  public_ip_display_name      = "arm"
  source_ocid                 = var.image_ocid
  ssh_public_keys             = file("./public-keys")
  subnet_ocids                = module.vcn_subnet.subnet_id
  hostname_label              = "hashi-arm"
  instance_count              = 2
  instance_display_name       = "hashi-arm"
  shape                       = "VM.Standard.A1.Flex"
  user_data                   = base64encode(templatefile("./user-data.tftpl", {}))

}


