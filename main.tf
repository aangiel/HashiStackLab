provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  region       = var.region
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


# resource "oci_core_shape_management" "arm" {
#   # availability_domain = data.oci_identity_availability_domain.ad1.name
#   compartment_id = var.compartment_ocid
#   shape_name     = "VM.Standard.A1.Flex"
#   image_id       = var.image_ocid
# }

# resource "oci_core_shape_management" "amd64" {
#   # availability_domain = data.oci_identity_availability_domain.ad1.name
#   compartment_id = var.compartment_ocid
#   shape_name     = "VM.Standard.E2.1.Micro"
#   image_id       = var.image_ocid

# }

data "oci_core_image" "ubuntu" {
  #Required
  image_id = var.image_ocid
}

data "oci_core_images" "images" {
    #Required
    compartment_id = var.compartment_ocid
    operating_system = "Ubuntu"
    operating_system_version = "22.04"
    sort_by = "TIMECREATED"
    sort_order = "DESC"
}

data "oci_core_image_shape" "arm" {
  #Required
  image_id   = data.oci_core_image.ubuntu.id
  shape_name = "VM.Standard.A1.Flex"
}

data "oci_core_image_shape" "amd" {
  #Required
  image_id   = data.oci_core_image.ubuntu.id
  shape_name = "VM.Standard.E2.1.Micro"
}

data "oci_identity_availability_domain" "ad2" {
  compartment_id = var.tenancy_ocid
  ad_number = 2
}



resource "oci_core_instance" "arm" {
  availability_domain = data.oci_identity_availability_domain.ad2.name
  compartment_id      = var.compartment_ocid
  shape               = data.oci_core_image_shape.arm.id

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.images.id
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.hashistack.id
  }
}

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

