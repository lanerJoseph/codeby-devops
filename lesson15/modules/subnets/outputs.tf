output "subnets" {
  description = "All subnets belonging to the selected VPC"

  value = {
    for id, subnet in data.yandex_vpc_subnet.this : id => {
      id             = subnet.id
      name           = subnet.name
      zone           = subnet.zone
      network_id     = subnet.network_id
      v4_cidr_blocks = subnet.v4_cidr_blocks
    }
  }
}
