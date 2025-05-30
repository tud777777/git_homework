resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet-public-a" {
  network_id     = yandex_vpc_network.network.id
  name           = "subnet-public-a"
  v4_cidr_blocks = var.subnet_v4-1
  route_table_id = yandex_vpc_route_table.route_table.id
  zone = var.zone-a
}

resource "yandex_vpc_subnet" "subnet-public-b" {
  network_id     = yandex_vpc_network.network.id
  name           = "subnet-public-b"
  v4_cidr_blocks = var.subnet_v4-4
  route_table_id = yandex_vpc_route_table.route_table.id
  zone = var.zone-b
}

resource "yandex_vpc_subnet" "subnet-public-d" {
  network_id     = yandex_vpc_network.network.id
  name           = "subnet-public-d"
  v4_cidr_blocks = var.subnet_v4-5
  route_table_id = yandex_vpc_route_table.route_table.id
  zone = var.zone-d
}

resource "yandex_vpc_subnet" "subnet-private-a" {
  network_id     = yandex_vpc_network.network.id
  name           = "subnet-private-a"
  v4_cidr_blocks = var.subnet_v4-2
  zone = var.zone-a
}

resource "yandex_vpc_subnet" "subnet-private-b" {
  network_id     = yandex_vpc_network.network.id
  name           = "subnet-private-b"
  v4_cidr_blocks = var.subnet_v4-3
  zone = var.zone-b
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