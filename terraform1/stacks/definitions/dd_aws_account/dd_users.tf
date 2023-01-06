resource "datadog_user" "foo" {
  email = var.monitoring_address

  roles = [data.datadog_role.ro_role.id]
}
