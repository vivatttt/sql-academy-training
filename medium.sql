-- 8
-- В какие города можно улететь из Парижа (Paris) 
-- и сколько времени это займёт?
SELECT town_to,
	DATE_FORMAT(TIMEDIFF(time_in, time_out), '%T') AS flight_time
FROM Trip
WHERE town_from = 'Paris';


-- 10
-- Вывести вылеты, 
-- совершенные с 10 ч. по 14 ч. 1 января 1900 г.
SELECT *
FROM Trip
WHERE time_out BETWEEN '1900-01-01 10:00:00' AND '1900-01-01 14:00:00';


-- 11
-- Выведите пассажиров с самым длинным ФИО. 
-- Пробелы, дефисы и точки считаются частью имени.
SELECT name
FROM Passenger
WHERE LENGTH(name) = (
		SELECT MAX(LENGTH(Passenger.name))
		FROM Passenger
	);


-- 13
-- Вывести имена людей, 
-- у которых есть полный тёзка среди пассажиров
SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(*) > 1;


-- 16
-- Вывести отсортированный по количеству перелетов (по убыванию) 
-- и имени (по возрастанию) список пассажиров, 
-- совершивших хотя бы 1 полет.
SELECT Passenger.name AS name,
	COUNT(Pass_in_trip.trip) AS COUNT
FROM Passenger
	INNER JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
GROUP BY Passenger.name
HAVING COUNT(Pass_in_trip.trip) > 0
ORDER BY COUNT(Pass_in_trip.trip) DESC,
	Passenger.name ASC;


-- 17
-- Определить, сколько потратил в 2005 году каждый из членов семьи. 
-- В результирующей выборке не выводите тех членов семьи, 
-- которые ничего не потратили.
SELECT FamilyMembers.member_name,
	FamilyMembers.status,
	SUM(Payments.amount * Payments.unit_price) AS costs
FROM FamilyMembers
	INNER JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE YEAR(Payments.date) = 2005
GROUP BY FamilyMembers.member_name,
	FamilyMembers.status
HAVING SUM(Payments.amount * Payments.unit_price) > 0;


-- 18
-- Выведите имя самого старшего человека. 
-- Если таких несколько, 
-- то выведите их всех.
SELECT member_name
FROM FamilyMembers
WHERE birthday = (
		SELECT MIN(FamilyMembers.birthday)
		FROM FamilyMembers
	);


-- 20
-- Сколько и кто из семьи потратил на развлечения (entertainment). 
-- Вывести статус в семье, имя, сумму
SELECT FamilyMembers.status,
	FamilyMembers.member_name,
	SUM(Payments.amount * Payments.unit_price) AS costs
FROM FamilyMembers
	INNER JOIN Payments ON FamilyMembers.member_id = Payments.family_member
	INNER JOIN Goods ON Payments.good = Goods.good_id
	INNER JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
WHERE GoodTypes.good_type_name = 'entertainment'
GROUP BY FamilyMembers.status,
	FamilyMembers.member_name;


-- 21
-- Определить товары, которые покупали более 1 раза
SELECT Goods.good_name
FROM Goods
INNER JOIN Payments ON Goods.good_id = Payments.good
GROUP BY Payments.good
HAVING COUNT(*) > 1;


-- 23
-- Найдите самый дорогой деликатес (delicacies) 
-- и выведите его цену
SELECT Goods.good_name,
	MAX(Payments.unit_price) AS unit_price
FROM Goods
	INNER JOIN Payments ON Payments.good = Goods.good_id
	INNER JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
WHERE GoodTypes.good_type_name = 'delicacies'
GROUP BY Goods.good_name
ORDER BY MAX(Payments.unit_price) DESC
LIMIT 1;


-- 24
-- Определить кто и сколько потратил в июне 2005
SELECT FamilyMembers.member_name, SUM(Payments.unit_price * Payments.amount) as costs
FROM FamilyMembers
INNER JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE YEAR(Payments.date) = 2005 AND MONTH(Payments.date) = 6
GROUP BY FamilyMembers.member_name;


-- 25
-- Определить, какие товары не покупались в 2005 году
SELECT Goods.good_name
FROM Goods
LEFT JOIN Payments ON Goods.good_id = Payments.good 
    AND YEAR(Payments.date) = 2005
WHERE Payments.good IS NULL;


