# Результаты домашнего задания "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:

- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и [документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:

- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:

- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

---

Ссылка на созданный форк в моем репозитории <https://hub.docker.com/r/romanprunov/elasticsearch>

```dockerfile

FROM centos:7

LABEL author="Roman Prunov"
LABEL description="Base image Centos 7 with Elasticsearch 7.x"
    
ENV PATH=$PATH:/usr/share/elasticsearch/bin

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch && \
    touch /etc/yum.repos.d/elasticsearch.repo && \
    echo '[elasticsearch]' >> /etc/yum.repos.d/elasticsearch.repo && \
    echo 'name=Elasticsearch repository for 7.x packages' >> /etc/yum.repos.d/elasticsearch.repo && \
    echo 'baseurl=https://artifacts.elastic.co/packages/7.x/yum' >> /etc/yum.repos.d/elasticsearch.repo && \
    echo 'gpgcheck=1' >> /etc/yum.repos.d/elasticsearch.repo && \
    echo 'gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch' >> /etc/yum.repos.d/elasticsearch.repo && \
    echo 'enabled=0' >> /etc/yum.repos.d/elasticsearch.repo && \
    echo 'autorefresh=1' >> /etc/yum.repos.d/elasticsearch.repo && \
    echo 'type=rpm-md' >> /etc/yum.repos.d/elasticsearch.repo

RUN yum install -y --enablerepo=elasticsearch elasticsearch && \
    mkdir /usr/share/elasticsearch/snapshots && \
    chown elasticsearch:elasticsearch /usr/share/elasticsearch/snapshots && \
    mkdir /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/logs && \
    mkdir /var/lib/data && \
    chown elasticsearch:elasticsearch /var/lib/data

COPY elasticsearch.yml /etc/elasticsearch/

WORKDIR /usr/share/elasticsearch
    
USER elasticsearch

CMD ["elasticsearch"]

EXPOSE 9200 9300

```

```bash

vagrant@vagrant:/home/els$ sudo docker run --rm --name els -p 9200:9200 -d romanprunov/elasticsearch:7
vagrant@vagrant:/home/els$ curl localhost:9200
{
  "name" : "3165e9e29912",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "-G1oKagyR3yOq76wBx52YQ",
  "version" : {
    "number" : "7.17.1",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "e5acb99f822233d62d6444ce45a4543dc1c8059a",
    "build_date" : "2022-02-23T22:20:54.153567231Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

```

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

---

Создание индексов:

```bash
vagrant@vagrant:/home/els$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
vagrant@vagrant:/home/els$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
vagrant@vagrant:/home/els$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'    
```

Список индексов:

```bash

vagrant@vagrant:/home/els$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases fQlV8VBmTSG-7qrC1Ro1kQ   1   0         41            0     39.5mb         39.5mb
green  open   ind-1            KMCHxmnATg66uL2reWDs1g   1   0          0            0       226b           226b
yellow open   ind-3            qtTzNoPwQNuqrJ7QUJYgCw   4   2          0            0       904b           904b
yellow open   ind-2            oO3iLA-fS5-wP3l_JhYfeQ   2   1          0            0       452b           452b

```

Статус индексов:

```bash

vagrant@vagrant:/home/els$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

vagrant@vagrant:/home/els$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

vagrant@vagrant:/home/els$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

```

Статус кластера:

```bash

vagrant@vagrant:/home/els$ curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

```

Удаление индексов:

```bash

vagrant@vagrant:/home/els$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}

vagrant@vagrant:/home/els$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}

vagrant@vagrant:/home/els$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}

```

Индексы в статусе Yellow потому что у них указано число реплик, а по факту нет других серверов, соответсвено реплицировать некуда. 

## Задача 3

В данном задании вы научитесь:

- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

```bash

vagrant@vagrant:/home/els$ curl -X POST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/usr/share/elasticsearch/snapshots" }}'
{
  "acknowledged" : true
}

vagrant@vagrant:/home/els$ curl localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/usr/share/elasticsearch/snapshots"
    }
  }
}

```

```bash

vagrant@vagrant:/home/els$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases fQlV8VBmTSG-7qrC1Ro1kQ   1   0         41            0     39.5mb         39.5mb
green  open   test             W17PS6v7RqGZNLcIoE9I1Q   1   0          0            0       226b           226b

vagrant@vagrant:/home/els$ curl localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1646471672769",
        "number_of_replicas" : "0",
        "uuid" : "W17PS6v7RqGZNLcIoE9I1Q",
        "version" : {
          "created" : "7170199"
        }
      }
    }
  }
}

```

```bash

vagrant@vagrant:/home/els$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true

bash-4.2$ cd snapshots/
bash-4.2$ pwd
/usr/share/elasticsearch/snapshots
bash-4.2$ ls -l
total 48
-rw-r--r-- 1 elasticsearch elasticsearch  1425 Mar  5 09:17 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar  5 09:17 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 Mar  5 09:17 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29282 Mar  5 09:17 meta-or2gdCP0RnCLbAc6aE84eg.dat
-rw-r--r-- 1 elasticsearch elasticsearch   712 Mar  5 09:17 snap-or2gdCP0RnCLbAc6aE84eg.dat

```

```bash

vagrant@vagrant:/home/els$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}

vagrant@vagrant:/home/els$ curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

vagrant@vagrant:/home/els$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2           UwjXBWPqQcSQ7kl-sRrtUw   1   0          0            0       226b           226b
green  open   .geoip_databases fQlV8VBmTSG-7qrC1Ro1kQ   1   0         41            0     39.5mb         39.5mb

vagrant@vagrant:/home/els$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'

vagrant@vagrant:/home/els$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2           UwjXBWPqQcSQ7kl-sRrtUw   1   0          0            0       226b           226b
green  open   test             HzFsM8gwT1WPFxzDLl0Uew   1   0          0            0       226b           226b
green  open   .geoip_databases fQlV8VBmTSG-7qrC1Ro1kQ   1   0         41            0     39.5mb         39.5mb

```
