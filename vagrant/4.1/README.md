# Результаты домашнего задания к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:

```bash
    a=1
    b=2
    c=a+b
    d=$a+$b
    e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | в данном случае `а+b` не переменные, а обыкновенная строка |
| `d`  | 1+2  | в данном случае сработает подстановка значений, но опять таки выведится как строка с подствленными значениями |
| `e`  | 3  | в данном случае bash попытется произвести синтаксический анализ как арифметического выражения |

## Обязательная задача 2

На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

```bash
    while ((1==1)
    do
        curl https://localhost:4757
        if (($? != 0))
        then
            date >> curl.log
        fi
    done

    ----------------------------------------------------------

    #!/usr/bin/env bash

    while ((1==1))
    do
            curl http://localhost:4757

            if (( $?!=0 ))
            then
                    date >> curl.log
            else
                    break;
            fi
    done
```

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт

```bash
    #!/usr/bin/env bash

    array_ip=("88.212.236.76" "173.194.222.113" "127.0.0.1")

    for i in ${array_ip[@]}
    do
        count=1
        echo $i >> log
        
        while [ "$count" -le 5 ]
        do
          output=$(curl $i)
          echo $output >> log
          let "count+=1"
        done
    done
```

## Обязательная задача 3

Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт

```bash
    #!/usr/bin/env bash

    array_ip=("88.212.236.76" "173.194.222.113" "127.0.0.1")

    for i in ${array_ip[@]}
    do
            count=1
            echo $i >> log

            while [ "$count" -le 5 ]
            do
                output=$(curl $i)

                if (( $?!=0 ))
                then
                    echo $i >> error
                    break
                else
                    echo $output >> log
                    let "count+=1"
                fi
            done
    done
```