-- 27
-- Узнайте, сколько было потрачено 
-- на каждую из групп товаров в 2005 году. 
-- Выведите название группы и потраченную на неё сумму. 
-- Если потраченная сумма равна нулю, т.е. 
-- товары из этой группы не покупались в 2005 году, 
-- то не выводите её.
SELECT GoodTypes.good_type_name,
	SUM(Payments.amount * Payments.unit_price) AS costs
FROM GoodTypes
	INNER JOIN Goods ON Goods.type = GoodTypes.good_type_id
	INNER JOIN Payments ON Goods.good_id = Payments.good
WHERE YEAR(Payments.date) = 2005
GROUP BY GoodTypes.good_type_name
HAVING costs > 0;

-- 29
-- Выведите имена пассажиров улетевших 
-- в Москву (Moscow) на самолете TU-134
SELECT DISTINCT Passenger.name
FROM Passenger
	INNER JOIN Pass_in_trip ON Pass_in_trip.passenger = Passenger.id
	INNER JOIN Trip ON Pass_in_trip.trip = Trip.id
WHERE Trip.town_to = 'Moscow'
	AND Trip.plane = 'TU-134';


-- 30
-- Выведите нагруженность (число пассажиров) каждого рейса (trip). 
-- Результат вывести в отсортированном виде по убыванию нагруженности.
SELECT Trip.id AS trip, COUNT(Pass_in_trip.trip) AS count
FROM Trip
INNER JOIN Pass_in_trip ON Pass_in_trip.trip = Trip.id
GROUP BY Pass_in_trip.trip
ORDER BY count DESC;


-- 31
-- Вывести всех членов семьи с фамилией Quincey.
SELECT *
FROM FamilyMembers
WHERE FamilyMembers.member_name LIKE '%Quincey';


-- 32
-- Вывести средний возраст людей (в годах), хранящихся в базе данных. 
-- Результат округлите до целого в меньшую сторону.
SELECT FLOOR(
		AVG(
			(DATEDIFF(NOW(), FamilyMembers.birthday)) / 365.25
		)
	) AS age
FROM FamilyMembers;


-- 33
-- Найдите среднюю цену икры на основе данных, 
-- хранящихся в таблице Payments. 
-- В базе данных хранятся данные о покупках красной (red caviar) 
-- и черной икры (black caviar). 
-- В ответе должна быть одна строка со средней ценой всей купленной когда-либо икры.
SELECT AVG(Payments.unit_price) AS cost
FROM Payments
	INNER JOIN Goods ON Goods.good_id = Payments.good
WHERE Goods.good_name = 'red caviar'
	OR Goods.good_name = 'black caviar';


-- 35
-- Сколько различных кабинетов школы использовались 
-- 2 сентября 2019 года для проведения занятий?
SELECT COUNT(DISTINCT Schedule.classroom) AS COUNT
FROM Schedule
WHERE Schedule.date = '2019-09-02';


-- 37
-- Сколько лет самому молодому обучающемуся ?
SELECT MIN(
		FLOOR(DATEDIFF(NOW(), Student.birthday) / 365.25)
	) AS year
FROM Student;


-- 40
-- Выведите название предметов, 
-- которые преподает Ромашкин П.П. (Romashkin P.P.). 
-- Обратите внимание, что в базе данных есть несколько учителей 
-- с такими фамилией и инициалами.
SELECT DISTINCT Subject.name AS subjects
FROM Subject
	INNER JOIN Schedule ON Schedule.subject = Subject.id
	INNER JOIN Teacher ON Teacher.id = Schedule.teacher
WHERE Teacher.last_name = 'Romashkin'
	AND Teacher.middle_name LIKE 'P%'
	AND Teacher.first_name LIKE 'P%';


-- 42
-- Сколько времени обучающийся будет находиться в школе, 
-- учась со 2-го по 4-ый уч. предмет?
SELECT TIMEDIFF(
        (
        SELECT end_pair
        FROM Timepair
        WHERE id = 4
        ),
		(
			SELECT start_pair
			FROM Timepair
			WHERE id = 2
		)
	) AS time;


-- 43
-- Выведите фамилии преподавателей, 
-- которые ведут физическую культуру (Physical Culture). 
-- Отсортируйте преподавателей по фамилии в алфавитном порядке.
SELECT last_name
FROM Teacher
INNER JOIN Schedule ON Teacher.id = Schedule.teacher
INNER JOIN Subject ON Schedule.subject = Subject.id
WHERE Subject.name = 'Physical Culture'
ORDER BY last_name ASC;


