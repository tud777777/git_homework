resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name        = "k8s-cluster"
  network_id  = yandex_vpc_network.network.id
  master {
    regional {
      region = "ru-central1"
      location {
        zone      = "ru-central1-a"
        subnet_id = yandex_vpc_subnet.subnet-public-a.id
      }
      location {
        zone      = "ru-central1-b"
        subnet_id = yandex_vpc_subnet.subnet-public-b.id
      }
      location {
        zone      = "ru-central1-d"
        subnet_id = yandex_vpc_subnet.subnet-public-d.id
      }
    }
    public_ip     = true
    security_group_ids = []
  }

  service_account_id      = yandex_iam_service_account.k8s.id
  node_service_account_id = yandex_iam_service_account.k8s.id

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s_key.id
  }
}

resource "yandex_kubernetes_node_group" "node_group" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "k8s-node-group"
  version    = "1.29"

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone      = "ru-central1-a"
    }
  }

  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      size = 20
      type = "network-hdd"
    }

    network_interface {
      nat        = false
      subnet_ids = [
        yandex_vpc_subnet.subnet-public-a.id
      ]
    }
  }
}
