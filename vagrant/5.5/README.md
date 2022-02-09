# Результаты домашнего задания "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

---

- В режиме `replicated` приложение запускается в том количестве экземпляров, какое укажет пользователь.  
В режиме `global` приложение запускается обязательно на каждой ноде и в единственном экземпляре.
- Алгоритм поддержания распределенного консенсуса — Raft
- Overlay Network — оверлейные сети соединяют вместе несколько демонов Docker и позволяют службам Docker Swarm взаимодействовать друг с другом в режиме кластера.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

```bash
docker node ls
```

---

```bash
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01 = "178.154.206.45"
external_ip_address_node02 = "178.154.202.131"
external_ip_address_node03 = "178.154.204.77"
external_ip_address_node04 = "178.154.206.217"
external_ip_address_node05 = "178.154.200.244"
external_ip_address_node06 = "178.154.202.39"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"

vagrant@vagrant:~/terraform$ ssh centos@178.154.206.45
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
z9xzpq0x65tf6mvy1ghcewjma *   node01.netology.yc   Ready     Active         Leader           20.10.12
5x2cdl9czkwbsss67s86tm4t4     node02.netology.yc   Ready     Active         Reachable        20.10.12
oum3ich0wtld4tljc4xwmquw8     node03.netology.yc   Ready     Active         Reachable        20.10.12
waqbtijqjifaurbjsoj8kd7s5     node04.netology.yc   Ready     Active                          20.10.12
y9bost9ze6oknz0dowdkn4yso     node05.netology.yc   Ready     Active                          20.10.12
v2v552g3cvlyq6u9pgadc7f82     node06.netology.yc   Ready     Active                          20.10.12
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

```bash
docker service ls
```

---

```bash
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
pfbw13elhxyl   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
z3m2kvjthnk9   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
43glwcm8cslt   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
lbgzdxz3xf7o   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
v6fc8a9dtdur   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
av8r790mb926   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
ivcv7qxu6el6   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
92llmoepaf2o   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```
