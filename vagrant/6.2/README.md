# Результаты домашнего задания "6.2. SQL"

## Введение

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

---

```bash
vagrant@vagrant:/home$ sudo docker run -d --name postgres -v /home/db/pgdata:/var/lib/postgresql/data -v /home/db/backup:/db/backup -e POSTGRES_PASSWORD=postgres postgres:12
d347b7799f30447347a64aae00e8382252dbe7e052db050fa3736d748668fb3f

vagrant@vagrant:/home$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS      NAMES
d347b7799f30   postgres:12   "docker-entrypoint.s…"   4 seconds ago   Up 4 seconds   5432/tcp   postgres

vagrant@vagrant:/home$ sudo docker exec -it postgres bash

root@d347b7799f30:/# psql -V
psql (PostgreSQL) 12.10 (Debian 12.10-1.pgdg110+1)
```

## Задача 2

В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:

- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:

- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

---

```bash

test_db=# \l
                                           List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |          Access privileges
-----------+-----------------+----------+------------+------------+-------------------------------------
 postgres  | postgres        | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                        +
           |                 |          |            |            | postgres=CTc/postgres
 template1 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                        +
           |                 |          |            |            | postgres=CTc/postgres
 test_db   | test_admin_user | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/test_admin_user                +
           |                 |          |            |            | test_admin_user=CTc/test_admin_user
(4 rows)


test_db=# \d
               List of relations
 Schema |      Name      |   Type   |  Owner
--------+----------------+----------+----------
 public | clients        | table    | postgres
 public | clients_id_seq | sequence | postgres
 public | orders         | table    | postgres
 public | orders_id_seq  | sequence | postgres
(4 rows)


test_db=# \d orders
                            Table "public.orders"
 Column |  Type   | Collation | Nullable |              Default
--------+---------+-----------+----------+------------------------------------
 id     | integer |           | not null | nextval('orders_id_seq'::regclass)
 title  | text    |           |          |
 cost   | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)


test_db=# \d clients
                             Table "public.clients"
  Column  |  Type   | Collation | Nullable |               Default
----------+---------+-----------+----------+-------------------------------------
 id       | integer |           | not null | nextval('clients_id_seq'::regclass)
 lastname | text    |           |          |
 country  | text    |           |          |
 order_id | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_idx" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)


test_db=# SELECT * FROM information_schema.table_privileges where table_catalog='test_db' and grantee='test_admin_user' or grantee='test_simple_user';
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_admin_user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | DELETE         | NO           | NO
(22 rows)

```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы
- приведите в ответе:
  - запросы
  - результаты их выполнения.

---

```bash

INSERT INTO orders VALUES (1, 'Шоколад', 10);
INSERT INTO orders VALUES (2, 'Принтер', 3000);
INSERT INTO orders VALUES (3, 'Книга', 500);
INSERT INTO orders VALUES (4, 'Монитор', 7000);
INSERT INTO orders VALUES (5, 'Гитара', 4000);

test_db=# select * from orders;
 id |  title  | cost
----+---------+------
  1 | Шоколад |   10
  2 | Принтер | 3000
  3 | Книга   |  500
  4 | Монитор | 7000
  5 | Гитара  | 4000
(5 rows)


INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA');
INSERT INTO clients VALUES (2, 'Петров Петр Петрович', 'Canada');
INSERT INTO clients VALUES (3, 'Иоганн Себастьян Бах', 'Japan');
INSERT INTO clients VALUES (4, 'Ронни Джеймс Дио', 'Russia');
INSERT INTO clients VALUES (5, 'Ritchie Blackmore', 'Russia');

test_db=# select * from clients;
 id |       lastname       | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)


test_db=# select count(*) from orders;
 count
-------
     5
(1 row)

test_db=# select count(*) from clients;
 count
-------
     5
(1 row)

```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказк - используйте директиву `UPDATE`.

---

