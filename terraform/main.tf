resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet-public" {
  network_id     = yandex_vpc_network.network.id
  name           = "subnet-public"
  v4_cidr_blocks = var.subnet_v4-1
  zone = var.zone-a
}

resource "yandex_vpc_subnet" "subnet-private" {
  network_id     = yandex_vpc_network.network.id
  name           = "subnet-private"
  v4_cidr_blocks = var.subnet_v4-2
  route_table_id = yandex_vpc_route_table.route_table.id
  zone = var.zone-a
}

resource "yandex_vpc_gateway" "natgateway" {
  name = "natgateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route_table" {
  name       = "route_table"
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.natgateway.id
  }
}

resource "yandex_compute_instance" "public" {
  name = "public"
  platform_id = "standard-v3"
  zone = var.zone-a
  boot_disk {
    initialize_params {
      image_id = var.image
      size = var.disk_size
      type = "network-hdd"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    nat = true
  }
  resources {
    cores = var.cores
    core_fraction = var.core_fraction
    memory = var.ram
  }

  scheduling_policy { preemptible = true }

  metadata = {
    serial-port-enable = "1"
    user-data = "${file("cloud_config.yaml")}"
  }
}

resource "yandex_compute_instance" "private" {
  name = "private"
  platform_id = "standard-v3"
  zone = var.zone-a
  boot_disk {
    initialize_params {
      image_id = var.image
      size = var.disk_size
      type = "network-hdd"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-private.id
  }
  resources {
    cores = var.cores
    core_fraction = var.core_fraction
    memory = var.ram
  }

  scheduling_policy { preemptible = true }

  metadata = {
    serial-port-enable = "1"
    user-data = "${file("cloud_config.yaml")}"
  }
}