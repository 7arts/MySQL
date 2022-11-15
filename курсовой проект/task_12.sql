-- Создаём БД
DROP DATABASE IF EXISTS kinopoisc;
CREATE DATABASE kinopoisc;

-- Делаем её текущей
USE kinopoisc;

-- Создаём таблицу пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  user_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  avatar_blob_id VARCHAR(250) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
) ;  

INSERT INTO users VALUES (1,'art','sshields@example.net', NULL, default, default),
(2,'mosc', 'lee.douglas@example.com', NULL, default, default),
(3,'top','valentine66@example.net', NULL, default, default),
(4,'boss','fiona92@example.com', NULL, default, default),
(5,'result','dcole@example.org', NULL, default, default),
(6,'frame','ankunding.marietta@example.net', NULL, default, default),
(7,'def','simonis.theron@example.org', NULL, default, default),
(8,'metr','morar.warren@example.com', NULL, default, default),
(9,'tor','pearlie85@example.org', NULL, default, default),
(10,'superman','allie.koelpin@example.com', NULL, default, default);


-- Таблица профилей
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,  
  phone VARCHAR(100) NOT NULL UNIQUE,
  gender ENUM ('m', 'f', 'n') DEFAULT 'n',
  birthday DATE,
  city VARCHAR(130),
  country VARCHAR(130),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO profiles VALUES (1,'Harry','Abramson','(343)711-4806', 'm','2014-06-23','Barnaul','Russia', default, default),
(2,'Oliver','Adamson','(343)711-4801', 'f','2011-03-20','Anapa','Russia', default, default),
(3,'Jack','Austin','(343)711-4836', default,'2016-06-23','	Veliky Ustyug','Russia', default, default),
(4,'Charlie','Bargeman','(343)711-4826', default,'2019-03-09','	Grozny','Russia', default, default),
(5,'Thomas','Clifford','(343)711-4839', 'f','2022-02-23','Dmitrov','Russia', default, default),
(6,'Alfie','Conors','(343)711-4847', default,'2017-08-16','Yeysk','Russia', default, default),
(7,'Riley','Cramer','(343)711-4898', 'm','1996-06-25','Zlatoust','Russia', default, default),
(8,'William','Douglas','(343)711-4406', default,'1978-11-27', 'Ivanovo','Russia', default, default),
(9,'James','Duncan','(343)711-4986', default,'2005-06-29','Kazan','Russia', default, default),
(10,'Reginald','Lind','(343)711-4984', default,'2009-07-03', 'Kaluga','Russia', default, default);


-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;


-- Таблица сообщений
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  from_user_id INT UNSIGNED NOT NULL,
  to_user_id INT UNSIGNED NOT NULL,
  body TEXT NOT NULL,
  is_delivered BOOLEAN,
  created_at DATETIME DEFAULT NOW()
);

INSERT INTO messages VALUES (1,1,10,'hi', '1', default),
(2,1,9,'hi', '1', default),
(3,1,7,'hi', '1', default),
(4,7,10,'hi', '0', default),
(5,7,1,'hi', '0', default),
(6,2,4,'hi', '0', default),
(7,10,1,'hi', '1', default),
(8,1,10,'how are you?', '1', default),
(9,10,1,'good', '1', default),
(10,10,1,'relaxing now', '0', default);

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);


-- Таблица дружбы
DROP TABLE IF EXISTS friendship;
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL,
  friend_id INT UNSIGNED NOT NULL,
  friendship_status_id INT UNSIGNED NOT NULL,
  confirmed_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
  PRIMARY KEY (user_id, friend_id)
);

INSERT INTO friendship VALUES (1,2,1,'2021-05-14 18:43:04',default,default),
(2,3,3,'2021-05-14 18:43:04',default,default),
(3,4,2,'2021-05-14 18:43:04',default,default),
(4,10,1,'2021-05-14 18:43:04',default,default),
(5,9,2,'2021-05-14 18:43:04',default,default),
(6,5,3,'2021-05-14 18:43:04',default,default),
(7,7,3,'2021-05-14 18:43:04',default,default),
(8,6,2,'2021-05-14 18:43:04',default,default),
(9,1,1,'2021-05-14 18:43:04',default,default),
(10,8,1,'2021-05-14 18:43:04',default,default);

-- Таблица статусов дружеских отношений
DROP TABLE IF EXISTS friendship_statuses;
CREATE TABLE friendship_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name ENUM ('Requested', 'Confirmed', 'Rejected') DEFAULT 'Requested',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
);

