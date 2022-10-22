# Результаты домашнего задания "13.3 работа с kubectl"

## Задание 1: проверить работоспособность каждого компонента

Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:

* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

---

> Список ресурсов:

```bash

    root@controlnode:~$ kubectl get all
    NAME                             READY   STATUS    RESTARTS   AGE
    pod/backend-7hgbc855fc-c7by8     1/1     Running   0          10m
    pod/frontend-75fd5rt795-h5df6    1/1     Running   0          11m
    pod/multitool-5dr7664c8b-o9rt5   1/1     Running   0          10m
    pod/postgres-db-0                1/1     Running   0          10m

    NAME                      TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
    service/backend           ClusterIP      10.233.28.211   <none>        9000/TCP       11m
    service/frontend          LoadBalancer   10.233.40.95    <none>        80/TCP         11m
    service/postgres-db       ClusterIP      10.233.27.235   <none>        5432/TCP       11m

    NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/backend     1/1     1            1           10m
    deployment.apps/frontend    1/1     1            1           11m
    deployment.apps/multitool   1/1     1            1           10m

    NAME                                   DESIRED   CURRENT   READY   AGE
    replicaset.apps/backend-7hgbc855fc     1         1         1       11m
    replicaset.apps/frontend-75fd5rt795    1         1         1       11m
    replicaset.apps/multitool-5dr7664c8b   1         1         1       11m

    NAME                           READY   AGE
    statefulset.apps/postgres-db   1/1     11m

```

> Выполнение запросов с помощью `exec`:

```bash

    root@controlnode:~$ kubectl exec multitool-5dr7664c8b-o9rt5 -- curl -s frontend
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <title>Список</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="/build/main.css" rel="stylesheet">
    </head>
    <body>
        <main class="b-page">
            <h1 class="b-page__title">Список</h1>
            <div class="b-page__content b-items js-list"></div>
        </main>
        <script src="/build/main.js"></script>
    </body>
    </html>

```

```bash

    root@controlnode:~$ kubectl exec frontend-75fd5rt795-h5df6 -- curl -s backend:9000
    Defaulted container "frontend" out of: frontend, wait-backend (init)
    {"detail":"Not Found"}

```

```bash

    root@controlnode:~$ kubectl exec multitool-5dr7664c8b-o9rt5 -- psql postgresql://postgres:postgres@postgres-db:5432 -c "\l"
                                    List of databases
    Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -----------+----------+----------+------------+------------+-----------------------
    news      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    (4 rows)

```

> Выполнение запросов с помощью `port-forward`:

```bash

   root@controlnode:~$ kubectl port-forward frontend-75fd5rt795-h5df6 8080:80 >/dev/null 2>&1 &
   [1] 45854

   root@controlnode:~$ curl -s localhost:8080
   <!DOCTYPE html>
   <html lang="ru">
   <head>
       <title>Список</title>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <link href="/build/main.css" rel="stylesheet">
   </head>
   <body>
       <main class="b-page">
           <h1 class="b-page__title">Список</h1>
           <div class="b-page__content b-items js-list"></div>
       </main>
       <script src="/build/main.js"></script>
   </body>
   </html>

```

```bash

   root@controlnode:~$ kubectl port-forward backend-7hgbc855fc-c7by8 9090:9000 >/dev/null 2>&1 &
   [1] 48589

   root@controlnode:~$ curl -s localhost:9090
   {"detail":"Not Found"}

```

```bash

   root@controlnode:~$ kubectl port-forward postgres-db-0 3254:5432 >/dev/null 2>&1 &
   [1] 48756

   root@controlnode:~$ psql postgresql://postgres:postgres@localhost:3254 -c "\l"
                                   List of databases
    Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -----------+----------+----------+------------+------------+-----------------------
    news      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
              |          |          |            |            | postgres=CTc/postgres
    (4 rows)

```

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

---

```bash

    root@controlnode:~$ kubectl get po -o wide
    NAME                         READY   STATUS    RESTARTS   AGE    IP             NODE       NOMINATED NODE   READINESS GATES
    backend-7hgbc855fc-c7by8     1/1     Running   0          28m    10.233.69.10   worker01   <none>           <none>
    frontend-75fd5rt795-h5df6    1/1     Running   0          125m   10.233.90.11   worker02   <none>           <none>
    multitool-5dr7664c8b-o9rt5   1/1     Running   0          108m   10.233.69.5    worker01   <none>           <none>
    postgres-db-0                1/1     Running   0          126m   10.233.90.98   worker02   <none>           <none>


    root@controlnode:~$ kubectl scale --replicas=3 deployment backend
    deployment.apps/backend scaled


    root@controlnode:~$ kubectl patch deployment frontend -p '{"spec":{"replicas":3}}' --type=merge
    deployment.apps/frontend patched


    root@controlnode:~$ kubectl get po -o wide
    NAME                         READY   STATUS    RESTARTS   AGE    IP             NODE       NOMINATED NODE   READINESS GATES
    backend-7hgbc855fc-c7by8     1/1     Running   0          28m    10.233.69.14   worker01   <none>           <none>
    backend-7hgbc855fc-f8drb     1/1     Running   0          24s    10.233.90.25   worker02   <none>           <none>
    backend-7hgbc855fc-gmk34     1/1     Running   0          24s    10.233.90.23   worker02   <none>           <none>
    frontend-75fd5rt795-h5df6    1/1     Running   0          125m   10.233.90.11   worker02   <none>           <none>
    frontend-75fd5rt795-khs4g    1/1     Running   0          26s    10.233.69.68   worker01   <none>           <none>
    frontend-75fd5rt795-zv25b    1/1     Running   0          26s    10.233.69.105  worker01   <none>           <none>
    multitool-5dr7664c8b-o9rt5   1/1     Running   0          108m   10.233.69.5    worker01   <none>           <none>
    postgres-db-0                1/1     Running   0          126m   10.233.90.98   worker02   <none>           <none>


    root@controlnode:~$ kubectl scale --replicas=1 deployment backend
    deployment.apps/backend scaled


    root@controlnode:~$ kubectl patch deployment frontend -p '{"spec":{"replicas":1}}' --type=merge
    deployment.apps/frontend patched


    root@controlnode:~$ kubectl get po -o wide
    NAME                         READY   STATUS    RESTARTS   AGE    IP             NODE       NOMINATED NODE   READINESS GATES
    backend-7hgbc855fc-c7by8     1/1     Running   0          30m    10.233.69.14   worker01   <none>           <none>    
    frontend-75fd5rt795-h5df6    1/1     Running   0          127m   10.233.90.11   worker02   <none>           <none>    
    multitool-5dr7664c8b-o9rt5   1/1     Running   0          110m   10.233.69.5    worker01   <none>           <none>
    postgres-db-0                1/1     Running   0          128m   10.233.90.98   worker02   <none>           <none>

```
