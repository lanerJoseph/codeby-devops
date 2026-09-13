variable "network_id" {
  description = "ID of the Yandex VPC network"
  type        = string
}

variable "zone" {
  description = "Availability zone for the VM"
  type        = string
}

variable "name" {
  description = "VM name"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in GB"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}
