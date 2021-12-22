# Результаты домашнего задания к занятию "4.3. Языки разметки JSON и YAML"

## Обязательная задача 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```json

    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }

```

Нужно найти и исправить все ошибки, которые допускает наш сервис

```json

    {
        "info": "Sample JSON output from our service\t",
        "elements": [
            { 
                "name": "first",
                "type": "server",
                "ip": "7175"
            },
            { 
                "name": "second",
                "type": "proxy",
                "ip": "71.78.22.43"
            }
        ]
    }

```

## Обязательная задача 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт

```python

import socket
import time
import json
import yaml

dict_hosts = [{'drive.google.com': ''}, {'mail.google.com': ''}, {'google.com': ''}]

while True:
    for sk in dict_hosts:             
        for host, ip in sk.items():
            new_ip = socket.gethostbyname(host)

            if ip == '' or ip == new_ip:
                sk[host] = new_ip
                print(f'{host} - {new_ip}')
            elif ip != new_ip:
                print(f'[ERROR] {host} IP mismatch: {ip} {new_ip}')

    with open("hosts.json", "w") as js:
        json.dump(dict_hosts, js, indent=2)

    with open("hosts.yaml", "w") as yml:
        yaml.dump(dict_hosts, yml)

    time.sleep(5)
        
```

### Вывод скрипта при запуске при тестировании

``` terminal
drive.google.com - 173.194.73.138
mail.google.com - 173.194.73.83
google.com - 64.233.163.100
drive.google.com - 173.194.73.138
mail.google.com - 173.194.73.83
google.com - 64.233.163.100
```

### json-файл(ы), который(е) записал ваш скрипт

```json
[
  {
    "drive.google.com": "173.194.73.138"
  },
  {
    "mail.google.com": "173.194.73.83"
  },
  {
    "google.com": "64.233.163.100"
  }
]
```

### yml-файл(ы), который(е) записал ваш скрипт

```yaml
- drive.google.com: 173.194.73.138
- mail.google.com: 173.194.73.83
- google.com: 64.233.163.100
```
