# Результаты домашнего задания "08.01 Введение в Ansible"

## Подготовка к выполнению

1. Установите ansible версии 2.10 или выше.

    - ```bash

        vagrant@vagrant:~$ ansible --version
        ansible [core 2.12.4]
        config file = /etc/ansible/ansible.cfg
        configured module search path = ['/home/vagrant/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
        ansible python module location = /home/vagrant/.local/lib/python3.8/site-packages/ansible
        ansible collection location = /home/vagrant/.ansible/collections:/usr/share/ansible/collections
        executable location = /usr/bin/ansible
        python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
        jinja version = 2.10.1
        libyaml = True

      ```

2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
    - <https://github.com/prunovr/devops-netology/tree/main/ansible/playbooks>
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
    - <https://github.com/prunovr/devops-netology/tree/main/ansible/playbooks/8.1>

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
    - `"msg": 12`
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
    - `group_vars/all/exampl.yml`
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

    - ```bash

        vagrant@vagrant:~/8.1$ sudo docker ps
        CONTAINER ID   IMAGE          COMMAND       CREATED         STATUS          PORTS     NAMES
        ea37c7f0700b   ubuntu:20.04   "bash"        5 minutes ago   Up 21 seconds             ubuntu
        6a44e510df04   centos:7       "/bin/bash"   5 minutes ago   Up 5 minutes              centos7

      ```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

    - ```bash

        TASK [Print fact] ******************************************************************************************************
        ok: [centos7] => {
            "msg": "el"
        }
        ok: [ubuntu] => {
            "msg": "deb"
        }

      ```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

    - ```bash

            TASK [Print fact] ******************************************************************************************************
            ok: [ubuntu] => {
                "msg": "deb default fact"
            }
            ok: [centos7] => {
                "msg": "el default fact"
            }

        ```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

    - ```bash

        vagrant@vagrant:~/8.1$ sudo cat group_vars/deb/exampl.yml
        $ANSIBLE_VAULT;1.1;AES256
        64366435303664616566356237383464633966653164653861303438396634343937636637376139
        3662643161343465353961343337343061326134376165350a326665616638633264666464393132
        66666565303838316230323432353262356434386139666338383333346134383430313064373461
        6337336435626166350a336636346635373963383537336636346533353364663035666166636266
        34613966636233316561373030316362383131376564633530343938646434373030


        vagrant@vagrant:~/8.1$ sudo cat group_vars/el/exampl.yml
        $ANSIBLE_VAULT;1.1;AES256
        35643333313436313165653564353762616561353435633135653233326565333337306237656566
        3935376365366166623933363663323531623434383066310a366662303662643134383636626439
        34373465353836386134323561356230663266366635373332656431343764386335336135343435
        3962303431343237340a336235343332643030643032653331323337313761363434613763346134
        38613665346134303439616134373636333937643364393161356334616634653262

      ```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

    - ```bash

        vagrant@vagrant:~/8.1$ sudo ansible-playbook --ask-vault-password site.yml -i inventory/prod.yml
        Vault password:

        PLAY [Print os facts] *************************************************************************************************

        TASK [Gathering Facts] ************************************************************************************************
        ok: [ubuntu]
        ok: [centos7]

        TASK [Print OS] ******************************************************************************************************
        ok: [centos7] => {
            "msg": "CentOS"
        }
        ok: [ubuntu] => {
            "msg": "Ubuntu"
        }

        TASK [Print fact] *****************************************************************************************************
        ok: [centos7] => {
            "msg": "el default fact"
        }
        ok: [ubuntu] => {
            "msg": "deb default fact"
        }

        PLAY RECAP ***********************************************************************************************************
        centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    escued=0    ignored=0
        ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    escued=0    ignored=0

      ```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

    - ```bash

        vagrant@vagrant:~/8.1$ ansible-doc -t connection -l
        local                          execute on controller

      ```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

    - ```YAML

        local:
            hosts:
                localhost:
                ansible_connection: local

      ```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

    - ```bash

        vagrant@vagrant:~/8.1$ sudo ansible-playbook --ask-vault-password site.yml -i inventory/prod.yml
        Vault password:

        PLAY [Print os facts] **********************************************************************************************************************************************************************

        TASK [Gathering Facts] *********************************************************************************************************************************************************************
        ok: [localhost]
        ok: [ubuntu]
        ok: [centos7]

        TASK [Print OS] ****************************************************************************************************************************************************************************
        ok: [localhost] => {
            "msg": "Ubuntu"
        }
        ok: [centos7] => {
            "msg": "CentOS"
        }
        ok: [ubuntu] => {
            "msg": "Ubuntu"
        }

        TASK [Print fact] **************************************************************************************************************************************************************************
        ok: [localhost] => {
            "msg": "all default fact"
        }
        ok: [centos7] => {
            "msg": "el default fact"
        }
        ok: [ubuntu] => {
            "msg": "deb default fact"
        }

        PLAY RECAP *********************************************************************************************************************************************************************************
        centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
        localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
        ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

      ```
