-- DATA CLEANING PROJECT

USE world_layoffs;

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null/Blank Values
-- 4. Remove Any Columns if not necessary

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- 1st: Remove Duplicates

-- USE ROW_NUMBER window function to pull data if there is any duplicate

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- USE CTE
 
WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
 )
 SELECT *
 FROM duplicate_CTE
 WHERE row_num > 1;
 
 SELECT *
 FROM layoffs_staging
 WHERE company = 'Casper';
 
 -- WITH duplicate_CTE AS
-- (
-- SELECT *,
-- ROW_NUMBER() OVER(
-- PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
-- FROM layoffs_staging
--  )
--  DELETE
--  FROM duplicate_CTE
--  WHERE row_num > 1;
 
 -- CREATE a TABLE layoffs_staging2 and delete duplicates as we can not do delete directly
 
 CREATE TABLE `layoffs_staging2`
 (
	`company` text,
    `location` text,
    `industry` text, 
    `total_laid_off` int DEFAULT NULL, 
    `percentage_laid_off` text, 
    `date` text, 
    `stage` text, 
    `country` text, 
    `funds_raised_millions` int DEFAULT NULL,
    `row_num` INT
);
 
SELECT *
FROM layoffs_staging2;
 
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- 2nd: Standadize the data
-- check by company, industry,location, country, date, total_laid_off, percentage_laid_off

SELECT company,  TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- SELECT *
SELECT DISTINCT industry
FROM layoffs_staging2;
-- WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING'.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING'.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging2;


-- String function str_to_date
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

-- changing the date format of DATE column
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

-- 3. NULL/BLANK values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

UPDATE layoffs_staging2
SET industry = NULL
where industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
    WHERE (t1.industry IS NULL OR t1.industry = '')
    AND t2.industry IS NOT NULL;
    
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
    AND t2.industry IS NOT NULL;

SELECT industry
FROM layoffs_staging2;

-- remove NULL values remaining not possible because we don't have total laid off value or anything else to decide it

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete NULL values only when both are null
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- 4th: Remove unnecessary column

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;