```bash
update clients set order_id=3 where id=1;
update clients set order_id=4 where id=2;
update clients set order_id=5 where id=3;

test_db=# select * from clients;
 id |       lastname       | country | order_id
----+----------------------+---------+----------
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(5 rows)


test_db=# SELECT cl.id, cl.lastname, cl.country, o.title, o.cost FROM clients cl INNER JOIN orders o ON cl.order_id=o.id;
 id |       lastname       | country |  title  | cost
----+----------------------+---------+---------+------
  1 | Иванов Иван Иванович | USA     | Книга   |  500
  2 | Петров Петр Петрович | Canada  | Монитор | 7000
  3 | Иоганн Себастьян Бах | Japan   | Гитара  | 4000
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

---

```bash
test_db=# EXPLAIN ANALYZE SELECT cl.id, cl.lastname, cl.country, o.title, o.cost FROM clients cl INNER JOIN orders o ON cl.order_id=o.id;
                                                    QUERY PLAN
-------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=104) (actual time=0.040..0.043 rows=3 loops=1)
   Hash Cond: (cl.order_id = o.id)
   ->  Seq Scan on clients cl  (cost=0.00..18.10 rows=810 width=72) (actual time=0.007..0.008 rows=5 loops=1)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=40) (actual time=0.027..0.027 rows=5 loops=1)
         Buckets: 2048  Batches: 1  Memory Usage: 17kB
         ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=40) (actual time=0.003..0.005 rows=5 loops=1)
 Planning Time: 0.092 ms
 Execution Time: 0.060 ms
(8 rows)
```

1. Самая верхняя строка (узел) показывает совокупную стоимость и фактическое время для всего оператора Объединения.  
coast=37.00..57.24 - первое число это затраты на получение первой записи, второе - затраты на обработку всего узла.  
rows=810 width=104 - оценка того сколько строк может вернуть postgres.
actual time=0.040..0.043 - это время запуска (время для извлечения первой записи), а второе число — это время, необходимое для обработки всего узла (общее время от начала до конца) в миллисекундах.
2. Выполняется хэш условие - cl.order_id = o.id
3. Выполняется последовательный перебор строк таблицы Seq Scan on clients cl
4. Выполняется последовательный перебор строк таблицы Seq Scan on orders o
5. Planning Time - планируемое время на выполнение запроса
6. Execution Time - фактическое время потраченное на выполнение запроса

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

---

```bash
# Создание резервной копии
root@d347b7799f30:/# pg_basebackup -U postgres -h 127.0.0.1 -D home/db/backup/

vagrant@vagrant:/home$ sudo docker run -d --name postgres_backup -v /home/db/backup:/var/lib/postgresql/data -e POSTGRES_PASSWORD=postgres postgres:12

vagrant@vagrant:/home$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS      NAMES
c4a131a698c3   postgres:12   "docker-entrypoint.s…"   12 minutes ago   Up 12 minutes   5432/tcp   postgres_backup

vagrant@vagrant:/home$ sudo docker exec -it postgres_backup bash

root@c4a131a698c3:/# psql -U postgres
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                           List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |          Access privileges
-----------+-----------------+----------+------------+------------+-------------------------------------
 postgres  | postgres        | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                        +
           |                 |          |            |            | postgres=CTc/postgres
 template1 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                        +
           |                 |          |            |            | postgres=CTc/postgres
 test_db   | test_admin_user | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/test_admin_user                +
           |                 |          |            |            | test_admin_user=CTc/test_admin_user
(4 rows)

postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)


test_db=# \d clients
                             Table "public.clients"
  Column  |  Type   | Collation | Nullable |               Default
----------+---------+-----------+----------+-------------------------------------
 id       | integer |           | not null | nextval('clients_id_seq'::regclass)
 lastname | text    |           |          |
 country  | text    |           |          |
 order_id | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_idx" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)


test_db=# \d orders
                            Table "public.orders"
 Column |  Type   | Collation | Nullable |              Default
--------+---------+-----------+----------+------------------------------------
 id     | integer |           | not null | nextval('orders_id_seq'::regclass)
 title  | text    |           |          |
 cost   | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)

```
