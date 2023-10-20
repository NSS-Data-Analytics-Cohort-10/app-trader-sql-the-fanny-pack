select *
from app_store_apps

select *
from play_store_apps

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


