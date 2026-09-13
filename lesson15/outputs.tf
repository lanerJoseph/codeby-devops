output "all_subnets" {
  description = "All subnets returned by the subnet data module"
  value       = module.subnets.subnets
}

output "vm_id" {
  value = module.vm.id
}

output "vm_name" {
  value = module.vm.name
}

output "vm_zone" {
  value = module.vm.zone
}

output "vm_subnet_id" {
  value = module.vm.subnet_id
}

output "vm_internal_ip" {
  value = module.vm.internal_ip
}

output "vm_external_ip" {
  value = module.vm.external_ip
}
