
-- Урок 9.

-- Задание 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
USE shop;
truncate TABLE sample.users;
START TRANSACTION;	
	INSERT INTO sample.users SELECT * FROM shop.users su WHERE su.id = 1;
COMMIT;

-- Задание 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и 
-- соответствующее название каталога name из таблицы catalogs.

DROP VIEW IF EXISTS products_catalog;
CREATE VIEW products_catalog AS 
	SELECT p.name AS producy , c.name AS catalog 
	FROM products p 
		JOIN 
		catalogs c 
			ON p.catalog_id = c.id;
SELECT * FROM products_catalog;



-- Задание 3. по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года 
-- '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в исходной таблице и 0, 
-- если она отсутствует.

DROP TABLE IF EXISTS aug_date;

create table aug_date (
  id SERIAL PRIMARY KEY,
  created_at date);
INSERT INTO aug_date VALUES
  (NULL, '2018-08-01'), (NULL, '2016-08-04'), (NULL, '2018-08-16'), (NULL, '2018-08-17');

DROP TABLE IF EXISTS aug_days;

-- временная таблица с днями августа
CREATE TEMPORARY TABLE aug_days (days int);

-- процедура заполнения временной таблицы днями августа
delimiter //
	
DROP PROCEDURE IF EXISTS get_day//
CREATE PROCEDURE get_day()
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i <= 31 DO
		INSERT INTO aug_days VALUES (i);
		SET i=i+1;
	END WHILE;
END//

delimiter ;

-- Заполняем временную таблицу днями августа
CALL get_day();

SELECT * FROM aug_days;  

SET @start_date = '2018-07-31'

SELECT 
	@start_date + INTERVAL a.days DAY AS 'date', 
	CASE 
		WHEN aug_date.created_at IS NULL THEN 0 ELSE 1 
	END AS 'log'
FROM
aug_days a
LEFT JOIN 
aug_date ON @start_date + INTERVAL a.days DAY = aug_date.created_at;

