-- Step 1: Join raw and product tables on product_id and filter for relevant ingredients
CREATE TABLE sandwich_ingredients AS
SELECT r.nowtime,
       p.vendor,
       r.product_id,
       p.product_name,
       p.brand,
       r.current_price,
       r.old_price,
       p.units,
       r.price_per_unit,
       r.other,
       CASE
           WHEN p.product_name LIKE '%white bread%' THEN 'bread'
           WHEN p.product_name LIKE '%ham%' THEN 'ham'
           WHEN p.product_name LIKE '%lettuce%' THEN 'lettuce'
           WHEN p.product_name LIKE '%tomato%' THEN 'tomatoes'
           ELSE NULL
       END AS ingredient
FROM raw AS r
INNER JOIN product AS p ON r.product_id = p.id
WHERE p.product_name LIKE '%white bread%' 
   OR p.product_name LIKE '%ham%' 
   OR p.product_name LIKE '%lettuce%' 
   OR p.product_name LIKE '%tomato%';

-- Step 2: Remove rows with NULL ingredients
DELETE FROM sandwich_ingredients WHERE ingredient IS NULL;

-- Step 3: Calculate cost per ingredient and quantity for each vendor
CREATE TABLE ingredient_costs AS
SELECT vendor,
       ingredient,
       CASE 
           WHEN ingredient = 'bread' AND units LIKE '%g%' THEN current_price * (200.0 / CAST(SUBSTR(units, 1, INSTR(units, 'g') - 1) AS REAL))
           WHEN ingredient = 'ham' AND units LIKE '%g%' THEN current_price * (20.0 / CAST(SUBSTR(units, 1, INSTR(units, 'g') - 1) AS REAL))
           WHEN ingredient = 'lettuce' AND units LIKE '%g%' THEN current_price * (20.0 / CAST(SUBSTR(units, 1, INSTR(units, 'g') - 1) AS REAL))
           WHEN ingredient = 'tomatoes' AND units LIKE '%g%' THEN current_price * (15.0 / CAST(SUBSTR(units, 1, INSTR(units, 'g') - 1) AS REAL))
           WHEN ingredient = 'bread' AND units LIKE '%kg%' THEN current_price * (200.0 / (CAST(SUBSTR(units, 1, INSTR(units, 'k') - 1) AS REAL) * 1000))
           WHEN ingredient = 'ham' AND units LIKE '%kg%' THEN current_price * (20.0 / (CAST(SUBSTR(units, 1, INSTR(units, 'k') - 1) AS REAL) * 1000))
           WHEN ingredient = 'lettuce' AND units LIKE '%kg%' THEN current_price * (20.0 / (CAST(SUBSTR(units, 1, INSTR(units, 'k') - 1) AS REAL) * 1000))
           WHEN ingredient = 'tomatoes' AND units LIKE '%kg%' THEN current_price * (15.0 / (CAST(SUBSTR(units, 1, INSTR(units, 'k') - 1) AS REAL) * 1000))
           ELSE NULL
       END AS cost_per_sandwich
FROM sandwich_ingredients
WHERE cost_per_sandwich IS NOT NULL;

-- Step 4: Calculate the average ingredient cost with a threshold to exclude extreme values
CREATE TABLE filtered_average_ingredient_costs AS
SELECT vendor,
       ingredient,
       AVG(cost_per_sandwich) AS avg_cost_per_sandwich
FROM ingredient_costs
WHERE cost_per_sandwich < 50  -- Filter out costs greater than $50 per ingredient
GROUP BY vendor, ingredient;