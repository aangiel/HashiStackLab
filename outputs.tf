output "vcn_id" {
  value = oci_core_vcn.hashistack.id
}

output "vcn_default_dhcp_options_id" {
  value = oci_core_vcn.hashistack.default_dhcp_options_id
}

output "vcn_default_route_table_id" {
  value = oci_core_vcn.hashistack.default_route_table_id
}

output "vcn_default_security_list_id" {
  value = oci_core_vcn.hashistack.default_security_list_id
}