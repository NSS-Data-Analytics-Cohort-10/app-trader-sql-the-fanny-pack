-- App Trader
-- Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made available through the Apple App Store and Android Play Store. App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchase.

-- Unfortunately, the data for Apple App Store apps and Android Play Store Apps is located in separate tables with no referential integrity.

-- 1. Loading the data
-- a. Launch PgAdmin and create a new database called app_trader.

-- b. Right-click on the app_trader database and choose Restore...

-- c. Use the default values under the Restore Options tab.

-- d. In the Filename section, browse to the backup file app_store_backup.backup in the data folder of this repository.

-- e. Click Restore to load the database.

-- f. Verify that you have two tables:
-- - app_store_apps with 7197 rows
-- - play_store_apps with 10840 rows

-- 2. Assumptions
-- Based on research completed prior to launching App Trader as a company, you can assume the following:

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.

-- For example, an app that costs $2.00 will be purchased for $20,000.

-- The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores.

-- If an app is on both stores, its purchase price will be calculated based off of the highest app price between the two stores.

-- b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.

-- An app that costs $200,000 will make the same per month as an app that costs $1.00.

-- An app that is on both app stores will make $10,000 per month.

-- c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

-- An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, regardless of the number of stores it is in.

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.

-- App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.
-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

-- 3. Deliverables
-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

-- b. Develop a Top 10 List of the apps that App Trader should buy.

-- c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.

-- updated 2/18/2023

SELECT * 
FROM app_store_apps

SELECT * 
FROM play_store_apps


-- 9000 profit monthly combined with lifespan calculation based on rating to return a 'total profit' value and sort by/limit 10

-- INNER JOIN two tables
-- We're only including apps available in both app stores.
-- Casting both user price columns as money in this initial query as well.
SELECT DISTINCT
	(name),
	p.rating AS p_rating,
	a.rating AS a_rating,
	CAST(a.price AS MONEY) AS a_price,
	CAST(p.price AS MONEY) AS p_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name);

WITH life_span AS (
		SELECT 
		DISTINCT (p.name),
			(p.rating + a.rating + 1)
	FROM app_store_apps AS a
		INNER JOIN play_store_apps AS p
		USING (name)),
a_app_cost AS (
		SELECT 
		 	DISTINCT (p.name),
			a.price,
				CASE WHEN CAST (a.price AS MONEY) > CAST ('1' AS MONEY) THEN (CAST(a.price AS MONEY)*10000)
		ELSE CAST ('10000' AS MONEY)
	END AS a_app_cost
		FROM app_store_apps AS a
			INNER JOIN play_store_apps AS p
			USING (name)),
p_app_cost AS (
		SELECT 
	DISTINCT (p.name),		
	p.price,
			CASE WHEN CAST (p.price AS MONEY) > CAST ('1' AS MONEY) THEN (CAST(p.price AS MONEY)*10000)
		ELSE CAST ('10000' AS MONEY)
				END AS p_app_cost
		FROM app_store_apps AS a
		INNER JOIN play_store_apps AS p
		USING (name))
SELECT DISTINCT
	(a.name),
	primary_genre,
	CAST(p.price AS MONEY),
	a.content_rating,
	a.rating,
	life_span,
	p_app_cost,
	a_app_cost,
	CASE WHEN (a_app_cost > p_app_cost) THEN CAST(108000 * life_span AS MONEY) - a_app_cost
		ELSE CAST(life_span * 108000 AS MONEY) - p_app_cost
		END AS total_profit
FROM app_store_apps AS a
		INNER JOIN play_store_apps AS p
		USING (name)
		INNER JOIN life_span
		ON p.name = life_span.name
		INNER JOIN a_app_cost
		ON p.name = a_app_cost.name
		INNER JOIN p_app_cost
		ON p.name = p_app_cost.name
ORDER BY total_profit DESC;