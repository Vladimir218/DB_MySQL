
-- Урок 5
-- Задание по теме "Операторы, фильтрация, сортировка и ограничения"
-- в ранее созданной базе создаем для данного задания клон таблицы users (new_users)

USE vk;
SELECT * FROM users;
DROP TABLE  IF EXISTS new_users;
CREATE TABLE new_users LIKE users;
INSERT INTO new_users SELECT * FROM users;

UPDATE new_users SET created_at = NULL, updated_at = NULL;
SELECT * FROM new_users;
ALTER TABLE new_users 
	MODIFY COLUMN created_at VARCHAR(30),
	MODIFY COLUMN updated_at VARCHAR(30)
;

-- Задание 1. заполнить текущими датами поля created_at и updated_at

UPDATE new_users SET 
	created_at = DATE_FORMAT(now(), '%d.%c.%Y %h:%i'),
	updated_at =DATE_FORMAT(now(), '%d.%c.%Y %h:%i');


-- Задание 2. Преобрпазовать поля created_at и updated_at к типу DATETIME, сохранив введеные ранее значения

UPDATE new_users SET 
	created_at = STR_TO_DATE(created_at, '%d.%c.%Y %h:%i'),
	updated_at =STR_TO_DATE(updated_at, '%d.%c.%Y %h:%i');

ALTER TABLE new_users 
	MODIFY COLUMN created_at DATETIME,
	MODIFY COLUMN updated_at DATETIME
;
	
-- Задание 3. Отсортировать записи value по возрастанию. Нулевые записи в конце.

-- Загрузил БД shop из материалов урока.


USE shop;

SELECT * FROM storehouses_products;

-- заполняем таблицу, т.к. в учебной базе она пустая
INSERT INTO storehouses_products 
(storehouse_id,product_id,value,created_at,updated_at)
VALUES
(floor(1+rand()*100),floor(1+rand()*100), floor(1+rand()*1000),now(),now()),
(floor(1+rand()*100),floor(1+rand()*100), floor(1+rand()*1000),now(),now()),
(floor(1+rand()*100),floor(1+rand()*100), floor(1+rand()*1000),now(),now()),
(floor(1+rand()*100),floor(1+rand()*100), floor(1+rand()*1000),now(),now()),
(floor(1+rand()*100),floor(1+rand()*100), floor(1+rand()*1000),now(),now()),
(floor(1+rand()*100),floor(1+rand()*100), floor(1+rand()*1000),now(),now());

UPDATE storehouses_products SET value = 0 WHERE id%3 = 0;

SELECT * 
FROM storehouses_products ORDER BY 
CASE  
	WHEN value=0 THEN 1
	ELSE 0
END, value;


-- Задание 4. Из таблицы users извлеч пользователей, которые родились в августе и мае.


SELECT * FROM users;

-- в исходной таблице формат дат задан в цифровом виде. Преобразуем месяц в буквенное написание.

ALTER TABLE users 
	MODIFY COLUMN birthday_at VARCHAR(30);

UPDATE users SET 
	birthday_at = str_to_date(date_format(birthday_at,'%d %M %Y'),'%d %M %Y')
;


-- выводим пользователей в дате рождения которых есть месяц may или august
SELECT name, birthday_at FROM users WHERE birthday_at LIKE '___may_____%' OR birthday_at LIKE '___august_____';

-- Задание 5 Сортировка выводимых записей в порядке, указанном в списке IN

SELECT * FROM catalogs 
WHERE id IN(5,1,2) 
ORDER BY
CASE 
	WHEN id = 5 THEN 1
	WHEN id = 1 THEN 2
	WHEN id = 2 THEN 3
END;

-- Урок5. Тема "Агригация данных"

-- Задание 1. Подсчитать средний возраст пользователей в таблице юсерс

SELECT AVG(TIMESTAMPDIFF(YEAR, STR_TO_DATE (birthday_at, '%d %M %Y'),NOW())) AS AVG_YEAR FROM users;

-- Задание 2. Подсчитать количество дней рождения, приходящихся на каждый из дней недели.

SELECT
	DATE_FORMAT( 
		STR_TO_DATE(
			CONCAT( 
				DATE_FORMAT(STR_TO_DATE(birthday_at,'%d %M %Y'),'%d'), "-", 
				DATE_FORMAT(STR_TO_DATE(birthday_at,'%d %M %Y'),'%m'), "-",
				YEAR(NOW())
			)
		,'%d-%m-%Y')
	,'%W') AS day_week,
	COUNT(*) AS quantity
FROM users
GROUP BY day_week;

-- Задание 3. Подсчитать произведение чисел в столбце таблицы

-- Нужно перемножить числа от 1 до 5. Для примера возьмем Id в таблице users в нужном диапазоне.
SELECT EXP(sum(LN(id))) FROM users WHERE id<6;

