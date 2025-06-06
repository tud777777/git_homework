terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

provider "yandex" {
  # token                    = "do not use!!!"
  cloud_id                 = "b1gsvfdtubarjbp5hrcg"
  folder_id                = "b1gbq0odhebh8pnqgnm9"
  service_account_key_file = file("authorized_key.json")
  zone                     = "ru-central1-a" #(Optional) 
}