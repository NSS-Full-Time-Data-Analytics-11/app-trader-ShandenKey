--a. Develop some general recommendations about the price range, genre, content rating, 
  --or any other app characteristics that the company should target.
  --** low to no cost apps in Games for all ages
 
--b. Develop a Top 10 List of the apps that App Trader should buy based on 
	--profitability/return on investment as the sole priority.
	--**find 10 highest rated(both) & lowest priced (in ASA) with high review count(both)
WITH larg_avg_rating AS (SELECT  name, AVG(psa.rating + asa.rating)/2 AS avg_rating
						FROM play_store_apps AS psa 
						INNER JOIN app_store_apps AS asa USING(name)
						GROUP BY name)
SELECT name, asa.price, avg_rating
FROM larg_avg_rating INNER JOIN app_store_apps AS asa USING(name)
WHERE asa.price < '3.99'
GROUP BY name, asa.price, larg_avg_rating.avg_rating
ORDER BY avg_rating DESC 
LIMIT 10;
---price point change & adding review counts--
WITH larg_avg_rating AS (SELECT  name, AVG(psa.rating + asa.rating)/2 AS avg_rating
						FROM play_store_apps AS psa 
						INNER JOIN app_store_apps AS asa USING(name)
						GROUP BY name)
SELECT name, asa.price, avg_rating
FROM larg_avg_rating INNER JOIN app_store_apps AS asa USING(name)
WHERE asa.price < '5.99' 
GROUP BY name, asa.price, larg_avg_rating.avg_rating, asa.review_count
HAVING asa.review_count::numeric > (SELECT ROUND(AVG(review_count::numeric),2)
							FROM app_store_apps)
ORDER BY asa.price DESC
LIMIT 10;
		   

--c. Develop a Top 4 list of the apps that App Trader should buy that are profitable 
  --but that also are thematically appropriate for the upcoming Halloween themed campaign.
  --**use last query w/o LIMIT and look through names to pick
		   
WITH larg_avg_rating AS (SELECT  name, AVG(psa.rating + asa.rating)/2 AS avg_rating
						FROM play_store_apps AS psa 
						INNER JOIN app_store_apps AS asa USING(name)
						GROUP BY name)
SELECT name, asa.price, avg_rating
FROM larg_avg_rating INNER JOIN app_store_apps AS asa USING(name)
WHERE asa.price < '5.99' 
GROUP BY name, asa.price, larg_avg_rating.avg_rating, asa.review_count
HAVING asa.review_count::numeric > (SELECT ROUND(AVG(review_count::numeric),2)
							FROM app_store_apps)
ORDER BY asa.price, avg_rating DESC;
	--Zombie Catchers, Zombie Tsunami, Plants vs Zombies, Swamp Attack



--ALL MY FIGURINGS--
SELECT * FROM app_store_apps
SELECT DISTINCT primary_genre FROM app_store_apps  WHERE AVG(rating) >4

SELECT RANK() OVER (PARTITION BY genres ORDER BY price DESC), name, price
FROM play_store_apps 
SELECT DISTINCT primary_genre, RANK() OVER (PARTITION BY primary_genre ORDER BY price ), name, price
FROM app_store_apps 

--averaging reviews(combining the ratings columns) 328 GAMES
SELECT  name, AVG(psa.rating + asa.rating )/2 AS avg_rating
FROM play_store_apps AS psa 
		INNER JOIN app_store_apps AS asa USING(name)
		GROUP BY name
--ratings counts
SELECT  name, COUNT(psa.review_count::integer + asa.review_count::integer)
FROM play_store_apps AS psa 
		INNER JOIN app_store_apps AS asa USING(name)
GROUP BY name
ORDER BY count DESC	
----price**this one is weeeeeird
SELECT AVG(TRIM(LEADING '$' FROM psa.price::varchar::numeric::money) + TRIM(LEADING $ FROM asa.price::money)/2 AS avg_price
FROM play_store_apps AS psa 
		INNER JOIN app_store_apps AS asa USING(name)
		GROUP BY name
		
--ratings on games in both stores
SELECT  DISTINCT name AS game_name, psa.rating AS ps_rating, asa.rating AS as_rating
FROM play_store_apps AS psa
	JOIN app_store_apps AS asa USING(name)
ORDER BY ps_rating DESC

--PS apps by genre
SELECT genres, COUNT(*) AS number
FROM play_store_apps
WHERE rating >3
GROUP BY genres
ORDER BY number DESC
--AS apps by genre
SELECT primary_genre AS genre, COUNT(*) AS number
FROM app_store_apps
WHERE rating >4
GROUP BY genre
ORDER BY number DESC

--BOTH stores, rating & price
SELECT  DISTINCT name AS game_name, 
		psa.rating AS ps_rating, 
		asa.rating AS as_rating, 
		psa.price AS ps_price, asa.price AS as_price
FROM play_store_apps AS psa
	JOIN app_store_apps AS asa USING(name)
WHERE psa.rating > 3 AND asa.rating > 3
ORDER BY ps_rating DESC

--12892.91 APPSTORE
SELECT ROUND(AVG(review_count::numeric),2)
FROM app_store_apps
--444152.90
SELECT ROUND(AVG(review_count::numeric),2)
FROM play_store_apps
--------------------

