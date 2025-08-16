-- 1) Basic SELECT
SELECT movie_id, title, year FROM movies;

-- 2) Filtering (WHERE)
SELECT title, year
FROM movies
WHERE year >= 2010;

-- 3) Sorting (ORDER BY)
SELECT title, year
FROM movies
ORDER BY year DESC
LIMIT 5;

-- 4) Simple text search (ILIKE for case-insensitive)
SELECT title, year
FROM movies
WHERE title ILIKE '%the%';

-- 5) Basic aggregation example:
-- Let's count by the "first" genre (before first pipe)
SELECT split_part(genres, '|', 1) AS first_genre,
       COUNT(*) AS movie_count
FROM movies
GROUP BY first_genre
ORDER BY movie_count DESC;

CREATE TABLE IF NOT EXISTS ratings (
  rating_id SERIAL PRIMARY KEY,
  movie_id INT REFERENCES movies(movie_id),
  user_id INT,
  rating NUMERIC(2,1), -- e.g., 3.5
  rated_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO ratings (movie_id, user_id, rating) VALUES
(1, 101, 5.0),
(1, 102, 4.5),
(3, 201, 4.8),
(4, 202, 4.2),
(4, 203, 4.6);

-- JOIN example: average rating per movie (only those with ratings)
SELECT m.title,
       ROUND(AVG(r.rating)::numeric, 2) AS avg_rating,
       COUNT(r.rating) AS num_ratings
FROM movies m
JOIN ratings r ON r.movie_id = m.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC;
