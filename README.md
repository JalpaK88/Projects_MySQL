# World Layoffs — Data Cleaning & Exploratory Data Analysis (MySQL)

This project uses MySQL to clean and analyze a real-world dataset of global company layoffs. It is split into two parts: a **Data Cleaning** script that transforms raw, messy data into an analysis-ready table, and a **Data Exploration** script that uses SQL to uncover trends and insights from the cleaned data.

## 📁 Files

| File | Description |
|---|---|
| `DataCleaning.sql` | Cleans and standardizes the raw `layoffs` table |
| `DataExploration.sql` | Performs exploratory data analysis (EDA) on the cleaned dataset |

---

## 🧹 Part 1: Data Cleaning (`DataCleaning.sql`)

Raw data is rarely analysis-ready. This script works through a structured cleaning process on the `layoffs` table, producing a clean, deduplicated `layoffs_staging2` table.

**Steps performed:**
1. **Staging tables** — Created `layoffs_staging` and `layoffs_staging2` as working copies, so the raw source table is never modified directly.
2. **Remove duplicates** — Used `ROW_NUMBER()` with a `PARTITION BY` across all relevant columns (company, location, industry, layoffs figures, date, stage, country, funding) to flag exact duplicate rows, then deleted rows where `row_num > 1`.
3. **Standardize the data**
   - Trimmed extra whitespace from company names.
   - Consolidated inconsistent industry labels (e.g., merged all `Crypto%` variants into a single `Crypto` category).
   - Removed trailing periods from country names (e.g., `United States.` → `United States`).
   - Converted the `date` column from text to a proper `DATE` type using `STR_TO_DATE()`, then altered the column type accordingly.
4. **Handle NULL / blank values**
   - Identified blank `industry` values and converted them to proper `NULL`s.
   - Used a self-join on `company` and `location` to backfill missing `industry` values from other rows for the same company.
   - Removed rows where both `total_laid_off` and `percentage_laid_off` were `NULL`, since these rows carried no usable metric.
5. **Remove unnecessary columns** — Dropped the helper `row_num` column once deduplication was complete, leaving a clean final table.

**Key SQL techniques used:** window functions (`ROW_NUMBER()`), CTEs, self-joins, `UPDATE`/`DELETE` with joins, string functions (`TRIM`, `STR_TO_DATE`), and `ALTER TABLE`.

---

## 📊 Part 2: Exploratory Data Analysis (`DataExploration.sql`)

Using the cleaned `layoffs_staging2` table, this script explores the data to answer key business questions.

**Questions explored:**
- What are the largest single layoff events, by count and by percentage of workforce laid off?
- Which companies laid off 100% of their staff, and how well-funded were they?
- Which companies had the highest total layoffs overall?
- What is the date range covered by the dataset?
- Which industries, company stages, and countries were hit hardest by layoffs?
- How did layoffs progress month-over-month? (rolling total over time using a window function)
- Which companies had the most layoffs each year, ranked using `DENSE_RANK()` (top 5 per year)?

**Key SQL techniques used:** aggregate functions (`SUM`, `MAX`, `MIN`, `AVG`), `GROUP BY`/`ORDER BY`, CTEs, window functions (`SUM() OVER`, `DENSE_RANK() OVER`), and `SUBSTRING()` for date-part extraction.

---

## 🛠️ Tools
- **Database:** MySQL
- **Techniques:** CTEs, window functions, joins, string/date functions, data standardization
