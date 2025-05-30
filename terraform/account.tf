resource "yandex_iam_service_account" "k8s" {
  name = "k8s-service-account"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}
