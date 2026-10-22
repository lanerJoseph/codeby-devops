variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "subnet_id" {
  description = "ID of an existing subnet"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for VM access"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vm_name" {
  description = "Name of the application VM"
  type        = string
  default     = "devops-final-vm"
}

variable "ssh_allowed_cidr" {
  description = "IPv4 CIDR allowed to connect to SSH"
  type        = string
}
