select *
from app_store_apps

select *
from play_store_apps

--makes sense to grab apps that are only in both stores to maximize profits for App Trader


-- how to achieve the price for these companies
SELECT name, CAST(price as money),
CASE
WHEN CAST(price as money) < cast('1' as money) THEN CAST(10000 as money)
END cost
FROM play_store_apps
ORDER BY price DESC;

SELECT name, CAST(price as money),
CASE
WHEN CAST(price as money) < cast('1' as money) THEN CAST(10000 as money)
END cost
FROM app_store_apps
ORDER BY price DESC;

-- finding the price for both PLAY STORE and APP STORE

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
CASE
WHEN GREATEST(a_s.price::money::numeric,p_s.price::money::numeric::int) < 1 THEN 10000
ELSE GREATEST(a_s.price::money::numeric,p_s.price::money::numeric)*10000
END cost
FROM app_store_apps as a_s
INNER JOIN play_store_apps as p_s
USING (name)
ORDER BY name;

-- used case statement to help single out best prices for both of the app companies using GREATEST and CAST shortcuts

-- how to get longevity of the top apps with ratings

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
ROUND(((p_s.rating+a_s.rating)/2)*2)+1 as years
--this above line is just the average of each app's rating (since each app is in BOTH app stores) multiplied it by two for the app being used twice, and adding one since even an app with 0.0 as the average rating will still have a lifespan of at least 1 year.
FROM app_store_apps as a_s 
INNER JOIN play_store_apps as p_s
USING(name)
ORDER BY name;


-- full query, group assisted. playing with the query to see what changes 

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
CASE
WHEN GREATEST(a_s.price::money,p_s.price::money) < 1::money THEN ((ROUND((p_s.rating+a_s.rating)+1)*12*9000)-10000)::money
ELSE (ROUND((p_s.rating+a_s.rating)+1)*12*9000)::money-(GREATEST(a_s.price::money,p_s.price::money)*10000)::money
END total_profit
FROM app_store_apps as a_s
INNER JOIN play_store_apps as p_s
USING(name)
ORDER BY total_profit DESC, name ASC
LIMIT 200;
-- extended limit past ten to see where past the frontrunning 6 apps there is a tie of total revenue... which is at 1.07 million

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
CASE
WHEN GREATEST(a_s.price::money,p_s.price::money) < 1::money THEN ((ROUND((p_s.rating+a_s.rating)+1)*12*9000)-10000)::money
ELSE (ROUND((p_s.rating+a_s.rating)+1)*12*9000)::money-(GREATEST(a_s.price::money,p_s.price::money)*10000)::money
END total_profit
FROM app_store_apps as a_s
FULL JOIN play_store_apps as p_s
USING(name)
ORDER BY total_profit DESC, name ASC
LIMIT 10;

SELECT DISTINCT(name), a_s.price as a_price, a_s.rating as a_rating, p_s.rating as p_rating, p_s.price as p_price,
CASE
WHEN GREATEST(a_s.price::money,p_s.price::money) < 1::money THEN ((ROUND((p_s.rating+a_s.rating)+1)*12*9000)-10000)::money
ELSE (ROUND((p_s.rating+a_s.rating)+1)*12*9000)::money-(GREATEST(a_s.price::money,p_s.price::money)*10000)::money
END total_profit
FROM app_store_apps as a_s
LEFT JOIN play_store_apps as p_s
USING(name)
ORDER BY total_profit DESC, name ASC
LIMIT 10;










