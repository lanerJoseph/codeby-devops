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

locals {
  matching_subnets = [
    for subnet in data.yandex_vpc_subnet.this :
    subnet.id if subnet.zone == var.zone
  ]

  subnet_id = local.matching_subnets[0]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "this" {
  name        = var.name
  platform_id = "standard-v3"
  zone        = var.zone

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = local.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
