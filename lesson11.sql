-- Урок 11.
-- Задание по теме "Оптимизация запросов"

-- Задание 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
-- идентификатор первичного ключа и содержимое поля name.

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	create_at DATETIME NOT NULL,
	tabel_name VARCHAR(100) NOT NULL,
	id BIGINT (20) NOT NULL,
	name VARCHAR (100) NOT NULL
) COMMENT 'логирование записей в таблицах users, catalogs, products' 
ENGINE = ARCHIVE; 


-- TRIGGER FOR tab USERS

DROP TRIGGER IF EXISTS log_user;

delimiter //

CREATE TRIGGER log_user AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (create_at, tabel_name, id, name) 
	VALUES (now(),'users', NEW.id, NEW.name);
END//
delimiter ;

-- проверяем работу триггера

INSERT INTO users (name,birthday_at) 
VALUES('Иван', '1977-05-21')

-- TRIGGER FOR tab catalogs

DROP TRIGGER IF EXISTS log_catalogs;

delimiter //

CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (create_at, tabel_name, id, name) 
	VALUES (now(),'catalogs', NEW.id, NEW.name);
END//
delimiter ;

-- проверяем работу триггера

INSERT INTO catalogs (name) 
VALUES('Посуда')

-- TRIGGER FOR tab products

DROP TRIGGER IF EXISTS log_products;

delimiter //

CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (create_at, tabel_name, id, name) 
	VALUES (now(),'products', NEW.id, NEW.name);
END//
delimiter ;

-- проверяем работу триггера

INSERT INTO products (name, description, price, catalog_id) 
VALUES('Утюг', '1500 вт, с отпаривателем', 120, 3)


-- Задание по теме "NoSQL"

-- Задание 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

-- можно использовать хеш таблицу со связкой имя хэша (IPadr), IP адрес (127.0.0.10) количество посещений (20)
-- HSET IPadr 127.0.0.10 20

-- Задание 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
-- поиск электронного адреса пользователя по его имени.

-- Зоздадим две хеш таблицы со связками user -> email и email -> user и далее из эих таблиц запросим нужную информацию
-- HSET name_email Petrov p@mail.ru
-- HSET email_name p@mail.ru Petreov

-- HGET name_email Petrov
-- HGET email_name p@mail.ru

-- Задание3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

-- db.shop.insert({catalogs:'Процессоры'})
-- db.shop.insert({catalogs:'Материнские платы'})

-- db.shop.update({catalogs:'Процессоры'},
-- {$set{name:'Intel Core i3-8100',
	  -- discription:'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 
	  -- prise: 7890}
-- })

-- db.shop.update({catalogs:'Материнские платы'},
-- {$set{name:'MSI B250M GAMING PRO',
	  -- discription:'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 
	  -- prise: 5060}
-- })



HGET 



