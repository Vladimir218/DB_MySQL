-- Задание №1
-- Предложения:
-- объединить таблицы users и prifile (в Дз не реализовывал)
-- создать вторичный ключ для photo_id (profile) к id (media)
-- создать таблицу постов

-- Задание №2
-- создал таблицы:  post, like
-- создал внешний ключ для photo_id (profile) к id (media)


DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
	last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
	email VARCHAR(100) NOT NULL UNIQUE,
	phone VARCHAR(100) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

CREATE TABLE post (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автора поста",
	body TEXT NOT NULL COMMENT "Текст сообщения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
	to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения ",
	body TEXT NOT NULL COMMENT "Текст сообщения",
	is_importent BOOLEAN COMMENT "Признак важности",
	is_delivered BOOLEAN COMMENT "Признак доставки", 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE friendship_status (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"	
) COMMENT "Статус дружбы";

CREATE TABLE friendship (
	user_id INT UNSIGNED NOT NULL COMMENT "Сcылка на инициатора дружеских отношений",
	friend_id INT UNSIGNED NOT NULL COMMENT "Сcылка на получателя приглашения дружить",
	status_id INT UNSIGNED NOT NULL COMMENT "Сcылка на на статус отношений",
	requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
    confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    PRIMARY KEY (user_id,friend_id) COMMENT "Составной первичный ключ",
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (friend_id) REFERENCES users(id),
	FOREIGN KEY (status_id) REFERENCES friendship_status(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE communities(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",	
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Группы";

CREATE TABLE communities_users(
	community_id INT UNSIGNED NOT NULL COMMENT "Сcылка на группу",
	user_id INT UNSIGNED NOT NULL COMMENT "Сcылка на пользователя",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	PRIMARY KEY (community_id,user_id) COMMENT "Составной первичный ключ",
	FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE media_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название типа",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

CREATE TABLE media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",	
	user_id INT UNSIGNED NOT NULL COMMENT "Сcылка на пользователя, который загрузил файл",
	file_name VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
	metadata JSON COMMENT "Мета данные файла",
	media_type_id INT UNSIGNED NOT NULL COMMENT "Сcылка на тип контента",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)  
) COMMENT "Медиафайлы";

CREATE TABLE profile (
	user_id INT UNSIGNED NOT NULL PRIMARY KEY,
	gender CHAR(1) NOT NULL,
	birthday DATE,
	photo_id INT UNSIGNED,
	status VARCHAR(30),
	city VARCHAR(130),
	country VARCHAR(130),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  	FOREIGN KEY (photo_id) REFERENCES media(id) ON UPDATE CASCADE
) COMMENT "Профили";

CREATE TABLE type_like (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
	name VARCHAR(130) NOT NULL COMMENT "пост, пользователь, медиафайлы",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы лайков";

CREATE TABLE `like` (
	id_type_like INT UNSIGNED NOT NULL,
	id_object INT UNSIGNED NOT NULL COMMENT "ID объекта заданного типа лайк, например, id post, id user, id photo",
	quantity INT COMMENT "Количество лайков",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    PRIMARY KEY (id_type_like,id_object) COMMENT "Составной первичный ключ",
    FOREIGN KEY (id_type_like) REFERENCES type_like(id) ON UPDATE CASCADE
) COMMENT "Лайки";



