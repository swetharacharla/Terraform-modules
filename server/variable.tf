variable "rg-first" {
  description = "name "
  type        = string
  default     = "dev-server"

}

variable "server_config" {
  type = list

}

variable "db-01" {
  default     = "dev-server"
  type        = string
  description = "name"

}