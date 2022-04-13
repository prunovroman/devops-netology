# Результаты домашнего задания "7.6. Написание собственных провайдеров для Terraform."

## Задача 1

Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: [https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git). Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.

1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на
гитхабе.
    - `data_source` представлены на строке `412` файла `provider.go`: <https://github.com/hashicorp/terraform-provider-aws/blob/fade619eb77d9ddfed81bafa92e0101764c39c20/internal/provider/provider.go#L412>
    - `resource` представлены на строке `871` файла `provider.go`: <https://github.com/hashicorp/terraform-provider-aws/blob/fade619eb77d9ddfed81bafa92e0101764c39c20/internal/provider/provider.go#L871>

1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`
    - С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
        - `ConflictsWith: []string{"name_prefix"}`: <https://github.com/hashicorp/terraform-provider-aws/blob/fade619eb77d9ddfed81bafa92e0101764c39c20/internal/service/sqs/queue.go#L87>
    - Какая максимальная длина имени?
        - `127` символов: <https://github.com/hashicorp/terraform-provider-aws/blob/fade619eb77d9ddfed81bafa92e0101764c39c20/internal/service/connect/queue.go#L58>
    - Какому регулярному выражению должно подчиняться имя?
        - `[a-zA-Z0-9_-]`: <https://github.com/hashicorp/terraform-provider-aws/blob/fade619eb77d9ddfed81bafa92e0101764c39c20/internal/service/sqs/queue.go#L427>
