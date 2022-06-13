# Результаты домашнего задания "8.4 Создание собственных modules"

## Подготовка к выполнению

- [x] Создайте пустой публичных репозиторий в любом своём проекте: `my_own_collection`
- [x] Скачайте репозиторий ansible: `git clone https://github.com/ansible/ansible.git` по любому удобному вам пути
- [x] Зайдите в директорию ansible: `cd ansible`
- [x] Создайте виртуальное окружение: `python3 -m venv venv`
- [x] Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении
- [x] Установите зависимости `pip install -r requirements.txt`
- [x] Запустить настройку окружения `. hacking/env-setup`
- [x] Если все шаги прошли успешно - выйти из виртуального окружения `deactivate`
- [x] Ваше окружение настроено, для того чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`

## Основная часть

Наша цель - написать собственный module, который мы можем использовать в своей role, через playbook. Всё это должно быть собрано в виде collection и отправлено в наш репозиторий.

1. В виртуальном окружении создать новый `my_own_module.py` файл
2. Наполнить его содержимым из [статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).
3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.
4. Проверьте module на исполняемость локально.
5. Напишите single task playbook и используйте module в нём.
6. Проверьте через playbook на идемпотентность.
7. Выйдите из виртуального окружения.

---

<details><summary>Код модуля</summary>

```python

#!/usr/bin/python

# Copyright: (c) 2022, Roman Prunov <prunovroman@gmail.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
import os
from ansible.module_utils.basic import AnsibleModule
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_own_module

short_description: This is module create text file on remote host

version_added: "1.0.0"

description: This is module create text file on remote host

options:
    path:
        description: This is path to file on remote host.
        required: true
        type: str
    content:
        description: This is content for file on remote host.
        required: true
        type: str

author:
    - Roman Prunov (@prunovr)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test_info:
    path: '/tmp/test_file.txt'
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message='',
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    if os.path.exists(module.params['path']):
        result['changed'] = False
        result['message'] = 'File already exist'
    else:
        with open(module.params['path'], 'w') as fContent:
            fContent.write(module.params['content'])
            result['changed'] = True
            result['message'] = f"File {module.params['path']} created."
            result['original_message'] = module.params['content']

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()


```

</details>

<details><summary>Локальная проверка кода модуля</summary>

```bash

(venv) vagrant@vagrant:~/ansible$ python -m ansible.modules.my_own_module /tmp/args.json

{"changed": false, "original_message": "", "message": "File already exist", "invocation": {"module_args": {"path": "/tmp/test.txt", "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et."}}}

```

</details>

---

8. Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`
9. В данную collection перенесите свой module в соответствующую директорию.
10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module
11. Создайте playbook для использования этой role.
12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.
13. Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.
14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
15. Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`
16. Запустите playbook, убедитесь, что он работает.
17. В ответ необходимо прислать ссылку на репозиторий с collection

---

> Ссылка на репозиторий <https://github.com/prunovr/CollectionAnsible/tree/1.0.0>
