# Результаты домашнего задания "8.4 Работа с Roles"

## Подготовка к выполнению

1. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
    > Создал два репозитария `/vector-role` и `lighthouse-role`
2. Добавьте публичную часть своего ключа к своему профилю в github.
    > Добавил `ssh` ключ к своему профилю

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

    > Создал и заполнил файл `requirements.yml`

2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`.
5. Перенести нужные шаблоны конфигов в `templates`.
6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.

    > **Выполнил шаги со 2 по 8**  
    > Ссылка на роль Vector <https://github.com/prunovr/vector-role>  
    > Ссылка на роль Lighouse <https://github.com/prunovr/lighthouse-role>  
    > Содержание файла `requirements.yml`:

    ```yaml
    
    - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
      scm: git
      version: "1.11.0"
      name: clickhouse

    - src: git@github.com:prunovr/lighthouse-role.git
      scm: git
      version: "1.0.0"
      name: lighthouse

    - src: git@github.com:prunovr/vector-role.git
      scm: git
      version: "1.0.0"
      name: vector
    ```

9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.

    > Содержимое файла `site.yml`:

    ```yaml
    - name: Install Clikhouse
      hosts: clickhouse
      roles:
        - role: clickhouse
          tags: clickhouse

    - name: Install Vector
      hosts: vector
      roles:
        - role: vector
          tags: vector

    - name: Install Lighthouse
      hosts: lighthouse
      roles:
        - role: lighthouse
          tags: lighthouse
    ```

10. Выложите playbook в репозиторий.
    > Выложил свой playbook в репозиторий <https://github.com/prunovr/devops-netology/tree/08-ansible-04-role/ansible/playbooks>
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.
    > Ссылки на репозиторий с ролями приложены
