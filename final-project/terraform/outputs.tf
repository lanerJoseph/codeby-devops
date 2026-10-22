output "instance_name" {
  description = "Name of the application VM"
  value       = yandex_compute_instance.app.name
}

output "instance_public_ip" {
  description = "Public IPv4 address of the application VM"
  value       = yandex_compute_instance.app.network_interface[0].nat_ip_address
}
