# Результаты домашнего задания "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на <https://hub.docker.com>;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

```html

<html>
    <head>
        Hey, Netology
    </head>
    <body>
        <h1>I’m DevOps Engineer!</h1>
    </body>
</html>
```

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на <https://hub.docker.com/username_repo>.

---

Ссылка на созданный форк в моем репозитории <https://hub.docker.com/r/romanprunov/nginx_netology>

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;  
  `- Если архитектура это позволяет - то контейнеры будут удобней виртуальных машин, т.к. они ,быстрей разворачиваются, менее требовательны к месту и прочим ресурсам.`
- Nodejs веб-приложение;  
  `- В данном случае Docker подойдёт лучше, т.к. это позволит быстро развернуть приложение со всеми необходимыми библиотеками.`
- Мобильное приложение c версиями для Android и iOS;  
  `- В данном варианте мне кажется лучше всего использовать или физическую машину, или виртуальную.`
- Шина данных на базе Apache Kafka;  
  `- Здесь лучше использовать Docker, если вдруг с одним из сервисов что-то произойдет можно быстро вернуть как было, т.е. откатиться.`
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;  
  `- Docker подойдёт лучше, опять таки ввиду того, что его можно быстро развернуть.`
- Мониторинг-стек на базе Prometheus и Grafana;  
  `- Prometheus и Grafana можно использовать в Докере.`
- MongoDB, как основное хранилище данных для java-приложения;  
  `- Вполне подойдёт Docker, у MongoDB даже есть официальный образ на Docker Hub.`
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.  
  `- В данном варианте думаю удобней будет использовать либо виртуальную машину, либо физическую.`

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

---

```bash
vagrant@vagrant:~$ sudo docker run -it -v $HOME/data/:/tmp/data --name centos -d centos
cf094a8bb12a245fcbc036c04d23a85bb1d9fdd589176f8f6b880dbeaebc70f3
```

```bash
vagrant@vagrant:~/data$ sudo docker run -it -v $HOME/data:/tmp/data --name debian -d debian
4628ff2af211edc1f218ef788d891d025584aa1eba76954a76fc448a61cfc8dc
```

```bash
vagrant@vagrant:~/data$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
4628ff2af211   debian    "bash"        5 seconds ago    Up 5 seconds              busy_solomon
cf094a8bb12a   centos    "/bin/bash"   15 minutes ago   Up 15 minutes             centos
```

```bash
vagrant@vagrant:~/data$ sudo docker exec -it -w /tmp/data centos bash
[root@cf094a8bb12a data]# touch data.txt
[root@cf094a8bb12a data]# vi data.txt
[root@cf094a8bb12a data]# cat data.txt
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at varius quam, ut porta augue. Nulla gravida, dolor et euismod lacinia, urna ligula varius quam, non rhoncus arcu nulla id massa. Cras dui nibh, rutrum eget semper vel, ullamcorper in diam. Maecenas luctus quis urna ac porttitor. Nam varius tincidunt velit at condimentum. Pellentesque egestas quam dolor, id semper lectus faucibus a. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum pharetra dapibus varius. Donec ante risus, fermentum eget mattis ultrices, bibendum eget lorem. Quisque lobortis ex nisi, at rutrum urna rhoncus at. Nullam a condimentum ante.
```

```bash
vagrant@vagrant:~/data$ sudo nano data_host.txt
```

```bash
vagrant@vagrant:~/data$ sudo docker exec -it -w /tmp/data debian bash
root@4628ff2af211:/tmp/data# ls -l
total 8
-rw-r--r-- 1 root root 647 Feb  1 13:10 data.txt
-rw-r--r-- 1 root root  57 Feb  1 14:29 data_host.txt

root@4628ff2af211:/tmp/data# cat data.txt
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at varius quam, ut porta augue. Nulla gravida, dolor et euismod lacinia, urna ligula varius quam, non rhoncus arcu nulla id massa. Cras dui nibh, rutrum eget semper vel, ullamcorper in diam. Maecenas luctus quis urna ac porttitor. Nam varius tincidunt velit at condimentum. Pellentesque egestas quam dolor, id semper lectus faucibus a. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum pharetra dapibus varius. Donec ante risus, fermentum eget mattis ultrices, bibendum eget lorem. Quisque lobortis ex nisi, at rutrum urna rhoncus at. Nullam a condimentum ante.

root@4628ff2af211:/tmp/data# cat data_host.txt
One morning, when Gregor Samsa woke from troubled dreams
```
