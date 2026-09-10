variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "zone" {
  type    = string
  default = "ru-central1-d"
}

variable "vm_zone" {
  description = "Zone where the VM should be created"
  type        = string
}

variable "ssh_public_key" {
  type = string
}
