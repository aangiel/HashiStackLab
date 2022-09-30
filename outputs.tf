output "vcn_id" {
  value = module.vcn.vcn_id
}

output "vcn_attributes" {
  value = module.vcn.vcn_all_attributes
}

output "subnet_id" {
  value = module.vcn_subnet.subnet_id
}

output "subnet_all_attrs" {
  value = module.vcn_subnet.all_attributes
}