CREATE DATABASE music_store;
USE music_store;


-- genre
CREATE TABLE genre (
    genre_id INT PRIMARY KEY,
    name VARCHAR(120)
);

-- media type
CREATE TABLE media_type (
    media_type_id INT PRIMARY KEY,
    name VARCHAR(120)
);

-- employee
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(120),
    first_name VARCHAR(120),
    title VARCHAR(120),
    reports_to INT,
    levels VARCHAR(10),
    birthdate DATE,
    hire_date DATE,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(100),
    FOREIGN KEY (reports_to) REFERENCES employee(employee_id)
);

-- customer
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(120),
    last_name VARCHAR(120),
    company VARCHAR(120),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(100),
    support_rep_id INT,
    FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id)
);

-- artist
CREATE TABLE artist (
    artist_id INT PRIMARY KEY,
    name VARCHAR(120)
);

-- album
CREATE TABLE album (
    album_id INT PRIMARY KEY,
    title VARCHAR(160),
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

-- track
CREATE TABLE track (
    track_id INT PRIMARY KEY,
    name VARCHAR(200),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (album_id) REFERENCES album(album_id),
    FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id),
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);

-- invoice
CREATE TABLE invoice (
    invoice_id INT PRIMARY KEY,
    customer_id INT,
    invoice_date DATE,
    billing_address VARCHAR(255),
    billing_city VARCHAR(100),
    billing_state VARCHAR(100),
    billing_country VARCHAR(100),
    billing_postal_code VARCHAR(20),
    total DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- invoice line
CREATE TABLE invoice_line (
    invoice_line_id INT PRIMARY KEY,
    invoice_id INT,
    track_id INT,
    unit_price DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (track_id) REFERENCES track(track_id)
);

-- playlist
CREATE TABLE playlist (
    playlist_id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- playlist track
CREATE TABLE playlist_track (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
    FOREIGN KEY (track_id) REFERENCES track(track_id)
);


USE music_store;
SELECT * FROM genre;
SELECT * FROM media_type;
SELECT * FROM employee;
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM artist;
SELECT COUNT(*) FROM album;
SELECT COUNT(*) FROM track;
SELECT * FROM invoice;
SELECT COUNT(*) FROM invoice_line;
SELECT COUNT(*) FROM playlist;
SELECT COUNT(*) FROM playlist_track;

-- 1) Who is the senior most employee based on job title? --

SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;


-- 2) Which countries have the most invoices? --

SELECT billing_country,
       COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;


-- 3) What are the top 3 values of total invoice? --

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;


-- 4) Which city has the best customers?
-- We would like to throw a promotional Music Festival in the city
-- we made the most money. Write a query that returns one city
-- that has the highest sum of invoice totals.
-- Return both the city name & sum of all invoice totals.

SELECT billing_city AS city,
       SUM(total) AS total_invoice_amount
FROM invoice
GROUP BY billing_city
ORDER BY total_invoice_amount DESC
LIMIT 1;


-- 5) Who is the best customer?
-- The customer who has spent the most money will be declared
-- the best customer. Write a query that returns the person
-- who has spent the most money.

SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id,
         c.first_name,
         c.last_name
ORDER BY total_spent DESC
LIMIT 1;


-- 6) Write a query to return the email, first name, last name,
-- and Genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email.

SELECT DISTINCT
       c.email,
       c.first_name,
       c.last_name,
       g.name AS genre
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;


-- 7) Let's invite the artists who have written the most rock music
-- in our dataset.
-- Write a query that returns the Artist name and total track count
-- of the top 10 rock bands.

SELECT a.name AS artist_name,
       COUNT(t.track_id) AS total_tracks
FROM artist a
JOIN album al
    ON a.artist_id = al.artist_id
JOIN track t
    ON al.album_id = t.album_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id,
         a.name
ORDER BY total_tracks DESC
LIMIT 10;


-- 8) Return all the track names that have a song length longer
-- than the average song length.
-- Return the Name and Milliseconds for each track.
-- Order by the song length, with the longest songs listed first.

SELECT name,
       milliseconds
FROM track
WHERE milliseconds >
      (SELECT AVG(milliseconds)
       FROM track)
ORDER BY milliseconds DESC;


-- 9) Find how much amount is spent by each customer on artists.
-- Write a query to return customer name, artist name and total spent.

SELECT c.first_name,
       c.last_name,
       a.name AS artist_name,
       SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN album al
    ON t.album_id = al.album_id
JOIN artist a
    ON al.artist_id = a.artist_id
GROUP BY c.customer_id,
         c.first_name,
         c.last_name,
         a.artist_id,
         a.name
ORDER BY total_spent DESC;


-- 10) We want to find out the most popular music Genre for each country.
-- We determine the most popular genre as the genre with the highest
-- number of purchases.
-- Write a query that returns each country along with the top Genre.
-- For countries where the maximum number of purchases is shared,
-- return all Genres.

WITH country_genre AS (
    SELECT i.billing_country AS country,
           g.name AS genre,
           COUNT(*) AS purchases
    FROM invoice i
    JOIN invoice_line il
        ON i.invoice_id = il.invoice_id
    JOIN track t
        ON il.track_id = t.track_id
    JOIN genre g
        ON t.genre_id = g.genre_id
    GROUP BY i.billing_country,
             g.name
),
ranked AS (
    SELECT country,
           genre,
           purchases,
           DENSE_RANK() OVER (
               PARTITION BY country
               ORDER BY purchases DESC
           ) AS rk
    FROM country_genre
)
SELECT country,
       genre,
       purchases
FROM ranked
WHERE rk = 1
ORDER BY country;


-- 11) Write a query that determines the customer that has spent
-- the most on music for each country.
-- Write a query that returns the country along with the top customer
-- and how much they spent.
-- For countries where the top amount spent is shared,
-- provide all customers who spent this amount.

WITH country_customer AS (
    SELECT i.billing_country AS country,
           c.customer_id,
           c.first_name,
           c.last_name,
           SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i
        ON c.customer_id = i.customer_id
    GROUP BY i.billing_country,
             c.customer_id,
             c.first_name,
             c.last_name
),
ranked AS (
    SELECT country,
           customer_id,
           first_name,
           last_name,
           total_spent,
           DENSE_RANK() OVER (
               PARTITION BY country
               ORDER BY total_spent DESC
           ) AS rk
    FROM country_customer
)
SELECT country,
       first_name,
       last_name,
       total_spent
FROM ranked
WHERE rk = 1
ORDER BY country;