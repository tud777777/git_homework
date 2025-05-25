resource "yandex_storage_bucket" "image_bucket" {
  bucket     = "student-bucket"
  access_key = var.access_key
  secret_key = var.secret_key
  acl        = "private"
  max_size   = 1073741824 # 1GB

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm      = "aws:kms"
      }
    }
  }

  depends_on = [yandex_kms_symmetric_key.bucket_key]
}

resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = "bucket-kms-key"
  description       = "KMS ключ для шифрования бакета"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" # 1 год
}

resource "yandex_storage_object" "image_file" {
  bucket     = yandex_storage_bucket.image_bucket.bucket
  key        = "site"
  source     = "index.html"
  acl        = "private"
}

# resource "yandex_compute_instance_group" "lamp_group" {
#   name               = "lamp-instance-group"
#   service_account_id = "aje3rcol1jl0n80jvcce"
#   folder_id          = var.folder_id
#   instance_template {
#     platform_id = "standard-v1"
#     resources {
#       cores = var.cores
#       core_fraction = var.core_fraction
#       memory = var.ram
#     }
#     scheduling_policy { preemptible = true }
#     boot_disk {
#       initialize_params {
#         image_id = "fd827b91d99psvq5fjit"
#       }
#     }
#     network_interface {
#       subnet_ids = [yandex_vpc_subnet.subnet-public.id]
#       nat                = true
#     }
#     metadata = {
#       user-data = "${file("cloud_config.yaml")}"
#     }
#   }

#   scale_policy {
#     fixed_scale {
#       size = 3
#     }
#   }

#   allocation_policy {
#     zones = ["ru-central1-a"]
#   }

#   deploy_policy {
#     max_unavailable = 1
#     max_creating    = 1
#     max_expansion   = 1
#     max_deleting    = 1
#   }

#   health_check {
#     http_options {
#       port = 80
#       path = "/"
#     }
#   }
# }

# resource "yandex_lb_target_group" "lamp_target_group" {
#   name = "lamp-target-group"

#   dynamic "target" {
#     for_each = yandex_compute_instance_group.lamp_group.instances
#     content {
#       subnet_id = target.value.network_interface[0].subnet_id
#       address   = target.value.network_interface[0].ip_address
#     }
#   }
# }

# resource "yandex_lb_network_load_balancer" "web_balancer" {
#   name = "lamp-nlb"

#   listener {
#     name = "http-listener"
#     port = 80
#     target_port = 80
#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }

#   attached_target_group {
#     target_group_id = yandex_lb_target_group.lamp_target_group.id

#     healthcheck {
#       name = "http"
#       http_options {
#         port = 80
#         path = "/"
#       }
#     }
#   }
# }






# resource "yandex_vpc_network" "network" {
#   name = "network"
# }

# resource "yandex_vpc_subnet" "subnet-public" {
#   network_id     = yandex_vpc_network.network.id
#   name           = "subnet-public"
#   v4_cidr_blocks = var.subnet_v4-1
#   zone = var.zone-a
# }

# resource "yandex_vpc_subnet" "subnet-private" {
#   network_id     = yandex_vpc_network.network.id
#   name           = "subnet-private"
#   v4_cidr_blocks = var.subnet_v4-2
#   route_table_id = yandex_vpc_route_table.route_table.id
#   zone = var.zone-a
# }

# resource "yandex_vpc_gateway" "natgateway" {
#   name = "natgateway"
#   shared_egress_gateway {}
# }

# resource "yandex_vpc_route_table" "route_table" {
#   name       = "route_table"
#   network_id = yandex_vpc_network.network.id

#   static_route {
#     destination_prefix = "0.0.0.0/0"
#     gateway_id         = yandex_vpc_gateway.natgateway.id
#   }
# }

# resource "yandex_compute_instance" "public" {
#   name = "public"
#   platform_id = "standard-v3"
#   zone = var.zone-a
#   boot_disk {
#     initialize_params {
#       image_id = var.image
#       size = var.disk_size
#       type = "network-hdd"
#     }
#   }
#   network_interface {
#     subnet_id = yandex_vpc_subnet.subnet-public.id
#     nat = true
#   }
#   resources {
#     cores = var.cores
#     core_fraction = var.core_fraction
#     memory = var.ram
#   }

#   scheduling_policy { preemptible = true }

#   metadata = {
#     serial-port-enable = "1"
#     user-data = "${file("cloud_config.yaml")}"
#   }
# }

# resource "yandex_compute_instance" "private" {
#   name = "private"
#   platform_id = "standard-v3"
#   zone = var.zone-a
#   boot_disk {
#     initialize_params {
#       image_id = var.image
#       size = var.disk_size
#       type = "network-hdd"
#     }
#   }
#   network_interface {
#     subnet_id = yandex_vpc_subnet.subnet-private.id
#   }
#   resources {
#     cores = var.cores
#     core_fraction = var.core_fraction
#     memory = var.ram
#   }

#   scheduling_policy { preemptible = true }

#   metadata = {
#     serial-port-enable = "1"
#     user-data = "${file("cloud_config.yaml")}"
#   }
# }