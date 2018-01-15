import Data.List

-- решаваме задача 01. от ей тук - https://learn.fmi.uni-sofia.bg/mod/page/view.php?id=80399
--
-- като за начало искаме да вземем колоните - еми хайде да транспонираме матрица
-- как? на всеки от елементите на матрицата (демек на всеки ред) ще мап-нем главата му,
-- след което ще премахнем току-що мапнатата глава от всеки ред като мап-нем на всеки ред
-- опашката му. първата част постига целта на това да вземем колона ("първата" сегашна
-- колона, гледайки матрицата нормално), а втората постига ефекта да продължим към 
-- "следващата" колона
-- забележка – трябва да проверим ръчно дали матрицата не е само от празни списъци,
-- не можем чрез pattern matching защото списък който има елементи празни списъци
-- не е "кодирано" в типовата система по никакъв начин - той е най-обикновен списък,
-- това че стойността му е "специална" за нас не вълнува много типовата система
transpose' :: [[a]] -> [[a]]
transpose' xss 
    | allEmpty xss = []
    | otherwise    = map head xss : (transpose' $ map tail xss)
        where allEmpty = all null

-- условието някоя от колоните да се съдържат всичките ѝ елементи в един ред
-- е същото като да кажем че колоната е подмножество на реда, така че си правим
-- подмножество, използвайки буквално дефиницията за подмножество -
-- всеки елемент на X да е елемент и на Y (в нашия случай взимаме всички елементи на 
-- X, които не са елементи на Y и после гледаме дали въобще има такива)
subset :: (Eq a) => [a] -> [a] -> Bool
subset xs ys = null [x | x <- xs, not $ x `elem` ys]

-- тук просто превеждаме условието на задачата, имайки вече нужните функции -
-- транспонираме матрицата, и проверяваме дали съществува такава колона (x <- columns)
-- че за някой от оригиналните редове (any) тя да му е подмножество
findColumns :: (Eq a) => [[a]] -> Int
findColumns xss = length [x | x <- columns, any (subset x) xss]
                    where columns = transpose' xss

-- готино транспониране използвайки zipWith и безкраен списък от празни списъци
-- схванете го това за да се почувствате готино, най-лесно се вижда с картинка
cooltranspose :: [[a]] -> [[a]]
cooltranspose [] = repeat []
cooltranspose (xs:xss) = zipWith (:) xs $ cooltranspose xss

-- Задача 02. от същото място
-- 
-- правим композирането от задачата, като просто следваме типовете за да стигнем
-- до тази дефиниция
-- забележете как можеше да подадем и x и да напишем (h (f x) (g x)), но то е същото
-- поради начинът по който работи curry-ването
-- освен това е по-готино да си мислим, че връщаме функция и в действителност да върнем функция
compose :: (a1 -> a2 -> k) -> (a -> a1) -> (a -> a2) -> (a -> k)
compose h f g = (\x -> h (f x) (g x))

-- self-explanatory
equalOnInterv :: (Int -> Int) -> (Int -> Int) -> Int -> Int -> Bool
equalOnInterv f g a b = map f interv == map g interv
                        where interv = [a..b]

-- буквално превеждаме условието от задачата и всеки път когато то е изпълнено слагаме
-- 1-чка в списък, няма значение какво ще сложим, стига да има нещо, за да можем после да
-- питаме дали има поне едно такова нещо (питайки дали списъкът не е празен)
check :: Int -> Int -> 
         [(Int -> Int)] -> 
         [(Int -> Int -> Int)] -> Bool
check a b uns bins = not $ null [1 | first <- uns, second <- uns, bin <- bins, match <- uns,
                                         equalOnInterv (compose bin first second) match a b]

-- Задача 03. от същото място
-- тъпа задача, няма да я описвам
-- ще спомена само идеята че дали ще вземем цял интервал в който живеят най-много
-- растения или само една точка е едно и също - тоест за всички точки от интервала
-- е вярно че в него живеят най-много растения и тази идея използваме за да намерим
-- "интервал" в който живеят най-много растения, като просто проверяваме всички възможни точки
plantsWhichLiveIn :: Int -> [(String, Int, Int)] -> [String]
plantsWhichLiveIn num xs = [name | (name, start, end) <- xs, num `elem` [start..end]]

plants :: [(String, Int, Int)] -> ((Int, Int), [String])
plants xs = ((fst maxPoint, fst maxPoint), snd maxPoint)
            where minLive = minimum [start | (_, start, _) <- xs]
                  maxLive = maximum [end   | (_, _,   end) <- xs]
                  plantsLivingInPoints = map (\x -> (x, plantsWhichLiveIn x xs)) [minLive..maxLive]
                  sorted = sortOn (\(p, n) -> length n) plantsLivingInPoints
                  maxPoint = head sorted

-- Задача 01. от ей тук - https://learn.fmi.uni-sofia.bg/mod/page/view.php?id=80443
--
-- каква е идеята, взимаме като за начало само стойностите за които съвпадат функциите,
-- после от тези стойности правим интервали, после взимаме най-дългия от тези интервали
-- единствената интересна част е функцията makeIntervals, като отново препоръчвам
-- разписване за прост случай за да се убедите че работи/разберете как работи
-- (тя взима списък от числа и връща списък от списъци, като за всеки от тези списъци
-- е вярно че първият елемент и последният му елемент са интервалът на елементите
-- от списъка (защо не го направихме с наредена двойка - за да не трябва после да смятаме
-- по наредена двойка дължина на интервал, сега можем просто да ползваме length))
matchingVals :: (Int -> Int) -> (Int -> Int) -> Int -> Int -> [Int]
matchingVals f g start end = [x | x <- interval, f x == g x]
                                where interval = [start..end]

makeIntervals :: [Int] -> [[Int]]
makeIntervals [] = [[]]
makeIntervals (x:[]) = [[x]]
makeIntervals (x:y:xs) 
            | x + 1 == y = (x : z) : zs
            | otherwise  = [x] : makeIntervals (y:xs)
                where (z:zs) = makeIntervals (y:xs)

maximumLengthInterv :: [[Int]] -> (Int, Int)
maximumLengthInterv xss = (head maxInterv, last maxInterv)
                            where lengths = map (\x -> (length x, x)) xss
                                  maxInterv = snd $ maximum lengths

largestInterval :: (Int -> Int) -> (Int -> Int) -> Int -> Int -> (Int, Int)
largestInterval f g a b = maximumLengthInterv $ 
                          makeIntervals $ 
                          matchingVals f g a b

-- Задача 03. от предишния линк
-- правим си естествени числа, за да има от къде да взимаме неща
nats = [0..]

-- каква ни е идеята? просто превеждаме условието на list comprehension,
-- като внимаваме да не кажем случайно наивното y <- nats, z <- nats,
-- защото в такъв случай ще пробваме с x == 0, y == 0, z == 0, след това с
-- x == 0, y == 0, z == 1, след това с x == 0, y == 0, z == 2 .. и т.н.
-- тоест никога няма да имаме резултат. като ограничим y и z да са в интервала
-- [0..x] знаем че те не могат да се безкраен брой никога за фиксирано x и освен
-- това ние знаем че едно число може само да е сума на две по-малки от него.
sumsOfSquares = [x | x <- nats, y <- [0..x], z <- [0..x], x == y^2 + z^2]
