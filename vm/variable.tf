# variable "vm-01" {
#   description = "name of the virtual machine"
#   type        = string
#   default     = "prod-dt-vm"
# }

variable "rg-01" {
  description = "name of the resource group"
  type        = string
  default     = "prod-deployment-team"
}
variable "nsg-01" {
  description = "network security group"
  type        = string
  default     = "prod-dt-nsg"
}
variable "nic-01" {
  description = "name of the network interface"
  type        = string
  default     = "prod-dt-nic"
}
variable "subnet-01" {
  description = "name of the subnet"
  type        = string
  default     = "prod-dt-subnet"
}
variable "address-space" {
  description = "addresses for the vn"
  type        = list(any)
  default     = ["10.0.0.0/8"]

}
variable "address_prefixes" {
  description = "value"
  type        = list(any)
  default     = ["10.1.64.0/18"]
}
variable "vnet-01" {
  description = "name of the virtual network"
  type        = string
  default     = "prod-dt-vn"
}

variable "vm_config" {
  type = list
  
}