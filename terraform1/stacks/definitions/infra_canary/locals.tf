locals {
  variant = var.variant == "" ? "default" : var.variant
  prefix  = "${var.stack_name}-${var.environment}-${local.variant}"
}
