variable "zone-a" {
  type    = string
  default = "ru-central1-a"
}
variable "network-1" {
  type    = string
  default = "network-1"
}
variable "subnet-1" {
  type    = list(string)
  default = ["192.168.1.0/24"]
}