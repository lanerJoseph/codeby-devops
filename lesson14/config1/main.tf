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

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "lesson14" {
  name = "lesson14-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "lesson14-public"
  zone           = var.zone
  network_id     = yandex_vpc_network.lesson14.id
  v4_cidr_blocks = ["10.10.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = "lesson14-private"
  zone           = var.zone
  network_id     = yandex_vpc_network.lesson14.id
  v4_cidr_blocks = ["10.10.20.0/24"]
}

resource "yandex_vpc_security_group" "public" {
  name       = "lesson14-public-sg"
  network_id = yandex_vpc_network.lesson14.id

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
  name       = "lesson14-private-sg"
  network_id = yandex_vpc_network.lesson14.id

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
  name        = "lesson14-public-vm"
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
  name        = "lesson14-private-vm"
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
