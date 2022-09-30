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
  subnet_ocids                = [module.vcn.subnet_id]
  hostname_label              = "hashi-arm-${count.index}"
  instance_count              = 2
  instance_display_name       = "hashi-arm-${count.index}"
  shape                       = "VM.Standard.A1.Flex"
  user_data = base64encode(templatefile("./user-data.tftpl",
    {
      node_id = "hashi-arm-${count.index}"
    }
  ))

}


