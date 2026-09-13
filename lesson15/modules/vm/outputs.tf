output "id" {
  description = "VM ID"
  value       = yandex_compute_instance.this.id
}

output "name" {
  description = "VM name"
  value       = yandex_compute_instance.this.name
}

output "zone" {
  description = "VM availability zone"
  value       = yandex_compute_instance.this.zone
}

output "subnet_id" {
  description = "Automatically selected subnet ID"
  value       = local.subnet_id
}

output "internal_ip" {
  description = "VM internal IP"
  value       = yandex_compute_instance.this.network_interface[0].ip_address
}

output "external_ip" {
  description = "VM external IP"
  value       = yandex_compute_instance.this.network_interface[0].nat_ip_address
}
