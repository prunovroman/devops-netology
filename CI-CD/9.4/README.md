# Результаты домашнего задания "9.4 Jenkins"

## Подготовка к выполнению

- :white_check_mark: Создать 2 VM: для jenkins-master и jenkins-agent.
- :white_check_mark: Установить jenkins при помощи playbook'a.
- :white_check_mark: Запустить и проверить работоспособность.
- :white_check_mark: Сделать первоначальную настройку.

## Основная часть

- :white_check_mark: Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
- :white_check_mark: Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
- :white_check_mark: Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
- :white_check_mark: Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
- :white_check_mark: Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
- :white_check_mark: Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
- :white_check_mark: Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
- :white_check_mark: Отправить две ссылки на репозитории в ответе: с ролью и Declarative Pipeline и c плейбукой и Scripted Pipeline.
    > Ссылка на [Declarative Pipeline](https://github.com/prunovr/vector-role/blob/master/Jenkinsfile) с ролью.  
    > Ссылка на [Scripted Pipeline](https://github.com/prunovr/devops-netology/blob/main/ansible/playbooks/ScriptedJenkinsfile) с плейбукой.
