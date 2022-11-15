use kinopoisc;

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