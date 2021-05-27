
-- Урок 7.

-- Задание1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

USE shop;


INSERT INTO orders (user_id) VALUES
  (1),
  (1),
  (4),
  (6),
  (6),
  (6);


SELECT * FROM orders;

SELECT users.name AS name
FROM users INNER JOIN orders
ON users.id=orders.user_id 
GROUP BY name;



-- Задание2.Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT * FROM products;
SELECT * FROM catalogs;

SELECT p.name AS name, c.name AS catalog 
FROM products p JOIN catalogs c 
ON p.catalog_id = c.id;


-- Задание3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.


-- Создаем базу данных и таблицы
CREATE DATABASE flights;
USE flights;

CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'город вылета', 
  `to` VARCHAR(255) COMMENT 'город ghbktnf'
 ) COMMENT = 'Таблица рейсов';

INSERT INTO flights (`from`, `to`) VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');
 
 SELECT * FROM flights f;

CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT 'название города на английском',
  name VARCHAR(255) COMMENT 'название города на русском'
 ) COMMENT = 'Таблица городов';

INSERT INTO cities (label, name) VALUES
  ('moscow', 'Москва'),
  ('novgorod', 'Новгород'),
  ('irkutsk', 'Иркутск'),
  ('omsk', 'Омск'),
  ('kazan', 'Казань');
 
 SELECT * FROM cities;

-- перевод рейсов

SELECT c.name AS `from`,c1.name AS `to`
FROM 
flights f 
JOIN cities c ON f.`from` = c.label
JOIN cities c1 ON f.`to` = c1.label;








