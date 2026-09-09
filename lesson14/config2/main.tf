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

data "yandex_vpc_network" "lesson14" {
  name = "lesson14-network"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_subnet" "public" {
  name           = "lesson14-config2-public"
  zone           = var.zone
  network_id     = data.yandex_vpc_network.lesson14.id
  v4_cidr_blocks = ["10.20.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = "lesson14-config2-private"
  zone           = var.zone
  network_id     = data.yandex_vpc_network.lesson14.id
  v4_cidr_blocks = ["10.20.20.0/24"]
}

resource "yandex_vpc_security_group" "public" {
  name       = "lesson14-config2-public-sg"
  network_id = data.yandex_vpc_network.lesson14.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private" {
  name       = "lesson14-config2-private-sg"
  network_id = data.yandex_vpc_network.lesson14.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "Application"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8080
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "public" {
  name        = "lesson14-config2-public-vm"
  platform_id = "standard-v3"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.public.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type    = "ssh"
      host    = self.network_interface[0].nat_ip_address
      user    = "ubuntu"
      agent   = true
      timeout = "5m"
    }
  }
}

resource "yandex_compute_instance" "private" {
  name        = "lesson14-config2-private-vm"
  platform_id = "standard-v3"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.private.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-enabled/default",
      "sudo sed -i 's/listen \\[::\\]:80 default_server;/listen [::]:8080 default_server;/' /etc/nginx/sites-enabled/default",
      "sudo systemctl restart nginx"
    ]

    connection {
      type    = "ssh"
      host    = self.network_interface[0].nat_ip_address
      user    = "ubuntu"
      agent   = true
      timeout = "5m"
    }
  }
}

resource "yandex_compute_instance" "imported" {
  name        = "compute-vm-2-2-20-ssd-1788437760947"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd82r0qtv0d5ic1o3b67"
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = "fl8e76fihcabtiusqri1"
    nat       = true
  }

  metadata = {
    private_ui_created_from = "console"

    ssh-keys = "kali:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3aRHy5EKzzCvQYbK57+IXOUXxbTo8pA859UC0zcJfW lanerJoseph@github.com"

    user-data = <<-EOT
      #cloud-config
      datasource:
       Ec2:
        strict_id: false
      ssh_pwauth: no
      users:
      - name: kali
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3aRHy5EKzzCvQYbK57+IXOUXxbTo8pA859UC0zcJfW lanerJoseph@github.com
    EOT
  }

  lifecycle {
    ignore_changes = [
      metadata["user-data"]
    ]
  }
}
