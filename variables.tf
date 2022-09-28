variable "tenancy_ocid" {
  description = "The OCID of the tenancy."
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the user."
  type        = string
}

variable "image_ocid" {
  description = "The OCID of the image."
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint of the user's private key."
  type        = string
}

variable "private_key" {
  description = "Private key"
  type        = string
}

variable "region" {
  description = "The region to connect to."
  type        = string
}

variable "compartment_ocid" {
  description = "The OCID of the compartment."
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "vcn_cidr_block" {
  description = "The CIDR block for the VCN."
  type        = string
}


variable "ssh_public_key" {
  description = "The SSH public key to add to the root user."
  type        = string
}
