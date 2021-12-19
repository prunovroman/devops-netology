# Результаты домашнего задания к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:

``` python
#!/usr/bin/env python3

a = 1
b = '2'
c = a + b

```

### Вопросы

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Будет  выведена ошибка  `unsupported operand type(s) for +: 'int' and 'str'` |
| Как получить для переменной `c` значение 12?  | `c = str(a) + b`  |
| Как получить для переменной `c` значение 3?  | `c = a + int(b)`  |

## Обязательная задача 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

``` python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт

```python
# Использовал свое локальное хранилище

import os

bash_command = ["cd /Projects/devops-netology/", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('modified:', '').strip().replace('../','')
        prepare_result = os.path.join(os.path.abspath(bash_command[0][3:]), prepare_result)
        prepare_result = os.path.normpath(prepare_result)
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании

``` terminal

D:\Projects\devops-netology>python test1.py                          
D:\Projects\devops-netology\.gitignore
D:\Projects\devops-netology\README.md
D:\Projects\devops-netology\branching\merge.sh
D:\Projects\devops-netology\branching\rebase.sh
D:\Projects\devops-netology\has_been_moved.txt
D:\Projects\devops-netology\vagrant\3.1\README.md
D:\Projects\devops-netology\vagrant\3.3\README.md
D:\Projects\devops-netology\vagrant\3.5\README.md
D:\Projects\devops-netology\vagrant\3.9\README.md

```

## Обязательная задача 3

1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт

```python
import os
import sys

if len(sys.argv) == 1:
    print('Отсутствует путь к репозитарию')
    exit(1)

bash_command = [f"cd {sys.argv[1]}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('modified:', '').strip().replace('../','')
        prepare_result = os.path.join(os.path.abspath(bash_command[0][3:]), prepare_result)
        prepare_result = os.path.normpath(prepare_result)
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании

```terminal
D:\Projects\devops-netology>python test.py /Projects/testvm
D:\Projects\testvm\Vagrantfile
D:\Projects\testvm\data\test.txt
D:\Projects\testvm\test.txt

----------------------------

D:\Projects\devops-netology>python test.py /Projects/devops-netology/
D:\Projects\devops-netology\.gitignore
D:\Projects\devops-netology\README.md
D:\Projects\devops-netology\branching\merge.sh
D:\Projects\devops-netology\branching\rebase.sh
D:\Projects\devops-netology\has_been_moved.txt
D:\Projects\devops-netology\vagrant\3.1\README.md
D:\Projects\devops-netology\vagrant\3.3\README.md
D:\Projects\devops-netology\vagrant\3.5\README.md
D:\Projects\devops-netology\vagrant\3.9\README.md

```

## Обязательная задача 4

1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт

```python

import socket
import time

dict_hosts = {'drive.google.com':'', 'mail.google.com':'', 'google.com':''}

while True:
    for host, ip in dict_hosts.items():
        new_ip = socket.gethostbyname(host)
        if ip == '' or ip == new_ip:
            dict_hosts[host] = new_ip
            print(f'{host} - {new_ip}')
        elif ip != new_ip:
            print(f'[ERROR] {host} IP mismatch: {ip} {new_ip}')            

    time.sleep(5)

```

### Вывод скрипта при запуске при тестировании

```terminal

D:\Projects\devops-netology>test_socket.py
drive.google.com - 64.233.165.194
mail.google.com - 108.177.14.19
google.com - 173.194.222.100
drive.google.com - 64.233.165.194
mail.google.com - 108.177.14.19
google.com - 173.194.222.100
drive.google.com - 64.233.165.194
mail.google.com - 108.177.14.19
google.com - 173.194.222.100
[ERROR] drive.google.com IP mismatch: 64.233.165.194 64.233.163.194
[ERROR] mail.google.com IP mismatch: 108.177.14.19 216.58.208.197
[ERROR] google.com IP mismatch: 173.194.222.100 216.58.215.78

```
