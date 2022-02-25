# Результаты домашнего задания "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

---

```bash

vagrant@vagrant:~$ sudo docker run --name mysql -v /home/db/mysql:/var/lib/mysql -v /home/db/backup_mysql:/home/backup -e MYSQL_ROOT_PASSWORD=123456 -d mysql:8

vagrant@vagrant:~$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                 NAMES
553505dd27d2   mysql:8   "docker-entrypoint.s…"   6 minutes ago   Up 6 minutes   3306/tcp, 33060/tcp   mysql

vagrant@vagrant:~$ sudo docker exec -it mysql bash

mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

mysql> use test_db;
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)

mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
  - Фамилия "Pretty"
  - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

---

```bash

# CREATE USER 'test'@'localhost'
#   IDENTIFIED WITH mysql_native_password BY 'test-pass'
#   WITH MAX_QUERIES_PER_HOUR 100
#   PASSWORD EXPIRE INTERVAL 180 DAY
#   FAILED_LOGIN_ATTEMPTS 3
#   ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
 
# GRANT SELECT ON test_db.* TO 'test'@'localhost';

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:

- на `MyISAM`
- на `InnoDB`

---

```bash

mysql> select table_schema, table_name, engine from information_schema.tables where table_schema='test_db';
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.00 sec)


mysql> alter table orders engine=MyISAM;
mysql> alter table orders engine=InnoDb;
mysql> show profiles;
+----------+------------+-----------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                               |
+----------+------------+-----------------------------------------------------------------------------------------------------+
|       17 | 0.01064200 | alter table orders engine=MyISAM                                                                    |
|       22 | 0.02207550 | alter table orders engine=InnoDb                                                                    |
+----------+------------+-----------------------------------------------------------------------------------------------------+
15 rows in set, 1 warning (0.00 sec)

```

## Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---

```bash

[mysqld]
innodb_buffer_pool_size = 1288490188
innodb_log_file_size = 104857600
innodb_log_buffer_size = 1048576
innodb_file_per_table = ON
innodb_flush_log_at_trx_commit = 2

```
