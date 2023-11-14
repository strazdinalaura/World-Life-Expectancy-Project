# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM worldlifeexpectancy
;

#Identifying duplicates
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifeexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM worldlifeexpectancy
    ) AS Row_Table
WHERE Row_Num > 1
;

#Removing duplicates
DELETE FROM worldlifeexpectancy
WHERE 
	Row_ID IN ( 
    SELECT ROW_ID
FROM(
    SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM worldlifeexpectancy
    ) AS Row_Table
WHERE Row_Num > 1
)
;

SELECT * 
FROM worldlifeexpectancy
;

#Missing Data
SELECT * 
FROM worldlifeexpectancy
WHERE Status = ''
;

SELECT DISTINCT(Status)
FROM worldlifeexpectancy
WHERE Status <> ''
;

SELECT DISTINCT(Country)
FROM worldlifeexpectancy
WHERE Status = 'Developing'
;

#taking status from different year for the same country
UPDATE worldlifeexpectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
					FROM worldlifeexpectancy
					WHERE Status = 'Developing');
                    
#self-join to itself we can filter based on country = to country and                
UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.country = t2.country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;


UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.country = t2.country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT * 
FROM worldlifeexpectancy
;


#cleaning life expectancy by populating blanks with the average
SELECT * 
FROM worldlifeexpectancy
WHERE `Life expectancy` = ''
;


SELECT Country, Year, `Life expectancy`
FROM worldlifeexpectancy
#WHERE `Life expectancy` = ''
;


#find previous and next row using self-join, find previous and next year average
SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
FROM worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;


UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
WHERE t1.`Life expectancy` = ''
;






	