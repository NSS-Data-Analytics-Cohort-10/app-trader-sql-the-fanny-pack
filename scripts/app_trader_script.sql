-- Based on research completed prior to launching App Trader as a company, you can assume the following:

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.

-- - For example, an app that costs $2.00 will be purchased for $20,000.

-- - The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores. 

-- - If an app is on both stores, it's purchase price will be calculated based off of the highest app price between the two stores. 

-- b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.

-- - An app that costs $200,000 will make the same per month as an app that costs $1.00. 

-- - An app that is on both app stores will make $10,000 per month. 

-- c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

-- - An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, regardless of the number of stores it is in.

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.

-- - App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.

-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

--Selection:

SELECT *
FROM app_store_apps
ORDER BY name;

SELECT DISTINCT(name)
FROM play_store_apps
ORDER BY name;

SELECT *
FROM app_store_apps as a_s
INNER JOIN play_store_apps as p_s
USING(name)
ORDER BY name;

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price
FROM app_store_apps as a_s
INNER JOIN play_store_apps as p_s
USING(name)
ORDER BY name;

-- Price:

-- If price for user to purchase app is between 0 and 1, cost for AppTrader is 10000.
-- Otherwise, cost is price for user * 10000

-- IF criteria otherwise thing postgresql

-- IF(price < 1, 10000, 10000 * price)

-- CASE 1 (price < 1): 10000
-- CASE 2 (price > 1): price * 10000

-- WHEN (price < 1) THEN 10000
-- ELSE price * 10000


SELECT name, price, 
CASE 
WHEN CAST(price AS MONEY) < CAST('1' AS MONEY) THEN CAST(10000 AS MONEY)
ELSE (CAST(price AS MONEY)*10000)
END cost
FROM app_store_apps
ORDER BY price DESC;

SELECT name, CAST(price AS MONEY), review_count,
CASE 
WHEN CAST(price AS MONEY) < CAST('1' AS MONEY) THEN CAST(10000 AS MONEY)
ELSE (CAST(price AS MONEY)*10000)
END cost
FROM play_store_apps
ORDER BY price DESC;

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
CASE 
WHEN GREATEST(a_s.price::money,p_s.price::money) < 1::money THEN 10000::money
ELSE (GREATEST(a_s.price::money,p_s.price::money)*10000)::money
END cost
FROM app_store_apps as a_s
INNER JOIN play_store_apps as p_s
USING(name)
ORDER BY name;

-- Years

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
ROUND((p_s.rating+a_s.rating)+1) as years --ROUND(((average)*2)+1)
FROM app_store_apps as a_s
INNER JOIN play_store_apps as p_s
USING(name)
ORDER BY name;



-- 4.8 3.2 
-- y=(2x+1)
-- y=(2(a+b/2)+1)
-- y=(a+b+1)


-- Total Revenue
 
SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
CASE 
WHEN GREATEST(a_s.price::money,p_s.price::money) < 1::money THEN ((ROUND((p_s.rating+a_s.rating)+1)*12*9000)-10000)::money
ELSE (ROUND((p_s.rating+a_s.rating)+1)*12*9000)::money-(GREATEST(a_s.price::money,p_s.price::money)*10000)::money
END total_profit
FROM app_store_apps as a_s
INNER JOIN play_store_apps as p_s
USING(name)
ORDER BY total_profit DESC, name ASC
LIMIT 10;


