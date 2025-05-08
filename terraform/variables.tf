variable "zone-a" {
  type    = string
  default = "ru-central1-a"
}
variable "subnet_v4-1" {
  type    = list(string)
  default = ["192.168.10.0/24"]
}
variable "subnet_v4-2" {
  type    = list(string)
  default = ["192.168.20.0/24"]
}
variable "cores" {
  type = number
  default = 2
}
variable "ram" {
  type = number
  default = 2
}
variable "core_fraction" {
  type = number
  default = 20
}
variable "disk_size" {
  type = string
  default = "10"
}
variable "image" {
  type = string
  default = "fd80mrhj8fl2oe87o4e1"
}