INSERT INTO friendship_statuses VALUES (1,'Requested',default, default),
(2,'Confirmed',default, default),
(3,'Rejected',default, default);

-- Добавляем внешние ключи
ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT friendship_status_id_fk 
    FOREIGN KEY (friendship_status_id) REFERENCES friendship_statuses(id)
      ON DELETE CASCADE;

-- Таблица фильмов
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  short_description VARCHAR(250) NOT NULL,
  release_date DATE NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO movies VALUES (1, 'The Lord of the Rings', 'This movie is so gripping. I watched it in one shot', '2003-10-04', default, default), 
(2, 'Interstellar', 'I recommend you to watch this film. It’s awesome', '2014-10-04', default, default), 
(3, 'Schindler’s List', 'It’s definitely worth being watched.', '1993-10-04', default, default), 
(4, 'Pulp Fiction', 'This movie is so gripping. I watched it in one shot', '1994-10-04', default, default), 
(5, 'Inception', 'It’s definitely worth being watched.', '2010-10-04', default, default), 
(6, 'Back to the Future', 'This movie is so gripping. I watched it in one shot', '1985-10-04', default, default), 
(7, 'The Matrix', 'It is well worth the watch.', '1999-10-04', default, default), 
(8, 'Snatch', 'This movie is so gripping. I watched it in one shot', '2000-10-04', default, default), 
(9, 'The Prestige', 'Action packed', '2006-10-04', default, default), 
(10, 'The Dark Knight', 'It is well worth the watch.', '2008-10-04', default, default);

-- Таблица Стран
DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  country VARCHAR(200) UNIQUE NOT NULL
);

INSERT INTO countries VALUES 
(1,'Austria'),
(2,'Azerbaijan'),
(3,'Russia'),
(4,'Bolivia'),
(5,'Brazil'),
(6,'Bulgaria'),
(7,'Colombia'),
(8,'Costa Rica'),
(9,'Cuba'),
(10,'Iceland');

-- Таблица связи стран и фильмов
CREATE TABLE countries_movies (
  country_id INT UNSIGNED NOT NULL,
  movie_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (country_id, movie_id)
);

INSERT INTO countries_movies VALUES (1,10,default),
(2,9, default),
(3,8,default),
(4,7,default),
(5,6,default),
(6,5,default),
(7,4,default),
(8,3,default),
(9,2,default),
(10,1,default);

-- Добавляем внешние ключи
ALTER TABLE countries_movies
  ADD CONSTRAINT countries_country_id_fk 
    FOREIGN KEY (country_id) REFERENCES countries(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT movies_movie_id_fk 
    FOREIGN KEY (movie_id) REFERENCES movies(id)
	  ON DELETE CASCADE;
	  
	  
-- Таблица жанров
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  genre VARCHAR(200) UNIQUE NOT NULL
);

INSERT INTO genres VALUES (1,'Romance comedy'),
(2,'sci-fi'),
(3,'Horror'),
(4,'fantasy'),
(5,'Documentary'),
(6,'animation'),
(7,'Action'),
(8,'Drama'),
(9,'Comedy'),
(10,'Adventure');

-- Таблица связи жанров и фильмов
CREATE TABLE genres_movies (
  genre_id INT UNSIGNED NOT NULL,
  movie_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (genre_id, movie_id)
);

INSERT INTO genres_movies VALUES (1,10,default),
(2,9,default),
(3,8,default),
(4,7,default),
(5,6,default),
(6,5,default),
(7,4,default),
(8,3,default),
(9,2,default),
(10,1,default);


