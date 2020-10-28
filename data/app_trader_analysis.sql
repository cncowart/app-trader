SELECT name, primary_genre, rating, price, review_count::integer
FROM app_store_apps
WHERE review_count::integer >20000
ORDER BY rating DESC; -- top apps in app store

--

SELECT name, rating, price, review_count, install_count
FROM play_store_apps
WHERE category IS NOT null
AND rating IS NOT null
AND review_count::integer > 10000
AND rating >= 4.9
ORDER BY review_count DESC; --16 apps with 4.9 rating or higher and 10,000+ reviews in play store

--

SELECT name
FROM app_store_apps
INTERSECT
SELECT name
FROM play_store_apps; -- all apps that are on both stores

--

SELECT name, price, rating
FROM app_store_apps
WHERE name IN (SELECT name
		FROM app_store_apps
		INTERSECT
		SELECT name
		FROM play_store_apps)
LEFT JOIN
ORDER BY rating DESC; -- apps on both stores and their ratings on the app store

--

SELECT DISTINCT(name), AVG(rating) as avg_rating, SUM(review_count) as total_review, AVG (price::money::numeric) as avg_price
FROM play_store_apps
WHERE name IN (SELECT name
		FROM app_store_apps
		INTERSECT
		SELECT name
		FROM play_store_apps)
GROUP BY name
ORDER BY avg_rating DESC; -- apps on both stores and rating in play store

--

SELECT name, AVG(rating) as avg_star_rating, price
FROM app_store_apps
WHERE name IN (SELECT name
		FROM app_store_apps
		INTERSECT
		SELECT name
		FROM play_store_apps)
GROUP BY name, price
ORDER BY price; -- app store pricing tiers and stars

--

SELECT app_store_apps.name AS app_store_name, app_store_apps.rating AS app_store_rating, app_store_apps.price AS app_store_price,
		play_store_apps.name AS play_store_name, play_store_apps.rating AS play_store_rating, play_store_apps.price AS play_store_price,
		ROUND(app_store_apps.rating + play_store_apps.rating)/2 AS avg_rating
FROM app_store_apps
		FULL JOIN play_store_apps
		ON app_store_apps.name = play_store_apps.name
WHERE play_store_apps.name IS NOT NULL
AND app_store_apps.name IS NOT NULL
GROUP BY app_store_name, play_store_name, app_store_rating, play_store_rating, app_store_price, play_store_price
ORDER BY app_store_rating DESC; -- combined tables

--

SELECT name, AVG(rating) as avg_star_rating, price::money
FROM play_store_apps
WHERE name IN (SELECT name
		FROM app_store_apps
		INTERSECT
		SELECT name
		FROM play_store_apps)
GROUP BY name, price
ORDER BY price DESC; -- Apps ordered from most to least expensive

--

SELECT app_store_apps.name AS _name, AVG((app_store_apps.price + play_store_apps.price::money::numeric)/2) AS avg_price,
		AVG((app_store_apps.rating + play_store_apps.rating)/2) AS avg_rating
FROM app_store_apps
		FULL JOIN play_store_apps
		ON app_store_apps.name = play_store_apps.name
WHERE play_store_apps.name IS NOT NULL
AND app_store_apps.name IS NOT NULL
GROUP BY _name
ORDER BY avg_rating DESC; -- combined tables with avg rating and avg price over both app stores

--

SELECT app_store_apps.name AS _name, AVG((app_store_apps.price + play_store_apps.price::money::numeric)/2) AS avg_price,
		AVG((app_store_apps.rating + play_store_apps.rating)/2) AS avg_rating
FROM app_store_apps
		FULL JOIN play_store_apps
		ON app_store_apps.name = play_store_apps.name
WHERE play_store_apps.name IS NOT NULL
AND app_store_apps.name IS NOT NULL
GROUP BY _name, app_store_apps.rating
HAVING app_store_apps.rating > 4.45
ORDER BY avg_rating DESC; --top apps with avg price and avg stars across the two app stores with rating over 4.45 to remove lower ratings

--

SELECT app_store_apps.price,
		AVG((app_store_apps.rating + play_store_apps.rating)/2) AS avg_rating, COUNT(app_store_apps.name)
FROM app_store_apps
		FULL JOIN play_store_apps
		ON app_store_apps.name = play_store_apps.name
WHERE play_store_apps.name IS NOT NULL
AND app_store_apps.name IS NOT NULL
GROUP BY app_store_apps.price
ORDER BY app_store_apps.price DESC; -- avg star rating grouped by pricing of app on app store

--
SELECT play_store_apps.price,
		AVG((app_store_apps.rating + play_store_apps.rating)/2) AS avg_rating, COUNT(app_store_apps.name)
FROM app_store_apps
		FULL JOIN play_store_apps
		ON app_store_apps.name = play_store_apps.name
WHERE play_store_apps.name IS NOT NULL
AND app_store_apps.name IS NOT NULL
GROUP BY play_store_apps.price
ORDER BY play_store_apps.price DESC; -- avg star rating grouped by pricing of app on play store

--

SELECT primary_genre, COUNT(review_count)
FROM app_store_apps
GROUP BY primary_genre; -- app store reviews by genre

--


SELECT lower(category), COUNT(review_count)
FROM play_store_apps
GROUP BY category; -- play store reviews by category

--

SELECT COUNT(name)
FROM play_store_apps
WHERE name IN (SELECT name
		FROM app_store_apps
		INTERSECT
		SELECT name
		FROM play_store_apps);



