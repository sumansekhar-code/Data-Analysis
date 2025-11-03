go 
use AgroYield_DB;
go

--------------------------- Basic Descriptive Analysis --------------------------

-- Missing or Zero Data Check
SELECT 
    SUM(CASE WHEN Area IS NULL OR Area = 0 THEN 1 ELSE 0 END) AS Missing_Area,
    SUM(CASE WHEN Production IS NULL OR Production = 0 THEN 1 ELSE 0 END) AS Missing_Production,
    SUM(CASE WHEN Yield IS NULL OR Yield = 0 THEN 1 ELSE 0 END) AS Missing_Yield
FROM Crop_Yield;

-- Overall Summary Stats
SELECT
    ROUND(AVG(Area),2) AS Avg_Area,
    ROUND(AVG(Production),2) AS Avg_Production,
    ROUND(AVG(Yield),2) AS Avg_Yield,
    ROUND(AVG(Annual_Rainfall),2) AS Avg_Rainfall,
    ROUND(AVG(Fertilizer),2) AS Avg_Fertilizer,
    ROUND(AVG(Pesticide),2) AS Avg_Pesticide
FROM Crop_Yield;


-- Total Records and Time Range
SELECT 
    COUNT(*) AS Total_Records,
    MIN(Crop_Year) AS First_Year,
    MAX(Crop_Year) AS Last_Year
FROM Crop_Yield;

-- Total Records and States Covered
SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT State) AS Total_States,
    COUNT(DISTINCT Crop) AS Total_Crops,
    COUNT(DISTINCT Crop_Year) AS Years_Covered
FROM Crop_Yield;

-- Number of Unique Crops and States
SELECT 
    COUNT(DISTINCT Crop) AS Unique_Crops,
    COUNT(DISTINCT State) AS Unique_States
FROM Crop_Yield;

-- Overall Average Yield and Production
SELECT 
    ROUND(AVG(Yield), 2) AS Avg_Yield,
    ROUND(AVG(Production), 2) AS Avg_Production
FROM Crop_Yield;

-- Crop Count per Season
SELECT Season, COUNT(DISTINCT Crop) AS Crops_Count
FROM Crop_Yield
GROUP BY Season;

--------------------------- Crop-Level Analysis --------------------------

-- Yearly Yield Trend (All Crops Combined)
SELECT Crop_Year, ROUND(AVG(Yield), 2) AS Avg_Yield
FROM Crop_Yield
GROUP BY Crop_Year
ORDER BY Crop_Year desc;

-- Top 10 States by Average Yield
SELECT TOP 10 State, ROUND(AVG(Yield), 2) AS Avg_Yield
FROM Crop_Yield
GROUP BY State
ORDER BY Avg_Yield DESC;

-- Top 5 Crops by Average Production
SELECT TOP 5 Crop, ROUND(AVG(Production), 2) AS Avg_Production
FROM Crop_Yield
GROUP BY Crop
ORDER BY Avg_Production DESC;

-- Top 5 Crops by Average Yield
SELECT TOP 5 
    Crop, 
    ROUND(AVG(Yield),2) AS Avg_Yield
FROM Crop_Yield
GROUP BY Crop
ORDER BY Avg_Yield DESC;

-- Highest Producing Crops (Total Production)
SELECT TOP 10 
    Crop, 
    ROUND(SUM(Production),2) AS Total_Production
FROM Crop_Yield
GROUP BY Crop
ORDER BY Total_Production DESC;

-- Best Performing Season Overall
SELECT Season, ROUND(AVG(Yield), 2) AS Avg_Yield
FROM Crop_Yield
GROUP BY Season
ORDER BY Avg_Yield DESC;

-- Most Widely Cultivated Crops (Area-Wise)
SELECT TOP 10 
    Crop, 
    ROUND(SUM(Area),2) AS Total_Area
FROM Crop_Yield
GROUP BY Crop
ORDER BY Total_Area DESC;


--------------------------- State-Level Analysis --------------------------

-- Average Yield by State
SELECT 
    State,
    ROUND(AVG(Yield),2) AS Avg_Yield
