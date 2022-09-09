# Результаты домашнего задания "12.2 Команды для работы с Kubernetes"

Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

## Задание 1: Запуск пода из образа в деплойменте

Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2).

Требования:

- пример из hello world запущен в качестве deployment
- количество реплик в deployment установлено в 2
- наличие deployment можно проверить командой kubectl get deployment
- наличие подов можно проверить командой kubectl get pods

---

```bash
    ubuntu@ubuntu-VirtualBox:~/blackbird$ kubectl create deployment hello-world --image=k8s.gcr.io/echoserver:1.4 --replicas=2
    deployment.apps/hello-world created
```

```bash
    ubuntu@ubuntu-VirtualBox:~/blackbird$ kubectl get deployments
    NAME          READY   UP-TO-DATE   AVAILABLE   AGE
    hello-world   2/2     2            2           4m9s
```

```bash
    ubuntu@ubuntu-VirtualBox:~/blackbird$ kubectl get pods
    NAME                           READY   STATUS    RESTARTS   AGE
    hello-world-68bfd59bd9-t8hwr   1/1     Running   0          4m24s
    hello-world-68bfd59bd9-xs7dx   1/1     Running   0          4m24s
```

## Задание 2: Просмотр логов для разработки

Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе.
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования:

- создан новый токен доступа для пользователя
- пользователь прописан в локальный конфиг (~/.kube/config, блок users)
- пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

---

```bash
    ubuntu@ubuntu-VirtualBox:~$ openssl genrsa -out user.key 2048
    Generating RSA private key, 2048 bit long modulus (2 primes)
    ............+++++
    .........................+++++
    e is 65537 (0x010001)

    ubuntu@ubuntu-VirtualBox:~$ openssl req -new -key user.key -out user.csr -subj "/CN=user/O=app-namespace"

    ubuntu@ubuntu-VirtualBox:~$ openssl x509 -req -in user.csr -CA .minikube/ca.crt -CAkey .minikube/ca.key -CAcreateserial -out user.crt -days 10
    Signature ok
    subject=CN = user, O = app-namespace
    Getting CA Private Key

    ubuntu@ubuntu-VirtualBox:~$ kubectl create namespace app-namespace
    namespace/app-namespace created

    ubuntu@ubuntu-VirtualBox:~$ kubectl config set-credentials user --client-certificate=user.crt --client-key=user.key
    User "user" set.

    ubuntu@ubuntu-VirtualBox:~$ kubectl config view
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority: /home/ubuntu/.minikube/ca.crt
        extensions:
        - extension:
            last-update: Fri, 09 Sep 2022 12:58:24 +05
            provider: minikube.sigs.k8s.io
            version: v1.26.1
        name: cluster_info
        server: https://192.168.49.2:8443
    name: minikube
    contexts:
    - context:
        cluster: minikube
        extensions:
        - extension:
            last-update: Fri, 09 Sep 2022 12:58:24 +05
            provider: minikube.sigs.k8s.io
            version: v1.26.1
        name: context_info
        namespace: default
        user: minikube
    name: minikube
    current-context: minikube
    kind: Config
    preferences: {}
    users:
    - name: minikube
    user:
        client-certificate: /home/ubuntu/.minikube/profiles/minikube/client.crt
        client-key: /home/ubuntu/.minikube/profiles/minikube/client.key
    - name: user
    user:
        client-certificate: /home/ubuntu/user.crt
        client-key: /home/ubuntu/user.key

    ubuntu@ubuntu-VirtualBox:~$ kubectl config set-context user-context --cluster=minikube --namespace=app-namespace --user=user
    Context "user-context" created.

    ubuntu@ubuntu-VirtualBox:~$ kubectl config get-contexts
    CURRENT   NAME           CLUSTER    AUTHINFO   NAMESPACE
    *         minikube       minikube   minikube   default
            user-context   minikube   user       app-namespace
    
```

### user-role.yml

```bash
    ubuntu@ubuntu-VirtualBox:~$ cat user-role.yml 
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
        namespace: app-namespace
        name: log-reader
    rules:
    - apiGroups: [""]
        resources: ["pods","pods/log"]
        verbs: ["get", "list"]
    
    ubuntu@ubuntu-VirtualBox:~$ kubectl create -f user-role.yml 
    role.rbac.authorization.k8s.io/log-reader created
```

### user-rolebind.yml

```bash
    ubuntu@ubuntu-VirtualBox:~$ cat user-rolebind.yml 
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: log-readerbind
    namespace: app-namespace
    subjects:
    - kind: User
        name: user
        apiGroup: rbac.authorization.k8s.io
    roleRef:
        kind: Role
        name: log-reader
        apiGroup: rbac.authorization.k8s.io
    
    ubuntu@ubuntu-VirtualBox:~$ kubectl create -f user-rolebind.yml 
    rolebinding.rbac.authorization.k8s.io/log-readerbind created

```

## Задание 3: Изменение количества реплик

Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик.

Требования:

- в deployment из задания 1 изменено количество реплик на 5
- проверить что все поды перешли в статус running (kubectl get pods)

---

```bash
    ubuntu@ubuntu-VirtualBox:~$ kubectl get deployment
    NAME          READY   UP-TO-DATE   AVAILABLE   AGE
    hello-world   2/2     2            2           4h31m

    ubuntu@ubuntu-VirtualBox:~$ kubectl scale --replicas=5 deployment/hello-world
    deployment.apps/hello-world scaled

    ubuntu@ubuntu-VirtualBox:~$ kubectl get deployment
    NAME          READY   UP-TO-DATE   AVAILABLE   AGE
    hello-world   5/5     5            5           3m21s

    ubuntu@ubuntu-VirtualBox:~$ kubectl get pods
    NAME                           READY   STATUS    RESTARTS   AGE
    hello-world-68bfd59bd9-7lwcx   1/1     Running   0          2m28s
    hello-world-68bfd59bd9-9tf2z   1/1     Running   0          4m8s
    hello-world-68bfd59bd9-mhxql   1/1     Running   0          4m8s
    hello-world-68bfd59bd9-xzht7   1/1     Running   0          2m28s
    hello-world-68bfd59bd9-zgd6s   1/1     Running   0          2m28s
```
