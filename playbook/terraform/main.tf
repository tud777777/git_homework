terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

provider "yandex" {
  cloud_id                 = "b1gsvfdtubarjbp5hrcg"
  folder_id                = "b1gbq0odhebh8pnqgnm9"
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = "ru-central1-a" 
}

resource "yandex_vpc_network" "network-1" {
  name = var.network-1
}

resource "yandex_vpc_subnet" "subnet-1" {
  network_id     = yandex_vpc_network.network-1.id
  name           = "subnet-1"
  v4_cidr_blocks = var.subnet-1
  zone = var.zone-a
}

data "yandex_compute_image" "centos-7" {
  family = "centos-7"
}

resource "yandex_compute_instance" "lighthouse" {
  name = "lighthouse"
  platform_id = "standard-v3"
  zone = var.zone-a
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
      size = "10"
      type = "network-hdd"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
  }
  resources {
    cores = 2
    core_fraction = 20
    memory = 2
  }
  metadata = {
    serial-port-enable = "true"
    user-data = "${file("cloud_config.yaml")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vector" {
  name = "vector"
  platform_id = "standard-v3"
  zone = var.zone-a
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
      size = "10"
      type = "network-hdd"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
  }
  resources {
    cores = 2
    core_fraction = 20
    memory = 2
  }
  metadata = {
    serial-port-enable = "true"
    user-data = "${file("cloud_config.yaml")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "clickhouse" {
  name = "clickhouse"
  platform_id = "standard-v3"
  zone = var.zone-a
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
      size = "10"
      type = "network-hdd"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
  }
  resources {
    cores = 2
    core_fraction = 20
    memory = 2
  }
  metadata = {
    serial-port-enable = "true"
    user-data = "${file("cloud_config.yaml")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

  { clickhouse = yandex_compute_instance.clickhouse, vector = yandex_compute_instance.vector, lighthouse = yandex_compute_instance.lighthouse })

  filename = "../inventory/prod.yml"
}
