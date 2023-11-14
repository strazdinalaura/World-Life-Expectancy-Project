# world Life Expectancy Project (Exploratory Data Analysis)

SELECT * 
FROM worldlifeexpectancy
;

#which countries have increased life exp
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS life_increase_15_years
FROM worldlifeexpectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY life_increase_15_years desc
;

#averga life exp by year
SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM worldlifeexpectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

#CORRELATION between life exp and other columns
SELECT * 
FROM worldlifeexpectancy
;

SELECT Country, 
ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, 
ROUND(AVG(GDP),1 ) AS GDP
FROM worldlifeexpectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP ASC
;

#Colleration between life exp and GDP
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_expectancy
FROM worldlifeexpectancy
;


SELECT * 
FROM worldlifeexpectancy
;

#life exp between Statuses
SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy
GROUP BY Status
;


SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy
GROUP BY Status
;

SELECT *
FROM worldlifeexpectancy
;

#AVG BMI, Life exp by Country
SELECT Country, 
ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, 
ROUND(AVG(BMI),1 ) AS BMI
FROM worldlifeexpectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI DESC
;


#rolling total
SELECT *
FROM worldlifeexpectancy
;

#breakdown of life expectancy and adult mortality rates for each country, along with a running total of adult mortality rates for each country across the years.
SELECT Country, 
Year, 
`Life expectancy`,
`Adult Mortality`,
#adds up the adult mortality rate for each country, starting from the first year available in the data and adding each subsequent year's mortality rate in order. This rolling total is reset for each country, meaning it calculates the sum separately for each country, as indicated by the PARTITION BY Country clause.
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS rolling_total 
FROM worldlifeexpectancy
;


