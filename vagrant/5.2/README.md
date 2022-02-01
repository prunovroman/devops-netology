
# Результаты домашнего задания к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

---

- Например вместо того, чтобы запускать сотню различных файлов конфигурации, паттерн IaaC позволяет нам просто запускать скрипт, который, например каждое  утро поднимает тысячу дополнительных машин, а вечером автоматически сокращает инфраструктуру до приемлемого вечернего масштаба.
- идемпотентность.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

---

- В том, что `Ansible` использует существующую SSH инфраструктуру.
- По мне так, режим `push` является лучшем вариантам, т.к. мастер-сервер сам раскидывает конфигурацию по всей системе.

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

---

```bash
    C:\Program Files\Oracle\VirtualBox>VBoxManage -v
    6.1.30r148432

    C:\Users\pruno>vagrant --version
    Vagrant 2.2.19

    prunov@PRK_PC ~
    $ ansible --version
    ansible 2.8.4
    config file = /etc/ansible/ansible.cfg
    configured module search path = ['/home/prunov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
    ansible python module location = /usr/lib/python3.7/site-packages/ansible
    executable location = /usr/bin/ansible
    python version = 3.7.12 (default, Nov 23 2021, 18:58:07) [GCC 11.2.0]

```
