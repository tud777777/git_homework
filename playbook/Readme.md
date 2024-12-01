# Описание site.yml playbook

Плейбук описывает развертывание `clickhouse` и `vector` на хосты, указанные в `inventory`

- [group_vars clickhouse](#group_vars_clickhouse)
- [group_vars vector](#group_vars_vector)
- [Inventory](#inventory)
- [Playbook](#playbook)
  - [Play "Install Clickhouse"](#play_install_clickhouse)
  - [Tasks Play "Install Clickhouse"](#tasks_play_install_clickhouse)
  - [Play "Install Vector"](#play_install_vector)
  - [Tasks Play "Install Vector"](#tasks_play_install_vector)
- [Template](#template)

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

## Inventory

Группа "clickhouse" состоит из 1 хоста `clickhouse-01` и тип коннектора `docker`

Группа "vector" состоит из 1 хоста `vector-01` и тип коннектора `docker`

## Playbook

Playbook состоит из 2 `play`

### play_install_clickhouse

Применяется на группу хостов "clickhouse", тэгируется "clickhouse" и предназначен для установки и запуска `clickhouse`

Обработчик (handler) для запуска `clickhouse-server`, таски обращаются к нему через ключ **notify: Start clickhouse service**
```yaml
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
```

### tasks_play_install_clickhouse

| Имя таска | Описание |
|--------------|---------|
| `Clickhouse \| Download` | Скачивание пакетов. Используется цикл с перменными `clickhouse_packages`. Так как не у всех пакетов есть `noarch` версии, используем перехват ошибки `rescue` |
| `Clickhouse \| Install` | Установка пакетов, вызов обработчика `Start clickhouse service` через `notify` |
| `Clickhouse \| Flush handlers` | Принудительное выполнение handler `Start clickhouse service` |
| `Clickhouse \| Create database` | Создание БД с названием **logs** и указание условий изменения состояния таска |

### play_install_vector

Применяется на группу хостов "vector", тэгируется "vector" и предназначен для установки, конфигурирования и запуска `vector`

Обработчик (handler) для запуска `vector`, таски обращаются к нему через ключ **notify: Start Vector service**
```yaml
  handlers:
    - name: Start Vector service
      become: true
      become_method: su
      become_user: root
      ansible.builtin.service:
        name: vector
        state: restarted
```

### tasks_play_install_vector

| Имя таска | Описание |
|--------------|---------|
| `Vector \| Download` | Скачивание пакета |
| `Vector \| Install` | Установка пакета |
| `Vector \| Apply template` | Применение шаблона конфига `vector` и валидация |
| `Vector \| Change systemd unit` | Изменение модуля службы `vector` |
| `Vector \| Pause for 10 seconds to create vector service` | Пауза в 10 секунд для обноления systemctl `vector` и вызов обработчика `Start Vector service` через `notify` |

## Template

Шаблон "vector.service.j2" используется для изменения модуля службы `vector`. В нем определена строка запуска `vector` и пользователь для запуска

Шаблон "vector.yml.j2" используется для настройки конфига `vector`. Указывает на расположение конфига в переменной "vector_config" и необходимость преобразования в `YAML`