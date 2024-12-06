# Описание site.yml playbook

Плейбук описывает развертывание `clickhouse`, `lighthouse` и `vector` на хосты, указанные в `inventory`

## group_vars_clickhouse

| Переменная  | Назначение  |
|:---|:---|
| `clickhouse_version` | версия `clickhouse` |
| `clickhouse_packages` | имена пакетов для скачивания и установки |

## group_vars_vector

| Переменная  | Назначение  |
|:---|:---|
| `vector_version` | версия `vector` |
| `vector_url` | URL-адрес пакета `vector` |
| `vector_config_dir` | каталог для конфига `vector` |
| `vector_config` | конфиг файл `vector` |

## group_vars_lighthouse

| Переменная  | Назначение  |
|:---|:---|
| `nginx_user_name` | пользователь `nginx` |

## Inventory

Группа "clickhouse" состоит из 1 хоста `clickhouse` и ip-адреса

Группа "vector" состоит из 1 хоста `vector` и ip-адреса

Группа "lighthouse" состоит из 1 хоста `lighthouse` и ip-адреса

## Playbook

Playbook состоит из 4 `play`

### play_install_clickhouse

Применяется на группу хостов "clickhouse", тэгируется "clickhouse" и предназначен для установки и запуска `clickhouse`

### play_install_vector

Применяется на группу хостов "vector", тэгируется "vector" и предназначен для установки, конфигурирования и запуска `vector`

### play_install_nginx

Применяется на группу хостов "nginx" и предназначен для установки, конфигурирования и запуска `nginx`

### play_install_lighthouse

Применяется на группу хостов "lighthouse" и предназначен для установки, конфигурирования и запуска `lighthouse`

## Template

Шаблон "vector.service.j2" используется для изменения модуля службы `vector`. В нем определена строка запуска `vector` и пользователь для запуска

Шаблон "vector.yml.j2" используется для настройки конфига `vector`. Указывает на расположение конфига в переменной "vector_config" и необходимость преобразования в `YAML`

Шаблон "nginx.conf.j2" используется для настройки конфига `nginx`. 

Шаблон "lighthouse.conf.j2" используется для настройки конфига `lighthouse` в `nginx`. 