provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  region       = var.region
  private_key  = var.private_key
}

provider "google" {
  project = "total-well-310016"
  region  = "us-east1"
}

resource "oci_core_vcn" "hashistack" {

  compartment_id = var.compartment_ocid

  cidr_blocks  = [var.vcn_cidr_block]
  dns_label    = "hashistack"
  display_name = "HashiStack"

}

resource "oci_core_subnet" "hashistack" {
  display_name   = "HashiStack"
  dns_label      = "hashistacksn"
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.hashistack.id
  route_table_id = oci_core_route_table.hashistack_route_table.id
}

resource "oci_core_route_table" "hashistack_route_table" {
  vcn_id         = oci_core_vcn.hashistack.id
  compartment_id = var.tenancy_ocid
  display_name   = "Hashistack Route Table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.hashistack_internet_gateway.id
  }

}

resource "oci_core_internet_gateway" "hashistack_internet_gateway" {
  compartment_id = var.tenancy_ocid
  display_name   = "HashiStack Internet Gateway"
  vcn_id         = oci_core_vcn.hashistack.id

}

# resource "oci_bastion_bastion" "hashistack_bastion" {
#   bastion_type                 = "standard"
#   compartment_id               = var.tenancy_ocid
#   target_subnet_id             = oci_core_subnet.hashistack.id
#   name                         = "HashiStackBastion"
#   client_cidr_block_allow_list = ["0.0.0.0/0"]
# }

data "oci_core_image" "ubuntu" {
  image_id = var.image_ocid
}

variable "arm_shape_name" {
  default = "VM.Standard.A1.Flex"
}

variable "amd_shape_name" {
  default = "VM.Standard.E2.1.Micro"
}

data "oci_identity_availability_domain" "ad1" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_identity_availability_domain" "ad2" {
  compartment_id = var.tenancy_ocid
  ad_number      = 2
}



resource "oci_core_instance" "arm" {
  availability_domain = data.oci_identity_availability_domain.ad2.name
  compartment_id      = var.compartment_ocid
  shape               = var.arm_shape_name
  count               = 2
  display_name = "hashi"

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.hashistack.id
    hostname_label = "hashi"
  }

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("./user-data"))
  }
}

resource "oci_objectstorage_bucket" "hashi_vault_bucket" {
  #Required
  compartment_id = var.compartment_ocid
  name           = "HashiVaultBucket"
  namespace      = "frjiduquf3wj"
}

resource "oci_core_instance" "amd" {
  availability_domain = data.oci_identity_availability_domain.ad1.name
  compartment_id      = var.compartment_ocid
  shape               = var.amd_shape_name
  count               = 2
  display_name = "hashi"

  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7wq4opozz63gwzrolqmalwadtckpke5ehhxh634myjquvwlzetyq"
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.hashistack.id
    hostname_label = "hashi"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("./user-data"))
  }
}

# ===========Google====================


resource "google_compute_instance" "test" {
  name         = "test"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

