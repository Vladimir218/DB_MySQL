-- Урок 4. Задание1. В рамках задания повторил все операции с таблицами, которые были на 
-- лекции и создал таблицы стран и городов

-- DROP DATABASE IF exists vk;
-- CREATE DATABASE vk;

USE vk;
SHOW tables;
SELECT * FROM users LIMIT 10;
DESC users;
-- изменение даты updated в таблице users, где updated_at < created_at
UPDATE users SET updated_at = now() WHERE updated_at < created_at;

SELECT * FROM profiles LIMIT 10;

CREATE TEMPORARY TABLE genders (name char(1));
INSERT genders(name) VALUES ('m'), ('f');
SELECT * FROM genders;

-- дозополняем пустые ячейки в таблице profiles в поле gender 
UPDATE profiles SET gender =(SELECT name FROM genders ORDER BY rand() LIMIT 1) WHERE gender = '';

CREATE TABLE user_status(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
	name VARCHAR(100) NOT NULL UNIQUE COMMENT 'название статуса (уникально)',
	create_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Справочник статусов';

INSERT INTO user_status (name) VALUES
	('single'),
	('married');

SELECT * FROM user_status;

UPDATE profiles SET status = NULL;

SELECT * FROM profiles LIMIT 10;

-- переименовываем столбец, изменяем тип данных в нем и заполняем данными id из таблицы user_status
ALTER TABLE profiles RENAME COLUMN status TO user_status_id;
ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED; 
UPDATE profiles SET user_status_id =(SELECT id FROM user_status ORDER BY rand() LIMIT 1);

-- создание справочника стран и в таблице profile создание столбца с id стран

UPDATE profiles SET country = NULL;
CREATE TABLE country(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор страны',
	name VARCHAR(100) NOT NULL UNIQUE COMMENT 'название страны (уникально)',
	create_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Справочник стран';

INSERT country (name) VALUES 
	('RUSSIA'),
	('UKRAIN'),
	('BELARUS'),
	('POLAND'),
	('MONGOLIA'),
	('USA'),
	('GARMANY'),
	('CHINA');

CREATE TABLE city(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор города',
	name VARCHAR(100) NOT NULL UNIQUE COMMENT 'название города (уникально)',
	country_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор страны',
	create_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Справочник городов';

INSERT country (name) VALUES 
	('RUSSIA'),
	('UKRAIN'),
	('BELARUS'),
	('POLAND'),
	('MONGOLIA'),
	('USA'),
	('GARMANY'),
	('CHINA');

INSERT city (name, country_id) VALUES 
	('Moscow',1),
	('Smolensk',1),
	('Kirov',1),
	('Kiev',2),
	('Odessa',2),
	('Lviv',2),
	('Kherson',2),
	('Gomel',3),
	('Grodno',3),
	('Minsk',3),
	('Warsaw',4),
	('Krakow',4),
	('Gdansk',4),
	('Ulanbator',5),
	('Nalayh',5),
	('Aerdenet',5),
	('Washington',6),
	('Chicago',6),
	('Dalos',6),
	('Berlin',7),
	('Munich',7),
	('Hamburg',7),
	('Beijin',8),
	('Shenzen',8);


ALTER TABLE profiles RENAME COLUMN country TO country_id;
ALTER TABLE profiles MODIFY COLUMN country_id INT UNSIGNED;
UPDATE profiles SET country_id =(SELECT id FROM country ORDER BY rand() LIMIT 1);

UPDATE profiles SET city = NULL;
SELECT * FROM city;
SELECT * FROM profiles; 

ALTER TABLE profiles RENAME COLUMN city TO city_id;
ALTER TABLE profiles MODIFY COLUMN city_id INT UNSIGNED;

-- Выбор случайного id города по id страны из таблицы profiles
UPDATE profiles p SET p.city_id = (SELECT c.id FROM city c WHERE c.country_id = p.country_id ORDER BY rand() LIMIT 1);
DESC messages 

ALTER TABLE messages ADD COLUMN media_id INT UNSIGNED AFTER body;
SELECT * FROM messages LIMIT 10;
UPDATE messages SET 
from_user_id =FLOOR(1+rand()*100),
to_user_id = floor(1+rand()*100),
media_id = floor(1+rand()*100);

SELECT * FROM media m LIMIT 10;

UPDATE media SET 
user_id =FLOOR(1+rand()*100),
media_type_id = floor(1+rand()*100),
`size` = floor(1000+100000*rand()) WHERE `size` < 1000;



CREATE TEMPORARY TABLE extention (name VARCHAR(10));
INSERT INTO extention VALUES ('jpeg'),('avi'),('mp3'),('png');
UPDATE media SET filename = CONCAT(
	'c:/user/', filename, '.',
	(SELECT name FROM extention LIMIT 1)
);

UPDATE media SET metadata = CONCAT('{"owner":"',(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id) ,'"}'); 

ALTER TABLE media MODIFY COLUMN metadata JSON;

SELECT * FROM media_types;
DELETE FROM media_types;
INSERT INTO media_types (name) VALUES
('photo'),
('video'),
('audio');

truncate media_types;
INSERT INTO media_types SET name ='photo', id =NULL;

SELECT * FROM media LIMIT 10;

UPDATE media SET media_type_id = FLOOR(1 + RAND()*3);

SELECT * FROM friendship LIMIT 10;
/*!40000 ALTER TABLE friendship DISABLE KEYS */;
UPDATE friendship SET
user_id = FLOOR(1+RAND()*100),
friend_id = FLOOR(1+RAND()*100);

UPDATE friendship SET
friend_id = friend_id + 1 WHERE user_id = friend_id;
/*!40000 ALTER TABLE friendship ENABLE KEYS */;

SELECT * FROM friendship_statuses;
TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name) VALUES
('REQUESTED'),
('CONFIRMED'),
('REJECTED');

INSERT IGNORE INTO friendship_statuses (name) VALUES
('REQUESTED'),
('CONFIRMED'),
('REJECTED');

INSERT INTO friendship_statuses (id, name) VALUES
(1, 'REQUESTED1'),
(2, 'CONFIRMED1'),
(3, 'REJECTED1')
ON DUPLICATE KEY UPDATE name = VALUES (name);


UPDATE friendship SET status_id = FLOOR(1 + RAND()*3);


SELECT * FROM communities;

DELETE FROM communities WHERE id > 20;

SELECT * FROM communities_users;

UPDATE communities_users SET community_id = FLOOR (1 + RAND()*20);

CREATE TABLE friendship_statuses_new LIKE friendship_statuses;

SELECT * FROM friendship_statuses_new;

INSERT INTO friendship_statuses_new (id, name) SELECT id,name FROM friendship_statuses;

SHOW CREATE TABLE friendship_statuses;


