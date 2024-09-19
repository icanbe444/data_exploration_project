-- Data Analysis

SELECT * 
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- cheking layoff by company 
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- cheking layoff by date
SELECT  MIN(date), MAX(date)
FROM layoffs_staging2;

-- checking laid_off by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- checking total laidoff by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- checking total laid off by year
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

-- cheking layoff by company stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

SELECT YEAR(date), SUBSTRING(date, 6, 2) AS Month, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY Month, YEAR(date)
ORDER BY 1 ASC;


SELECT SUBSTRING(date, 1, 7) AS Month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY Month, YEAR(date)
ORDER BY 1 ASC;


-- showing the layoffs by months of the year
WITH Rolling_Total AS
(
SELECT SUBSTRING(date, 1, 7) AS Month, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY Month, YEAR(date)
ORDER BY 1 ASC
)
SELECT MONTH, total_off,
SUM(total_off) OVER(ORDER BY MONTH) AS rolling_total
FROM Rolling_Total
;


-- Checking for layoffs by company and year
SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;

-- Created 2 CTEs
WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS -- Second CTE to querry the first CTE (Company_Year)
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5
;
