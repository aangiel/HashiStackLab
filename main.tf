provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key = var.private_key
  region           = var.region
}

resource "oci_core_vcn" "hashistack" {

  compartment_id = var.compartment_ocid

  cidr_blocks  = [var.vcn_cidr_block]
  dns_label    = "hashistack"
  display_name = "HashiStack"

}

resource "oci_core_subnet" "hashistack" {
  display_name   = "HashiStack"
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.hashistack.id
}


# data "oci_core_shape" "arm" {
#   availability_domain = data.oci_identity_availability_domain.ad1.name
#   compartment_id      = var.compartment_ocid
#   name                = "VM.Standard.A1.Flex"
# }

# data "oci_core_shape" "amd64" {
#   availability_domain = data.oci_identity_availability_domain.ad1.name
#   compartment_id      = var.compartment_ocid
#   name                = "VM.Standard.E2.1.Micro"
# }

data "oci_identity_availability_domain" "ad1" {
  compartment_id = var.compartment_ocid
  ad_number      = 1
}



# resource "oci_core_instance" "arm" {
#   availability_domain = data.oci_identity_availability_domains.ad1.id
#   compartment_id      = var.compartment_ocid
#   display_name        = "arm"
#   image               = data.oci_core_images.arm.id
#   shape               = data.oci_core_shape.arm.id
#   subnet_id           = oci_core_subnet.hashistack.id

#   metadata {
#     ssh_authorized_keys = var.ssh_public_key
#   }
# }

# resource "oci_core_instance" "amd" {
#   availability_domain = data.oci_identity_availability_domains.ad1.id
#   compartment_id      = var.compartment_ocid
#   display_name        = "amd"
#   image               = data.oci_core_images.amd64.id
#   shape               = data.oci_core_shape.amd64
#   subnet_id           = oci_core_subnet.hashistack.id

#   metadata {
#     ssh_authorized_keys = var.ssh_public_key
#   }
# }

