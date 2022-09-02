# Результаты домашнего задания "12.1 Компоненты Kubernetes"

Вы DevOps инженер в крупной компании с большим парком сервисов. Ваша задача — разворачивать эти продукты в корпоративном кластере.

## Задача 1: Установить Minikube

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине Minikube.

### Как поставить на AWS

- создать EC2 виртуальную машину (Ubuntu Server 20.04 LTS (HVM), SSD Volume Type) с типом **t3.small**. Для работы потребуется настроить Security Group для доступа по ssh. Не забудьте указать keypair, он потребуется для подключения.
- подключитесь к серверу по ssh (ssh ubuntu@<ipv4_public_ip> -i <keypair>.pem)
- установите миникуб и докер следующими командами:
  - curl -LO <https://storage.googleapis.com/kubernetes-release/release/>`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  - chmod +x ./kubectl
  - sudo mv ./kubectl /usr/local/bin/kubectl
  - sudo apt-get update && sudo apt-get install docker.io conntrack -y
  - curl -Lo minikube <https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64> && chmod +x minikube && sudo mv minikube /usr/local/bin/
- проверить версию можно командой minikube version
- переключаемся на root и запускаем миникуб: minikube start --vm-driver=none
- после запуска стоит проверить статус: minikube status
- запущенные служебные компоненты можно увидеть командой: kubectl get pods --namespace=kube-system

### Для сброса кластера стоит удалить кластер и создать заново

- minikube delete
- minikube start --vm-driver=none

Возможно, для повторного запуска потребуется выполнить команду: sudo sysctl fs.protected_regular=0

Инструкция по установке Minikube - [ссылка](https://kubernetes.io/ru/docs/tasks/tools/install-minikube/)

**Важно**: t3.small не входит во free tier, следите за бюджетом аккаунта и удаляйте виртуалку.

---

```bash
    ubuntu@ubuntu-VirtualBox:~$ minikube version
    minikube version: v1.26.1
    commit: 62e108c3dfdec8029a890ad6d8ef96b6461426dc
```

```bash
    ubuntu@ubuntu-VirtualBox:~$ kubectl version --output=yaml
        clientVersion:
        buildDate: "2022-08-23T17:44:59Z"
        compiler: gc
        gitCommit: a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2
        gitTreeState: clean
        gitVersion: v1.25.0
        goVersion: go1.19
        major: "1"
        minor: "25"
        platform: linux/amd64
    kustomizeVersion: v4.5.7
    serverVersion:
        buildDate: "2022-07-13T14:23:26Z"
        compiler: gc
        gitCommit: aef86a93758dc3cb2c658dd9657ab4ad4afc21cb
        gitTreeState: clean
        gitVersion: v1.24.3
        goVersion: go1.18.3
        major: "1"
        minor: "24"
        platform: linux/amd64
```

```bash
    ubuntu@ubuntu-VirtualBox:~$ minikube status
    minikube
    type: Control Plane
    host: Running
    kubelet: Running
    apiserver: Running
    kubeconfig: Configured
```

```bash
    ubuntu@ubuntu-VirtualBox:~$ kubectl get pods --namespace=kube-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    coredns-6d4b75cb6d-vvvrc                    0/1     Pending   0          10m
    etcd-ubuntu-virtualbox                      1/1     Running   0          10m
    kube-apiserver-ubuntu-virtualbox            1/1     Running   0          10m
    kube-controller-manager-ubuntu-virtualbox   1/1     Running   0          10m
    kube-proxy-v9wg6                            1/1     Running   0          10m
    kube-scheduler-ubuntu-virtualbox            1/1     Running   0          10m
    storage-provisioner                         0/1     Pending   0          10m

```

## Задача 2: Запуск Hello World

После установки Minikube требуется его проверить. Для этого подойдет стандартное приложение hello world. А для доступа к нему потребуется ingress.

- развернуть через Minikube тестовое приложение по [туториалу](https://kubernetes.io/ru/docs/tutorials/hello-minikube/#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%B0-minikube)
- установить аддоны ingress и dashboard

---

```bash
    ubuntu@ubuntu-VirtualBox:~$ kubectl get deployments
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    hello-node   1/1     1            1           2m13s
```

```bash
    ubuntu@ubuntu-VirtualBox:~$ kubectl get pods
    NAME                          READY   STATUS    RESTARTS   AGE
    hello-node-6d5f754cc9-2t78g   1/1     Running   0          3m25s

```

```bash
    ubuntu@ubuntu-VirtualBox:~$ kubectl get pods --all-namespaces
    NAMESPACE              NAME                                         READY   STATUS      RESTARTS      AGE
    default                hello-node-6d5f754cc9-2t78g                  1/1     Running     0             5m36s
    ingress-nginx          ingress-nginx-admission-create-t7s7x         0/1     Completed   0             18m
    ingress-nginx          ingress-nginx-admission-patch-5r6d2          0/1     Completed   0             18m
    ingress-nginx          ingress-nginx-controller-755dfbfc65-86884    1/1     Running     0             18m
    kube-system            coredns-6d4b75cb6d-pkqkn                     1/1     Running     0             58m
    kube-system            etcd-minikube                                1/1     Running     0             58m
    kube-system            kube-apiserver-minikube                      1/1     Running     0             58m
    kube-system            kube-controller-manager-minikube             1/1     Running     0             58m
    kube-system            kube-proxy-qb6gc                             1/1     Running     0             58m
    kube-system            kube-scheduler-minikube                      1/1     Running     0             58m
    kube-system            storage-provisioner                          1/1     Running     1 (58m ago)   58m
    kubernetes-dashboard   dashboard-metrics-scraper-78dbd9dbf5-8m6jp   1/1     Running     0             57m
    kubernetes-dashboard   kubernetes-dashboard-5fd5574d9f-d74mt        1/1     Running     0             57m
```

## Задача 3: Установить kubectl

Подготовить рабочую машину для управления корпоративным кластером. Установить клиентское приложение kubectl.

- подключиться к minikube
- проверить работу приложения из задания 2, запустив port-forward до кластера

---
