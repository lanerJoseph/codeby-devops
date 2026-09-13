terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

data "yandex_vpc_network" "this" {
  network_id = var.network_id
}

data "yandex_vpc_subnet" "this" {
  for_each = toset(data.yandex_vpc_network.this.subnet_ids)

  subnet_id = each.value
}