-- Добавляем внешние ключи
ALTER TABLE genres_movies
  ADD CONSTRAINT genres_genre_id_fk 
    FOREIGN KEY (genre_id) REFERENCES genres(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT movies_genre_id_fk 
    FOREIGN KEY (movie_id) REFERENCES movies(id)
	  ON DELETE CASCADE;
	  
	  
-- Таблица актёров
DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,  
  birthday DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO actors VALUES (1,'Miller','Ritchie','2021-04-14', default, default),
(2,'Hal','Blick','2013-07-10', default, default),
(3,'Ludie','Mayer','2014-10-22',  default, default),
(4,'Angelo','Fadel','2021-04-14',  default, default),
(5,'Camron','Weimann','2021-04-14',  default, default),
(6,'Valentin','Schiller','2012-04-01',  default, default),
(7,'Unique','Becker','2018-09-22',  default, default),
(8,'Ashlynn','Collier','2021-04-14',  default, default),
(9,'Carley','Hoppe','2021-04-14',  default, default),
(10,'Mozell','Shields','2021-04-14', default, default);

-- Таблица связи актёров и фильмов
CREATE TABLE actors_movies (
  actor_id INT UNSIGNED NOT NULL,
  movie_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (actor_id, movie_id)
);

INSERT INTO actors_movies VALUES (1,10,default), 
(1,9,default),
(4,8,default),
(5,7,default),
(6,7,default),
(6,6,default),
(8,5,default),
(8,4,default),
(9,3,default),
(10,1,default);

-- Добавляем внешние ключи
ALTER TABLE actors_movies
  ADD CONSTRAINT actors_movies_actor_id_fk 
    FOREIGN KEY (actor_id) REFERENCES actors(id)
	  ON DELETE CASCADE,
  ADD CONSTRAINT actors_movies_movie_id_fk 
    FOREIGN KEY (movie_id) REFERENCES movies(id)
	  ON DELETE CASCADE;
	  

-- Таблица комментариев
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  movie_id INT UNSIGNED NOT NULL,   
  from_user_id INT UNSIGNED NOT NULL,
  to_user_id INT DEFAULT NULL,
  body TEXT NOT NULL,
  created_at DATETIME DEFAULT NOW() 
);

INSERT INTO comments VALUES (1,9,1,9, 'Goog', default),
(2,4,2,8,'Goog', default),
(3,3,3,7,'Well', default),
(4,5,5,6,'Cool', default),
(5,3,4,5,'Goog', default),
(6,7,7,4,'Well', default),
(7,6,6,3,'Beautiful', default),
(8,1,8,2,'Goog', default),
(9,2,2,1,'Goog', default),
(10,8,8,1,'Goog', default);

-- Добавляем внешние ключи
ALTER TABLE comments
  ADD CONSTRAINT comments_movie_id_to_id_fk 
    FOREIGN KEY (movie_id) REFERENCES movies(id),
  ADD CONSTRAINT comments_from_user_id_to_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id);

-- Фильмы по жанрам
SELECT
 movie_id as id,
 (SELECT title FROM movies m WHERE m.id = genres_movies.movie_id) as title,
 (SELECT genre FROM genres g WHERE g.id = genres_movies.genre_id) as genre
 FROM genres_movies;
 
-- Фильмы по актеры
SELECT
 movie_id as id,
 (SELECT title FROM movies m WHERE m.id =  actors_movies.movie_id) as title,
 (SELECT CONCAT(first_name, ' ', last_name) FROM actors a WHERE a.id = actors_movies.actor_id) as actor
 FROM actors_movies;
 
-- информация о пользователях
SELECT
  u.id,
  u.user_name,
  u.email,
  u.avatar_blob_id,
  CONCAT(p.first_name, ' ', p.last_name) AS name,
  p.birthday,
  p.city,
  p.phone
  FROM users AS u 
  JOIN profiles AS p ON u.id = p.user_id;
  
-- Кто и кому писались сообщения
SELECT 
  messages.from_user_id, 
  CONCAT(users_from.first_name, ' ', users_from.last_name) AS from_user,
  messages.to_user_id, 
  CONCAT(users_to.first_name, ' ', users_to.last_name) AS to_user,     
  messages.body, 
  messages.created_at
  FROM profiles
   JOIN messages
    ON profiles.user_id = messages.to_user_id OR profiles.user_id = messages.from_user_id
   JOIN profiles AS users_from
    ON users_from.user_id = messages.from_user_id
   JOIN profiles AS users_to
    ON users_to.user_id = messages.to_user_id
  WHERE profiles.user_id = 1;
  
  
CREATE OR REPLACE VIEW movies_view AS
SELECT id, title, short_description, release_date FROM movies;

CREATE OR REPLACE VIEW movies_genres_view AS
SELECT m.id, m.title, gm.genre_id, g.genre 
  FROM movies m
   LEFT JOIN genres_movies AS gm ON m.id = gm.movie_id
   LEFT JOIN genres AS g ON g.id = gm.genre_id;

CREATE OR REPLACE VIEW movies_actors_view AS
SELECT m.id, m.title, am.actor_id, CONCAT(a.first_name, ' ', a.last_name) as actor 
  FROM movies m
   LEFT JOIN actors_movies AS am ON m.id = am.movie_id
   LEFT JOIN actors AS a ON a.id = am.actor_id;
    
-- Проверка имени и фамилии актера
DELIMITER //
CREATE TRIGGER validate_actors_first_name_last_name_insert BEFORE INSERT ON actors
FOR EACH ROW BEGIN
  IF NEW.first_name IS NULL AND NEW.last_name IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both fist name and last name are NULL';
  END IF;
END//