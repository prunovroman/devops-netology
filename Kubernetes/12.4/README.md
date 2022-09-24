# Результаты домашнего задания "12.4 Развертывание кластера на собственных серверах, лекция 2"

Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray

Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:

* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

---

> Развернуты ВМ в YC:

```bash
    ubuntu@ubuntu-VirtualBox:~$ yc compute instance list
    +----------------------+-----------+---------------+---------+---------------+-------------+
    |          ID          |   NAME    |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
    +----------------------+-----------+---------------+---------+---------------+-------------+
    | epd0la00li205gq51pi9 | wnode2    | ru-central1-b | RUNNING | 51.250.11.149 | 10.129.0.11 |
    | epd3vsncgcu78ujkhjjm | wnode4    | ru-central1-b | RUNNING | 51.250.80.252 | 10.129.0.15 |
    | epd50q6k1l2o9urepggh | cp1       | ru-central1-b | RUNNING | 51.250.78.180 | 10.129.0.45 |
    | epdci913674ar36vqsth | wnode3    | ru-central1-b | RUNNING | 51.250.92.220 | 10.129.0.16 |
    | epdoo9mg9h11gh346amp | wnode1    | ru-central1-b | RUNNING | 51.250.21.145 | 10.129.0.4  |
    +----------------------+-----------+---------------+---------+---------------+-------------+    
```

> Файл **inventory.ini** и запуск playbook:

```yaml
    [all]
    cp1    ansible_host=51.250.78.180  ip=10.129.0.45 etcd_member_name=etcd1 ansible_user=yc-user
    wnode1 ansible_host=51.250.21.145  ip=10.129.0.4  ansible_user=yc-user
    wnode2 ansible_host=51.250.11.149  ip=10.129.0.11 ansible_user=yc-user
    wnode3 ansible_host=51.250.92.220  ip=10.129.0.16 ansible_user=yc-user
    wnode4 ansible_host=51.250.80.252  ip=10.129.0.15 ansible_user=yc-user
    
    [kube_control_plane]
    cp1

    [etcd]
    cp1

    [kube_node]
    wnode1
    wnode2
    wnode3
    wnode4

    [k8s_cluster:children]
    kube_control_plane
    kube_node    
```

```bash
    ubuntu@ubuntu-VirtualBox:~/kubespray$ ansible-playbook -i inventory/netology/inventory.ini cluster.yml -b -v

    PLAY RECAP ************************************************************************************************************************************************************************************************************
    cp1                        : ok=712  changed=140  unreachable=0    failed=0    skipped=1240 rescued=0    ignored=9   
    wnode1                     : ok=476  changed=86   unreachable=0    failed=0    skipped=743  rescued=0    ignored=2   
    wnode2                     : ok=476  changed=86   unreachable=0    failed=0    skipped=742  rescued=0    ignored=2   
    wnode3                     : ok=476  changed=86   unreachable=0    failed=0    skipped=742  rescued=0    ignored=2   
    wnode4                     : ok=476  changed=86   unreachable=0    failed=0    skipped=742  rescued=0    ignored=2   
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

    Friday 23 September 2022  19:30:45 +0500 (0:00:00.199)       0:20:49.048 ******* 
    =============================================================================== 
    kubernetes/preinstall : Install packages requirements --------------------------------------------------------------------------------------------------------------------------------------------------------- 56.16s
    kubernetes/control-plane : kubeadm | Initialize first master -------------------------------------------------------------------------------------------------------------------------------------------------- 36.83s
    kubernetes/kubeadm : Join to cluster -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 26.85s
    download : download_container | Download image if required ---------------------------------------------------------------------------------------------------------------------------------------------------- 19.15s
    kubernetes/preinstall : Preinstall | wait for the apiserver to be running ------------------------------------------------------------------------------------------------------------------------------------- 16.71s
    network_plugin/calico : Wait for calico kubeconfig to be created ---------------------------------------------------------------------------------------------------------------------------------------------- 16.09s
    kubernetes/preinstall : Update package management cache (APT) ------------------------------------------------------------------------------------------------------------------------------------------------- 15.80s
    kubernetes-apps/ansible : Kubernetes Apps | Start Resources --------------------------------------------------------------------------------------------------------------------------------------------------- 14.10s
    download : download_container | Download image if required ---------------------------------------------------------------------------------------------------------------------------------------------------- 13.52s
    download : download_container | Download image if required ---------------------------------------------------------------------------------------------------------------------------------------------------- 12.21s
    kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates ---------------------------------------------------------------------------------------------------------------------------------------- 12.17s
    container-engine/containerd : containerd | Unpack containerd archive ------------------------------------------------------------------------------------------------------------------------------------------ 10.87s
    download : download_container | Download image if required ---------------------------------------------------------------------------------------------------------------------------------------------------- 10.44s
    download : download_container | Download image if required ----------------------------------------------------------------------------------------------------------------------------------------------------- 9.80s
    etcd : reload etcd --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 9.61s
    download : download_container | Download image if required ----------------------------------------------------------------------------------------------------------------------------------------------------- 8.44s
    download : download_container | Download image if required ----------------------------------------------------------------------------------------------------------------------------------------------------- 8.41s
    network_plugin/calico : Start Calico resources ----------------------------------------------------------------------------------------------------------------------------------------------------------------- 7.67s
    network_plugin/calico : Calico | Create calico manifests ------------------------------------------------------------------------------------------------------------------------------------------------------- 7.63s
    container-engine/crictl : extract_file | Unpacking archive ----------------------------------------------------------------------------------------------------------------------------------------------------- 7.37s 
```

> Информация о нодах:

```bash
    root@cp1:~$ kubectl get nodes -o wide
    NAME        STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
    cp1         Ready    control-plane   12m   v1.24.4   10.129.0.45   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode1      Ready    <none>          10m   v1.24.4   10.129.0.4    <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode2      Ready    <none>          10m   v1.24.4   10.129.0.11   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode3      Ready    <none>          10m   v1.24.4   10.129.0.16   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode4      Ready    <none>          10m   v1.24.4   10.129.0.15   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
```

> Информация о etcd:

```bash
    root@cp1:~$ etcdctl endpoint status \
                    --write-out=table \
                    --endpoints=127.0.0.1:2379 \
                    --cacert=/etc/ssl/etcd/ssl/ca.pem \
                    --cert=/etc/ssl/etcd/ssl/node-cp1.pem \
                    --key=/etc/ssl/etcd/ssl/node-cp1-key.pem 
    +----------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
    |    ENDPOINT    |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
    +----------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
    | 127.0.0.1:2379 | c1df3bc620c542ae |   3.5.4 |   10 MB |      true |      false |         3 |       4962 |               4962 |        |
    +----------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
```
