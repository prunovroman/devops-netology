# Результаты домашнего задания "7.5. Основы golang"

## Задача 1. Установите golang

1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

---

Установил `Golang`:

```bash

vagrant@vagrant:~$ go version
go version go1.18 linux/amd64

```

## Задача 2. Знакомство с gotour

У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/).
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.

---

Изучил, попробовал, поэксперементировал

## Задача 3. Написание кода

Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию `Scanf`:

    ```go

    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }

    // Решение задачи
    package main

    import "fmt"

    func main() {
        var input, result float64

        fmt.Print("Enter the feet: ")
        fmt.Scanf("%f", &input)
        result = input * 0.3048
        fmt.Println(result)
    }

    Outputs:

    Enter the feet: 45
    13.716000000000001

    ```

1. Напишите программу, которая найдет наименьший элемент в любом заданном списке:

    ```go

    package main

    import (
        "fmt"
        "math"
    )

    func main() {
        var min int = math.MaxInt64
        var x = [...]int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

        for _, value := range x {
            if min > value {
                min = value
            }
        }

        fmt.Println(min)

    }

    Output:

    9

    ```

1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`:

    ```go

    package main

    import (
        "fmt"
        "strings"
    )

    func main() {

        var result string

        for i := 1; i <= 100; i++ {
            if i%3 == 0 {
                result += fmt.Sprintf("%d, ", i)
            }
        }

        fmt.Printf("(%s)", strings.TrimRight(result, " ,"))
    }

    Output:

    (3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99)


    ```