FROM Crop_Yield
GROUP BY State
ORDER BY Avg_Yield DESC;

-- States Using Most Fertilizer
SELECT 
    State,
    ROUND(SUM(Fertilizer),2) AS Total_Fertilizer_Used
FROM Crop_Yield
GROUP BY State
ORDER BY Total_Fertilizer_Used DESC;

-- States with Highest Efficiency (Production per Hectare)
SELECT 
    State,
    ROUND(AVG(Production_per_Hect),2) AS Avg_Prod_Per_Hect
FROM Crop_Yield
GROUP BY State
ORDER BY Avg_Prod_Per_Hect DESC;


--------------------------- State-Level Analysis --------------------------

-- Average Yield per Season
SELECT 
    Season,
    ROUND(AVG(Yield),2) AS Avg_Yield,
    ROUND(AVG(Production),2) AS Avg_Production
FROM Crop_Yield
GROUP BY Season
ORDER BY Avg_Yield DESC;

-- Yield Trend Over Years
SELECT 
    Crop_Year,
    ROUND(AVG(Yield),2) AS Avg_Yield
FROM Crop_Yield
GROUP BY Crop_Year
ORDER BY Crop_Year DESC;

--Year-over-Year Growth in Yield
SELECT 
    Crop_Year,
    ROUND(AVG(Yield),2) AS Avg_Yield,
    ROUND(LAG(AVG(Yield)) OVER (ORDER BY Crop_Year),2) AS Prev_Year_Yield,
    ROUND(
        (AVG(Yield) - LAG(AVG(Yield)) OVER (ORDER BY Crop_Year)) /
        NULLIF(LAG(AVG(Yield)) OVER (ORDER BY Crop_Year),0) * 100,2
    ) AS YoY_Growth_Percent
FROM Crop_Yield
GROUP BY Crop_Year
ORDER BY Crop_Year;

--------------------------- Correlation & Efficiency Insights --------------------------

-- Rainfall vs Yield (Impact)
SELECT 
    State,
    ROUND(AVG(Annual_Rainfall),2) AS Avg_Rainfall,
    ROUND(AVG(Yield),2) AS Avg_Yield
FROM Crop_Yield
GROUP BY State
ORDER BY Avg_Rainfall DESC;

-- Fertilizer Efficiency (Production per Fertilizer)
SELECT 
    State,
    ROUND(SUM(Production) / NULLIF(SUM(Fertilizer), 0), 2) AS Production_Per_Fertilizer
FROM Crop_Yield
GROUP BY State
ORDER BY Production_Per_Fertilizer DESC;

-- Pesticide Efficiency
SELECT 
    State,
    ROUND(SUM(Production) / NULLIF(SUM(Pesticide), 0), 2) AS Production_Per_Pesticide
FROM Crop_Yield
GROUP BY State
ORDER BY Production_Per_Pesticide DESC;


--------------------------- Advanced Insights --------------------------

-- Identify Top Performing States per Crop
SELECT 
    Crop,
    State,
    ROUND(AVG(Yield),2) AS Avg_Yield
FROM Crop_Yield
GROUP BY Crop, State
HAVING AVG(Yield) = (
        SELECT MAX(AVG(Yield)) 
        FROM Crop_Yield AS c2 
        WHERE c2.Crop = Crop 
        GROUP BY c2.Crop);

-- Resource Optimization Indicator
SELECT 
    State,
    ROUND(SUM(Production_per_Hect),2) AS Total_Production_per_Hect,
    ROUND(SUM(Fertilizer_per_Hect),2) AS Total_Fertilizer_per_Hect,
    ROUND(SUM(Pesticide_per_Hect),2) AS Total_Pesticide_per_Hect,
    ROUND(
        (SUM(Production_per_Hect) / 
        (SUM(Fertilizer_per_Hect) + SUM(Pesticide_per_Hect))) , 2
    ) AS Resource_Efficiency_Index
FROM Crop_Yield
GROUP BY State
ORDER BY Resource_Efficiency_Index DESC;
