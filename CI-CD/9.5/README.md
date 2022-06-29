# Результаты домашнего задания "9.5 Teamcity"

## Подготовка к выполнению

- :white_check_mark: В Ya.Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`
- :white_check_mark: Дождитесь запуска teamcity, выполните первоначальную настройку
- :white_check_mark: Создайте ещё один инстанс(2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`
- :white_check_mark: Авторизуйте агент
- :white_check_mark: Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity)
- :white_check_mark: Создать VM (2CPU4RAM) и запустить [playbook](./infrastracture)

## Основная часть

- :white_check_mark: Создайте новый проект в teamcity на основе fork
- :white_check_mark: Сделайте autodetect конфигурации
- :white_check_mark: Сохраните необходимые шаги, запустите первую сборку master'a
- :white_check_mark: Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`
- :white_check_mark: Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus
- :white_check_mark: В pom.xml необходимо поменять ссылки на репозиторий и nexus
- :white_check_mark: Запустите сборку по master, убедитесь что всё прошло успешно, артефакт появился в nexus
- :white_check_mark: Мигрируйте `build configuration` в репозиторий
- :white_check_mark: Создайте отдельную ветку `feature/add_reply` в репозитории
- :white_check_mark: Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`
- :white_check_mark: Дополните тест для нового метода на поиск слова `hunter` в новой реплике
- :white_check_mark: Сделайте push всех изменений в новую ветку в репозиторий
- :white_check_mark: Убедитесь что сборка самостоятельно запустилась, тесты прошли успешно
- :white_check_mark: Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`
- :white_check_mark: Убедитесь, что нет собранного артефакта в сборке по ветке `master`
- :white_check_mark: Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки
- :white_check_mark: Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны
- :white_check_mark: Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity
- :white_check_mark: В ответ предоставьте ссылку на репозиторий

    > Ссылка на репозиторий [Example teamcity](https://github.com/prunovr/example-teamcity)
