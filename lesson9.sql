
-- Урок 9.

-- Задание по теме "Транзакции, переменные, представления"

-- Задание 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
USE shop;
-- truncate TABLE sample.users;
START TRANSACTION;	
	INSERT INTO sample.users SELECT NULL, su.name,su.birthday_at,su.created_at,su.updated_at FROM shop.users su WHERE su.id = 1;
	DELETE FROM shop.users su WHERE su.id = 1;
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

-- Задание по теме "Хранимые процедуры и функции, триггеры"

-- Задание 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;

delimiter //
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN 
	DECLARE hel TEXT DEFAULT "Добрый вечер";
	
	IF (curtime() < "06:00:00") THEN 
		SET hel = "Доброй ночи";
	ELSEIF (curtime() < "12:00:00") THEN 
		SET hel = "Доброе утро";
	ELSEIF (curtime() < "18:00:00") THEN 
		SET hel = "Добрый день";
	END IF;
	RETURN hel;
END//
delimiter ;

SELECT hello();


-- Задание 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS insert_product;

delimiter //

CREATE TRIGGER insert_product BEFORE INSERT ON products

FOR EACH ROW 

BEGIN 
	IF (isnull(NEW.name) AND isnull(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "Наименование товара и его описание не могут одновременно иметь значение null";
	END IF;
END//
delimiter ;

INSERT INTO products (name, description, price,catalog_id) VALUES 
(NULL,NULL,1000,20);

