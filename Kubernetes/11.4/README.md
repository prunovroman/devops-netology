
# Результаты домашнего задания "11.04 Микросервисы: масштабирование"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: Кластеризация

Предложите решение для обеспечения развертывания, запуска и управления приложениями.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:

- Поддержка контейнеров;
- Обеспечивать обнаружение сервисов и маршрутизацию запросов;
- Обеспечивать возможность горизонтального масштабирования;
- Обеспечивать возможность автоматического масштабирования;
- Обеспечивать явное разделение ресурсов доступных извне и внутри системы;
- Обеспечивать возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т.п.

Обоснуйте свой выбор.

---

## **Kubernetes**

- поддерживает разные системы контейнеризации, например: Docker(containerd через dockershim), cri-o(RedHat), runc, rkt(заброшено RedHat)
- Kubernetes DNS, каждому сервису, созданному с помощью объекта Service, присваивается доменное имя,совпадающее с именем самого сервиса. Маршрутизация происходт через kube-proxy и virtual ip
- в Kubernetes есть функция autoscaling: в зависимости от нагрузки Kubernetes сам будет потдерживать минимальное или максимальное количество запущенных экземпляров сервиса
- горизонтальное масштабирование в  Kubernetes это увеличение количества Pod с запущенными контейнерами, распределенными по всему кластеру
- `namespaces`: это способ разделить кластер на индивидуальные зоны, где возможно использовать одни и те же имена объектов Kubernetes. `NetworkPolicy` и `GlobalNetworkPolicy`: разграничение доступа внутри кластера, контроль исходящего и входящего трафика. `ingress-controller`: маршрутизация трафика определённый сервис
- в k8s есть объект - `secret` для хранения чувствительных данных. Также есть `vault` для множества функционала по хранению секретов
