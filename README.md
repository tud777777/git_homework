# Домашнее задание к занятию «Хранение в K8s. Часть 2» - Баграш Фёдор

# Задание 1
multi-busy.yaml pv.yaml pvc.yaml\
![](/img/img2.png)\
![](/img/img3.png)\
pv не удалился потому что установлена политика Retain\
![](/img/img4.png)\
после удаления файл остался потому что hostPath — это прямое монтирование с хоста Kubernetes сознательно не удаляет такие данные
# Задание 2
multitool.yaml multitool-pvc.yaml\
![](/img/img6.png)\
![](/img/img7.png)