-- 46
-- В каких классах введет занятия преподаватель "Krauze" ?
SELECT DISTINCT name 
FROM Class
INNER JOIN Schedule ON Schedule.class = Class.id
INNER JOIN Teacher ON Teacher.id = Schedule.teacher
WHERE Teacher.last_name = 'Krauze';


-- 47
-- Сколько занятий провел Krauze 30 августа 2019 г.?
SELECT COUNT(*) AS count 
FROM Schedule
INNER JOIN Teacher ON Schedule.teacher = Teacher.id 
WHERE Teacher.last_name = 'Krauze' AND Schedule.date = '2019-08-30';


-- 48
-- Выведите заполненность классов в порядке убывания
SELECT Class.name, COUNT(Student_in_class.class) AS count
FROM Class
INNER JOIN Student_in_class ON Student_in_class.class = Class.id
GROUP BY Class.name
ORDER BY count DESC;


-- 49
-- Какой процент обучающихся учится в "10 A" классе? 
-- Выведите ответ в диапазоне от 0 до 100 
-- с округлением до четырёх знаков после запятой, например, 96.0201.
SELECT COUNT(CASE WHEN Class.name = '10 A' THEN Student_in_class.student END) / COUNT(Student_in_class.student) * 100 AS percent
FROM Class
INNER JOIN Student_in_class ON Student_in_class.class = Class.id;


-- 50
-- Какой процент обучающихся родился в 2000 году? 
-- Результат округлить до целого в меньшую сторону.
SELECT FLOOR(
		COUNT(
			CASE
				WHEN YEAR(Student.birthday) = 2000 THEN Student.id
			END
		) / COUNT(Student.id) * 100
	) AS percent
FROM Student;


-- 51
-- Добавьте товар с именем "Cheese" и типом "food" 
-- в список товаров (Goods).
SET @good_id_var = (
		SELECT COUNT(*) + 1
		FROM Goods
	);
INSERT INTO Goods (good_id, good_name, TYPE)
VALUES (
		@good_id_var,
		'Cheese',
		(
			SELECT good_type_id
			FROM GoodTypes
			WHERE good_type_name = 'food'
		)
	);


-- 52
-- Добавьте в список типов товаров (GoodTypes) новый тип "auto".
SET @good_types_len = (
		SELECT COUNT(*)
		FROM GoodTypes
	);
INSERT INTO GoodTypes (good_type_id, good_type_name)
VALUES (@good_types_len + 1, 'auto');


-- 54
-- Удалить всех членов семьи с фамилией "Quincey".
DELETE FROM FamilyMembers
WHERE member_name LIKE '%Quincey';


-- 57
-- Перенести расписание всех занятий на 30 мин. вперед.
UPDATE Timepair
SET start_pair = DATE_ADD(start_pair, INTERVAL 30 MINUTE),
	end_pair = DATE_ADD(end_pair, INTERVAL 30 MINUTE);


-- 59
-- Вывести пользователей,указавших Белорусский номер телефона ? 
-- Телефонный код Белоруссии +375.
SELECT *
FROM Users
WHERE phone_number LIKE '+375%';


-- 61
-- Выведите список комнат, которые были зарезервированы 
-- хотя бы на одни сутки в 12-ую неделю 2020 года. 
-- В данной задаче в качестве одной недели примите период из семи дней, 
-- первый из которых начинается 1 января 2020 года. 
-- Например, первая неделя года — 1–7 января, а третья — 15–21 января.
SELECT DISTINCT Rooms.*
FROM Rooms
	INNER JOIN Reservations ON Reservations.room_id = Rooms.id
WHERE Reservations.start_date <= '2020-03-22'
	AND Reservations.end_date >= '2020-03-16';


-- 62
-- Вывести в порядке убывания популярности доменные имена 
-- 2-го уровня, используемые пользователями для электронной почты. 
-- Полученный результат необходимо дополнительно отсортировать по возрастанию названий доменных имён.
SELECT SUBSTRING_INDEX(email, '@', -1) AS domain,
	COUNT(SUBSTRING_INDEX(email, '@', -1)) AS COUNT
FROM Users
GROUP BY domain
ORDER BY COUNT DESC,
	domain ASC;


-- 63
-- Выведите отсортированный список (по возрастанию) фамилий и имен студентов в виде Фамилия.И.
SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.') as name
FROM Student
ORDER BY name;


-- 64
-- Вывести количество бронирований по каждому месяцу каждого года, 
-- в которых было хотя бы 1 бронирование. 
-- Результат отсортируйте в порядке возрастания даты бронирования.
SELECT YEAR(start_date) AS year,
	MONTH(start_date) AS MONTH,
	COUNT(*) AS amount
