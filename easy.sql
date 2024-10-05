-- 1
-- Вывести имена всех людей, 
-- которые есть в базе данных авиакомпаний
SELECT name
FROM Passenger;


-- 3
-- Вывести все рейсы, 
-- совершенные из Москвы
SELECT *
FROM Trip
WHERE Trip.town_from = "Moscow";


-- 4
-- Вывести имена людей, 
-- которые заканчиваются на "man"
SELECT name
FROM Passenger
WHERE name LIKE "%man";


-- 5
-- Вывести количество рейсов, 
-- совершенных на TU-134
SELECT COUNT(*) AS COUNT
FROM Trip
WHERE Trip.plane = "TU-134";


-- 6
-- Какие компании совершали перелеты на Boeing
SELECT DISTINCT name
FROM Company
	INNER JOIN Trip ON Company.id = Trip.company
WHERE Trip.plane = "Boeing";


-- 7
-- Вывести все названия самолётов, 
-- на которых можно улететь в Москву (Moscow)
SELECT DISTINCT plane
FROM Trip
WHERE Trip.town_to = 'Moscow';


-- 9
-- Какие компании организуют перелеты из Владивостока (Vladivostok)?
SELECT DISTINCT name
FROM Company
	INNER JOIN Trip ON Trip.company = Company.id
WHERE Trip.town_from = 'Vladivostok';


-- 12
-- Выведите идентификаторы всех рейсов 
-- и количество пассажиров на них. Обратите внимание, 
-- что на каких-то рейсах пассажиров может не быть. 
-- В этом случае выведите число "0".
SELECT Pass_in_trip.trip AS trip,
	COUNT(Passenger.id) AS COUNT
FROM Pass_in_trip
	INNER JOIN Passenger ON Passenger.id = Pass_in_trip.passenger
GROUP BY Pass_in_trip.trip;


-- 14
-- В какие города летал Bruce Willis
SELECT town_to
FROM Trip
	INNER JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
	INNER JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
WHERE Passenger.name = 'Bruce Willis';


-- 15
-- Выведите дату и время прилёта пассажира 
-- Стив Мартин (Steve Martin) в Лондон (London)
SELECT time_in
FROM Trip
	INNER JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
	INNER JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
WHERE Passenger.name = 'Steve Martin'
	AND Trip.town_to = 'London';


-- 19
-- Определить, кто из членов семьи 
-- покупал картошку (potato)
SELECT DISTINCT status
FROM FamilyMembers
INNER JOIN Payments ON FamilyMembers.member_id = Payments.family_member
INNER JOIN Goods ON Payments.good = Goods.good_id
WHERE Goods.good_name = 'potato';


-- 22
-- Найти имена всех матерей (mother)
SELECT DISTINCT member_name
FROM FamilyMembers
WHERE FamilyMembers.status = 'mother';


-- 28
-- Сколько рейсов совершили авиакомпании 
-- из Ростова (Rostov) в Москву (Moscow) ?
SELECT COUNT(*) AS COUNT
FROM Trip
WHERE Trip.town_from = 'Rostov'
	AND Trip.town_to = 'Moscow';


-- 34
-- Сколько всего 10-ых классов
SELECT COUNT(*) AS COUNT
FROM Class
WHERE Class.name LIKE '10%';


-- 36
-- Выведите информацию об обучающихся 
-- живущих на улице Пушкина (ul. Pushkina)
FROM Student
WHERE Student.address LIKE 'ul. Pushkina%';


-- 38
-- Сколько Анн (Anna) учится в школе ?
SELECT COUNT(*) AS count 
FROM Student
WHERE Student.first_name = 'Anna';


-- 39
-- Сколько обучающихся в 10 B классе ?
SELECT COUNT(*) AS count 
FROM Class
INNER JOIN Student_in_class ON Class.id = Student_in_class.class
WHERE Class.name = '10 B';


-- 41
-- Выясните, во сколько по расписанию 
-- начинается четвёртое занятие.
SELECT DISTINCT start_pair 
FROM Timepair
INNER JOIN Schedule ON Timepair.id = Schedule.number_pair
WHERE Schedule.number_pair = 4;


-- 53
-- Измените имя "Andie Quincey" на новое "Andie Anthony".
UPDATE FamilyMembers
SET FamilyMembers.member_name = 'Andie Anthony'
WHERE FamilyMembers.member_name = 'Andie Quincey';


-- 56
-- Удалить все перелеты, 
-- совершенные из Москвы (Moscow).
DELETE 
FROM Trip
WHERE Trip.town_from = 'Moscow';


-- 74
-- Выведите идентификатор и признак наличия интернета в помещении.
-- Если интернет в сдаваемом жилье присутствует, 
-- то выведите «YES», иначе «NO».
SELECT id, 
    CASE 
        WHEN has_internet = 1 THEN 'YES'
        WHEN has_internet = 0 THEN 'NO'
    END
    AS has_internet
FROM Rooms;


-- 75
-- Выведите фамилию, имя и дату рождения студентов, 
-- кто был рожден в мае.
SELECT last_name, first_name, birthday
FROM Student
WHERE MONTH(birthday) = 5;


-- 99
-- Посчитай доход с женской аудитории (доход = сумма(price * items)). 
-- Обратите внимание, 
-- что в таблице женская аудитория имеет поле user_gender «female» или «f».
SELECT SUM(price * items) AS income_from_female
FROM Purchases
WHERE user_gender = 'f' OR user_gender = 'female';


-- 103
-- Вывести список имён сотрудников, 
-- получающих большую заработную плату, 
-- чем у непосредственного руководителя.
SELECT e.name
FROM Employee e
	INNER JOIN Employee c ON e.chief_id = c.id
WHERE e.salary > c.salary;


-- 109
-- Выведите название страны, 
-- где находится город «Salzburg»
SELECT DISTINCT Countries.name AS country_name
FROM Countries
	INNER JOIN Regions ON Countries.id = Regions.countryid
	INNER JOIN Cities ON Regions.id = Cities.regionid
WHERE Cities.name = 'Salzburg';


-- 114
-- Напишите запрос, 
-- который выведет имена пилотов, 
-- которые в качестве второго пилота (second_pilot_id) 
-- в августе 2023 года летали в New York
SELECT Pilots.name AS name
FROM Pilots
	INNER JOIN Flights ON Pilots.pilot_id = Flights.second_pilot_id
WHERE MONTH(Flights.flight_date) = 8
	AND YEAR(Flights.flight_date) = 2023
	AND Flights.destination = 'New York';