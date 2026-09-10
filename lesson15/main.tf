terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.170"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "subnets" {
  source = "./modules/subnets"

  network_id = var.network_id
}

module "vm" {
  source = "./modules/vm"

  network_id     = var.network_id
  zone           = var.vm_zone
  name           = "lesson15-vm"
  ssh_public_key = var.ssh_public_key
}
