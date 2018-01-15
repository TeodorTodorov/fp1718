# Записки от упражнения

1. [Въведение в неща](01.introduction.md)
2. [Рекурсивни и итеративни процеси](02.recursive-and-iterative-processes.md)
3. [Функции от по-висок ред](03.higher-order-functions.md)
4. [Списъци](04.lists.md)
5. [Haskell](05.haskell.md)
6. [Типове](06.types.hs)
7. [Функции от по-висок ред](07.higher-order-functions.hs)
8. [Играчка със задачи от контролни](08.exam-practice.hs)


# Общи

[Средство за дебъгване в DrRacket](https://docs.racket-lang.org/reference/debugging.html)  
Как се използва?

1. В началото на файла, след `#lang racket` реда, слагаме `(require racket/trace)`.
2. След дефиниция на процедура, чиито извиквания искаме да проследим, извикваме `(trace <procedure-name>)`
3. Извикваме нашата процедура.
4. В output панела на DrRacket се показват извикванията, които е предизвикала нашата процедура
5. ???
6. profit
