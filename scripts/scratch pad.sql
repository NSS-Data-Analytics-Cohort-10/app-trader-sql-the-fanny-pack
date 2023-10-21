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
 
-- (a). App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000. (pric))
--- Price between 0-1, app rader will purchase for $10000, otherwise purchase price will be * 1000
SELECT DISTINCT a.name, 
	CASE
	WHEN a.price::numeric < 1 THEN '10000'::money
	ELSE a.price::money * 10000
    END AS app_store_price,
	a.rating AS app_store_rating,
    p.rating AS play_store_rating,
    p.price::money AS play_store_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p 
ON a.name = p.name
ORDER BY a.name;

-- (b) Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.


-- (c) If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month


-- (d) For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.


-- (e) App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.
