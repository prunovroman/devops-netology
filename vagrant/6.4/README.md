# Результаты домашнего задания "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

---

```bash
vagrant@vagrant:~$ sudo docker run --name postgres -v /home/db/data/pgdata:/var/lib/postgresql/data -v /home/db/backup/:/home/backup -e POSTGRES_PASSWORD=123456 -d postgres:13
c77df7fb4f1a31cac6aefa94f67f8f51870dec30c86bfbd2959cbcccf6ad72b4
vagrant@vagrant:~$ sudo docker exec -it postgres psql -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

```

- вывода списка БД - `\l[+]`
- подключения к БД - `\c`
- вывода списка таблиц - `\dt`
- вывода описания содержимого таблиц - `\d[+] [table_name]`
- выхода из psql - `\q`

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

---

```bash

vagrant@vagrant:~$ sudo docker run --name postgres -v /home/db/data/pgdata:/var/lib/postgresql/data -v /home/db/backup/:/home/backup -e POSTGRES_PASSWORD=123456 -d postgres:13
c77df7fb4f1a31cac6aefa94f67f8f51870dec30c86bfbd2959cbcccf6ad72b4
vagrant@vagrant:~$ sudo docker exec -it postgres bash

root@c77df7fb4f1a:/# psql -U postgres -c 'CREATE DATABASE test_database;'
root@c77df7fb4f1a:/# psql -U postgres test_database < /home/backup/test_database.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE

postgres=# \c test_database
test_database=# analyze verbose orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 9 live rows and 0 dead rows; 9 rows in sample, 9 estimated total rows
ANALYZE

test_database=# SELECT tablename, MAX(avg_width) max_avg_width FROM pg_stats WHERE tablename='orders' GROUP BY tablename;
 tablename | max_avg_width
-----------+---------------
 orders    |            15
(1 row)

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

---

```bash

test_database=# CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE

test_database=# CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
CREATE TABLE

test_database=# CREATE RULE orders_insert_to_1 AS ON INSERT TO orders WHERE (price > 499) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
CREATE RULE

test_database=# CREATE RULE orders_insert_to_2 AS ON INSERT TO orders WHERE (price <= 499) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
CREATE RULE


test_database=# insert into orders values (10, 'MySQL', 500);
INSERT 0 0
test_database=# insert into orders values (11, 'MySQL', 455);
INSERT 0 0
test_database=# select * from orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
  9 | Psql                 |   403
 10 | MySQL                |   500
 11 | MySQL                |   455
(11 rows)

test_database=# select * from orders_1;
 id | title | price
----+-------+-------
 10 | MySQL |   500
(1 row)

test_database=# select * from orders_2;
 id | title | price
----+-------+-------
 11 | MySQL |   455
(1 row)

test_database=# select * from only orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
  9 | Psql                 |   403
(9 rows)

```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

```bash

root@c77df7fb4f1a:/# pg_dump -U postgres test_database > /home/backup/test_database_1.sql

```

Добавил бы аттрибут `UNIQUE`:

```sql

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);

```
