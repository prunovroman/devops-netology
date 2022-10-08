# Результаты домашнего задания "12.5 Сетевые решения CNI"

После работы с Flannel появилась необходимость обеспечить безопасность для приложения. Для этого лучше всего подойдет Calico.

## Задание 1: установить в кластер CNI плагин Calico

Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования:

* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)

---

> Кластер развернут в YC:

```bash
    root@cp1:~$ kubectl get nodes -o wide
    NAME        STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
    cp1         Ready    control-plane   85m   v1.24.4   10.129.0.12   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode1      Ready    <none>          82m   v1.24.4   10.129.0.42   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode2      Ready    <none>          82m   v1.24.4   10.129.0.5    <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode3      Ready    <none>          82m   v1.24.4   10.129.0.26   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
    wnode4      Ready    <none>          82m   v1.24.4   10.129.0.13   <none>        Ubuntu 20.04.4 LTS   5.4.0-124-generic   containerd://1.6.8
```

> Развернул под:

`kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2`

```bash
    root@cp1:~$ kubectl get pods -o wide
    NAME                          READY   STATUS    RESTARTS   AGE   IP            NODE            NOMINATED NODE   READINESS GATES
    hello-node-7f6g865vv1-6w5y8   1/1     Running   0          82m   10.233.47.2   wnode1          <none>           <none>
    hello-node-7f6g865vv1-fb9cm   1/1     Running   0          82m   10.233.74.10  wnode3          <none>           <none>
```

> Создал сервис:

`kubectl expose deployment hello-node --port=8080`

```bash
    root@cp1:~$ kubectl get services -o wide
    NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE   SELECTOR
    hello-node   LoadBalancer   10.233.41.14   <pending>     8080:31619/TCP   82m   app=hello-node
    kubernetes   ClusterIP      10.233.0.1     <none>        443/TCP          87m   <none>
```

> Создал политику разрешающую хождение трафика между двумя репликами:

```bash
    root@cp1:~$ cat <<EOF | kubectl apply -f -
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: hello-node
      namespace: default
    spec:
      podSelector:
        matchLabels:
          app: hello-node
      ingress:
      - from:
          - podSelector:
              matchLabels:
              app: hello-node
      egress:
      - to:
          - podSelector:
              matchLabels:
              app: hello-node
    EOF
```

> Создал политику запрещающего правила:

```bash
    root@cp1:~$ cat <<EOF | kubectl apply -f -
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: hello-node
      namespace: default
    spec:
      podSelector:
          matchLabels:
            app: hello-node
      policyTypes:
      - Ingress
      - Egress
    EOF
```

> Проверка доступа от одного пода к другому:

```bash
    root@cp1:~$ kubectl exec hello-node-7f6g865vv1-6w5y8 -- curl -m 1 -s http://10.233.74.10:8080 | grep -e request_uri -e host -e client_address
    client_address=10.233.47.2
    request_uri=http://10.233.74.10:8080/
    host=10.233.74.10:8080

    root@cp1:~$ kubectl exec hello-node-7f6g865vv1-fb9cm -- curl -m 1 -s http://10.233.47.2:8080 | grep -e request_uri -e host -e client_address
    client_address=10.233.74.10
    request_uri=http:/10.233.47.2:8080/
    host=10.233.47.2:8080
```

> Проверка доступа извне:

```bash
    root@cp1:~$ curl -s -v -m 1 http://51.250.78.69:31619 | grep -e request_uri -e host -e client_address
    *   Trying 51.250.78.69:31619...
    * Connection timed out after 1001 milliseconds
    * Closing connection 0
```

## Задание 2: изучить, что запущено по умолчанию

Самый простой способ — проверить командой calicoctl get <type>. Для проверки стоит получить список нод, ipPool и profile.
Требования:

* установить утилиту calicoctl;
* получить 3 вышеописанных типа в консоли.

---

> Утилита установлена `kubespray`:

```bash
    root@cp1:~$ calioctl version
    Client Version:     v3.23.3
    Git commit:         3a3559be1
    Cluster Version:    v3.23.3
    Cluster Type:       kubespray,kubeadm,kdd
```

> Вывод команды `ipPool`:

```bash
    root@cp1:~$ calioctl get ipPool
    NAME           CIDR             SELECTOR
    default-pool   10.233.64.0/18   all()
```

> Вывод команды `nodes`:

```bash
    root@cp1:~$ calioctl get nodes
    NAME
    cp1
    wnode1
    wnode2
    wnode3
    wnode4
```

> Вывод команды `profile`:

```bash
    root@cp1:~$ calioctl get profile
    NAME
    projectcalico-default-allow
    kns.default
    kns.kube-node-lease
    kns.kube-public
    kns.kube-system
    ksa.default.default
    ksa.kube-node-lease.default
    ksa.kube-public.default
    ksa.kube-system.attachdetach-controller
    ksa.kube-system.bootstrap-signer
    ksa.kube-system.calico-node
    ksa.kube-system.certificate-controller
    ksa.kube-system.clusterrole-aggregation-controller
    ksa.kube-system.coredns
    ksa.kube-system.cronjob-controller
    ksa.kube-system.daemon-set-controller
    ksa.kube-system.default
    ksa.kube-system.deployment-controller
    ksa.kube-system.disruption-controller
    ksa.kube-system.dns-autoscaler
    ksa.kube-system.endpoint-controller
    ksa.kube-system.endpointslice-controller
    ksa.kube-system.endpointslicemirroring-controller
    ksa.kube-system.ephemeral-volume-controller
    ksa.kube-system.expand-controller
    ksa.kube-system.generic-garbage-collector
    ksa.kube-system.horizontal-pod-autoscaler
    ksa.kube-system.job-controller
    ksa.kube-system.kube-proxy
    ksa.kube-system.namespace-controller
    ksa.kube-system.node-controller
    ksa.kube-system.nodelocaldns
    ksa.kube-system.persistent-volume-binder
    ksa.kube-system.pod-garbage-collector
    ksa.kube-system.pv-protection-controller
    ksa.kube-system.pvc-protection-controller
    ksa.kube-system.replicaset-controller
    ksa.kube-system.replication-controller
    ksa.kube-system.resourcequota-controller
    ksa.kube-system.root-ca-cert-publisher
    ksa.kube-system.service-account-controller
    ksa.kube-system.service-controller
    ksa.kube-system.statefulset-controller
    ksa.kube-system.token-cleaner
    ksa.kube-system.ttl-after-finished-controller
    ksa.kube-system.ttl-controller
```
