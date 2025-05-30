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