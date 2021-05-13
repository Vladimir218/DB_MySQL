-- ������� �1
-- �����������:
-- ���������� ������� users � prifile (� �� �� ������������)
-- ������� ��������� ���� ��� photo_id (profile) � id (media)
-- ������� ������� ������

-- ������� �2
-- ������ �������:  post, like
-- ������ ������� ���� ��� photo_id (profile) � id (media)


DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	first_name VARCHAR(100) NOT NULL COMMENT "��� ������������",
	last_name VARCHAR(100) NOT NULL COMMENT "������� ������������",
	email VARCHAR(100) NOT NULL UNIQUE,
	phone VARCHAR(100) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
);

CREATE TABLE post (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������ �����",
	body TEXT NOT NULL COMMENT "����� ���������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	from_user_id INT UNSIGNED NOT NULL COMMENT "������ �� ����������� ���������",
	to_user_id INT UNSIGNED NOT NULL COMMENT "������ �� ���������� ��������� ",
	body TEXT NOT NULL COMMENT "����� ���������",
	is_importent BOOLEAN COMMENT "������� ��������",
	is_delivered BOOLEAN COMMENT "������� ��������", 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE friendship_status (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "�������� �������",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"	
) COMMENT "������ ������";

CREATE TABLE friendship (
	user_id INT UNSIGNED NOT NULL COMMENT "�c���� �� ���������� ��������� ���������",
	friend_id INT UNSIGNED NOT NULL COMMENT "�c���� �� ���������� ����������� �������",
	status_id INT UNSIGNED NOT NULL COMMENT "�c���� �� �� ������ ���������",
	requested_at DATETIME DEFAULT NOW() COMMENT "����� ����������� ����������� �������",
    confirmed_at DATETIME COMMENT "����� ������������� �����������",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
    PRIMARY KEY (user_id,friend_id) COMMENT "��������� ��������� ����",
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (friend_id) REFERENCES users(id),
	FOREIGN KEY (status_id) REFERENCES friendship_status(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE communities(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",	
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "�������� ������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������";

CREATE TABLE communities_users(
	community_id INT UNSIGNED NOT NULL COMMENT "�c���� �� ������",
	user_id INT UNSIGNED NOT NULL COMMENT "�c���� �� ������������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
	PRIMARY KEY (community_id,user_id) COMMENT "��������� ��������� ����",
	FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE media_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "�������� ����",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "���� �����������";

CREATE TABLE media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",	
	user_id INT UNSIGNED NOT NULL COMMENT "�c���� �� ������������, ������� �������� ����",
	file_name VARCHAR(255) NOT NULL COMMENT "���� � �����",
	metadata JSON COMMENT "���� ������ �����",
	media_type_id INT UNSIGNED NOT NULL COMMENT "�c���� �� ��� ��������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)  
) COMMENT "����������";

CREATE TABLE profile (
	user_id INT UNSIGNED NOT NULL PRIMARY KEY,
	gender CHAR(1) NOT NULL,
	birthday DATE,
	photo_id INT UNSIGNED,
	status VARCHAR(30),
	city VARCHAR(130),
	country VARCHAR(130),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
  	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  	FOREIGN KEY (photo_id) REFERENCES media(id) ON UPDATE CASCADE
) COMMENT "�������";

CREATE TABLE type_like (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
	name VARCHAR(130) NOT NULL COMMENT "����, ������������, ����������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "���� ������";

CREATE TABLE `like` (
	id_type_like INT UNSIGNED NOT NULL,
	id_object INT UNSIGNED NOT NULL COMMENT "ID ������� ��������� ���� ����, ��������, id post, id user, id photo",
	quantity INT COMMENT "���������� ������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",
    PRIMARY KEY (id_type_like,id_object) COMMENT "��������� ��������� ����",
    FOREIGN KEY (id_type_like) REFERENCES type_like(id) ON UPDATE CASCADE
) COMMENT "�����";



