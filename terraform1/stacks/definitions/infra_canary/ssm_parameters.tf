resource "aws_ssm_parameter" "foo" {
  name  = "/stacks/${var.stack_name}/${var.environment}/${var.variant}"
  type  = "String"
  value = "dummy"
}
