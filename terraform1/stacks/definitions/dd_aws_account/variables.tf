
### Stack Tools

variable "environment" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "variant" {
  type    = string
  default = ""
}

### DataDog Variables

variable "monitoring_address" {
  type    = string
}
