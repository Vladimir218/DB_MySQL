-- Урок 6.

-- Задание 1. Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).

-- кроме, как применения join, предложений по корректировке и улучшению нет.

-- Задание 2. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

-- под человеком будем понимать пользователя, который написал заданному пользователю максимальное количество сообщений

-- скрипт не отрабатывает если пользователи являются друзьями, но сообщениями не обмениваются. 
-- Прошу прислать правильный скрипт, который корректно будет отрабатывать в данной ситуации, 
-- т.е. выдавать сообщение, что полтельзователи не переписывется.

USE vk;

SELECT concat(first_name,' ', last_name) AS 'user with max masseges' FROM users 
WHERE Id= (
SELECT t1.from_user_id 
FROM 
	(SELECT from_user_id, count(*) AS masseges FROM messages m 
	WHERE 
		from_user_id IN(SELECT friend_id FROM friendships WHERE user_id = m.to_user_id) 
		AND 
		to_user_id = 10
	GROUP BY from_user_id
	ORDER BY masseges DESC
	LIMIT 1) 
AS t1);



-- Задание 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

-- группируем 10 самых молодых пользователей с лайками. После суммируем лайки.

SELECT sum(t1.quantity_likes) AS 'sum_likes' FROM 
(SELECT 
	l.user_id,
	(SELECT birthday FROM profiles p WHERE p.user_id=l.user_id) AS birthday,
	count(*) AS quantity_likes
FROM likes l 
GROUP BY l.user_id
ORDER BY birthday DESC
LIMIT 10) AS t1;


-- Задание 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT 
	IF ((SELECT gender FROM profiles p WHERE l.user_id = p.user_id) = 'f','женщина','мужчина' ) AS gender, 
	count(*) AS max_quantity  
FROM likes l 
GROUP BY gender 
ORDER BY max_quantity DESC
LIMIT 1;

-- Задание 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

-- мерой активности будем понимать общее количество:
-- 1 сообщений
-- 2 друзей
-- 3 лайков
-- 4 загруженных файлов
-- у одного пользователя


	SELECT user_id, count(*) AS activity
	FROM 
		(SELECT from_user_id AS user_id FROM messages
		UNION ALL 
		SELECT user_id FROM friendships f
		UNION ALL
		SELECT user_id FROM likes l
		UNION ALL 
		SELECT user_id FROM media m) AS t
	GROUP BY user_id
	ORDER BY activity
	LIMIT 10;







	