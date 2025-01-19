# Домашнее задание к занятию "13.Системы мониторинга" - Баграш Фёдор

1. ![alt text](./img/tsk1.png)
2. ![alt text](./img/tsk2.png)
CPULA 1/5/15 - node_load1 node_load5 node_load15
CPU 100% - rate(node_cpu_seconds_total{cpu="0", mode="idle"}[1m]) * 100
Free Storage - node_filesystem_avail_bytes{mountpoint="/etc/hostname"}
Free RAM - node_memory_MemFree_bytes
3. ![alt text](./img/tsk3.png)
4. ./img/Dashboard-1737317308358.json