FROM Reservations
GROUP BY YEAR(start_date),
	MONTH(start_date)
ORDER BY YEAR(start_date),
	MONTH(start_date);


-- 65
-- Необходимо вывести рейтинг для комнат, 
-- которые хоть раз арендовали, как среднее значение рейтинга отзывов 
-- округленное до целого вниз.
SELECT Reservations.room_id,
	FLOOR(SUM(Reviews.rating) / COUNT(Reviews.rating)) AS rating
FROM Reservations
	INNER JOIN Reviews ON Reviews.reservation_id = Reservations.id
GROUP BY Reservations.room_id;


-- 66 
-- Вывести список комнат со всеми удобствами (наличие ТВ, интернета, кухни и кондиционера),
-- а также общее количество дней и сумму за все дни аренды каждой из таких комнат.
SELECT
  Rooms.home_type,
  Rooms.address,
  IFNULL(SUM(TIMESTAMPDIFF(DAY, Reservations.start_date, Reservations.end_date)), 0) AS days,
  IFNULL(SUM(Reservations.total), 0) AS total_fee
FROM
  Rooms
LEFT JOIN
  Reservations ON Rooms.id = Reservations.room_id
WHERE
  Rooms.has_air_con = 1
  AND Rooms.has_internet = 1
  AND Rooms.has_kitchen = 1
  AND Rooms.has_tv = 1
GROUP BY
  Rooms.id;


-- 67
-- Вывести время отлета и время прилета для каждого перелета в формате  "ЧЧ:ММ, ДД.ММ - ЧЧ:ММ, ДД.ММ", 
-- где часы и минуты с ведущим нулем, а день и месяц без.
SELECT CONCAT(
		DATE_FORMAT(
			time_out,
			'%H:%i, %e.%c'
		),
		' - ',
		DATE_FORMAT(
			time_in,
			'%H:%i, %e.%c'
		)
	) AS flight_time
FROM Trip;


-- 70
-- Необходимо категоризовать жилье на economy, comfort, premium по цене соответственно <= 100, 100 < цена < 200, >= 200. 
-- В качестве результата вывести таблицу с названием категории и количеством жилья,
-- попадающего в данную категорию
SELECT 
    CASE 
        WHEN price >= 200 THEN 'premium'
        WHEN price > 100 AND price < 200 THEN 
        'comfort'
        WHEN price <= 100 THEN 'economy'
        
    END AS category,
    COUNT(*) AS count
FROM Rooms
GROUP BY category;


-- 72
-- Выведите среднюю цену бронирования за сутки для каждой из комнат, 
-- которую бронировали хотя бы один раз. Среднюю цену необходимо округлить до целого значения вверх.
SELECT room_id, CEILING(AVG(price)) AS avg_price
FROM Reservations
GROUP BY room_id;


-- 73
-- Выведите id тех комнат, которые арендовали нечетное количество раз
SELECT room_id,
	COUNT(*) AS COUNT
FROM Reservations
GROUP BY room_id
HAVING COUNT % 2 = 1;


-- 76
-- Вывести имена всех пользователей сервиса бронирования жилья, 
-- а также два признака: является ли пользователь собственником 
-- какого-либо жилья (is_owner) и является ли пользователь арендатором (is_tenant). 
-- В случае наличия у пользователя признака необходимо вывести в соответствующее поле 1, иначе 0.
SELECT Users.name,
	CASE
		WHEN Rooms.owner_id IS NOT NULL THEN 1
		ELSE 0
	END AS is_owner,
	CASE
		WHEN Reservations.user_id IS NOT NULL THEN 1
		ELSE 0
	END AS is_tenant
FROM Users
	LEFT JOIN Rooms ON Rooms.owner_id = Users.id
	LEFT JOIN Reservations ON Reservations.user_id = Users.id
GROUP BY Users.id;


-- 77 
-- Создайте представление с именем "People", 
-- которое будет содержать список имен (first_name) и фамилий (last_name) всех студентов (Student) и преподавателей(Teacher)
CREATE TABLE People (
	first_name VARCHAR(250),
	last_name VARCHAR(250)
);
INSERT INTO People (first_name, last_name)
SELECT first_name,
	last_name
FROM Student
UNION
SELECT first_name,
	last_name
FROM Teacher;


-- 78
-- Выведите всех пользователей с электронной почтой в «hotmail.com»
SELECT *
FROM Users
WHERE email LIKE '%@hotmail.com';