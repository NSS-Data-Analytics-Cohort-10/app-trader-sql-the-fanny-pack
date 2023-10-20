SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

-- Review, Price, Avail n both stores


SELECT ROUND(AVG(CAST(review_count AS int)), 2)
FROM app_store_apps;
-- Average review count of app store apps

SELECT ROUND(AVG(CAST(review_count AS int)), 2)
FROM play_store_apps;
-- Average review count of play store apps

SELECT a.name, a.price, a.rating, p.price AS play_price, p.rating AS play_rating
FROM app_store_apps AS a
JOIN play_store_apps AS p
ON a.price = p.price
WHERE a.rating > 3.75 AND p.rating > 3.75
GROUP BY a.name, a.price, a.rating, p.price, p.rating;


-------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT(name), a.price as app_store_price, a.rating as app_store_rating,  p.rating as play_store_rating, p.price as play_store_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
WHERE p.rating > 4.4 AND a.rating > 4.4
AND a.review_count::numeric > 12892 AND p.review_count::numeric > 444152
ORDER BY name;
 
 -----------------------------------------------------------------------------------------------------
 
-- PRICE
--- Price between 0-1, app rader will purchase for $10000, otherwise purchase price will be * 1000

SELECT DISTINCT a.name, 
CASE
WHEN a.price::money < 1 THEN 10000
ELSE a.price * 10000
END AS app_store_price,
 a.rating AS app_store_rating,
 p.rating AS play_store_rating,
 p.price::money AS play_store_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p ON a.name = p.name
ORDER BY a.name;
