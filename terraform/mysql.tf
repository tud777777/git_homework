resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name        = "netology-mysql"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network.id
  version     = "8.0"
  deletion_protection = true
  backup_window_start {
    hours   = 23
    minutes = 59
  }

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-private-a.id
    assign_public_ip = false
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.subnet-private-b.id
    assign_public_ip = false
  }

  maintenance_window {
    type = "ANYTIME"
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "netology_user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "netology_user"
  password   = var.db_password

  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
  }
}