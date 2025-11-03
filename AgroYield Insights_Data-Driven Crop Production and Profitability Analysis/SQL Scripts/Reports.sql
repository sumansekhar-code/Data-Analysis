go 
use AgroYield_DB;
go

-- Crop Productivity Summary Report
-- Overall crop performance (area, production, yield) across India to identify high-output crops
-- Coconut and Sugarcane have the highest production, but Maize shows superior yield efficiency with moderate fertilizer use.
SELECT 
    Crop,
    ROUND(SUM(Area), 2) AS Total_Area,
    ROUND(SUM(Production), 2) AS Total_Production,
    ROUND(AVG(Yield), 2) AS Avg_Yield,
    ROUND(AVG(Fertilizer_per_Hect), 2) AS Avg_Fertilizer_Use,
    ROUND(AVG(Pesticide_per_Hect), 2) AS Avg_Pesticide_Use
FROM Crop_Yield
GROUP BY Crop
ORDER BY Avg_Yield DESC;


-- State-wise Agricultural Performance Report
-- To compare states based on production, yield, and resource utilization efficiency.
-- Delhi and Pundicherry show the highest yield per hectare, driven by optimal fertilizer use and effective irrigation strategies.
SELECT 
    State,
    ROUND(SUM(Production), 2) AS Total_Production,
    ROUND(AVG(Yield), 2) AS Avg_Yield,
    ROUND(SUM(Production_per_Hect), 2) AS Production_Efficiency,
    ROUND(SUM(Fertilizer_per_Hect), 2) AS Fertilizer_Use,
    ROUND(SUM(Pesticide_per_Hect), 2) AS Pesticide_Use
FROM Crop_Yield
GROUP BY State
ORDER BY Avg_Yield DESC;

-- Seasonal Crop Yield & Weather Impact Report
-- To analyze how different seasons and rainfall patterns affect crop yield.
-- The Winter season yields the highest output due to favorable rainfall, while Rabi season is more fertilizer-dependent.
SELECT 
    Season,
    ROUND(AVG(Annual_Rainfall), 2) AS Avg_Rainfall,
    ROUND(AVG(Yield), 2) AS Avg_Yield,
    ROUND(AVG(Production), 2) AS Avg_Production
FROM Crop_Yield
GROUP BY Season
ORDER BY Avg_Yield DESC;

-- Resource Efficiency Report
-- To evaluate how effectively fertilizer and pesticide resources contribute to production and yield outcomes.
-- States with balanced pesticide and fertilizer use (like Madhya Pradesh) show better efficiency ratios compared to overuse regions.
SELECT 
    State,
    ROUND(SUM(Production) / NULLIF(SUM(Fertilizer), 0), 2) AS Production_Per_Fertilizer,
    ROUND(SUM(Production) / NULLIF(SUM(Pesticide), 0), 2) AS Production_Per_Pesticide,
    ROUND(AVG(Yield_per_Hect), 2) AS Avg_Yield_Per_Hect,
    ROUND(AVG(Production_per_Hect), 2) AS Avg_Production_Per_Hect
FROM Crop_Yield
GROUP BY State
ORDER BY Production_Per_Fertilizer DESC;

-- Year-over-Year Crop Yield Growth Report
-- To track performance trends of average yield over years.
-- Average crop yield shows consistent growth from 2018 to 2022 due to improved irrigation and data-driven farming practices.
SELECT 
    Crop_Year,
    ROUND(AVG(Yield), 2) AS Avg_Yield,
    ROUND(LAG(AVG(Yield)) OVER (ORDER BY Crop_Year), 2) AS Prev_Year_Yield,
    ROUND(
        (AVG(Yield) - LAG(AVG(Yield)) OVER (ORDER BY Crop_Year)) /
        NULLIF(LAG(AVG(Yield)) OVER (ORDER BY Crop_Year), 0) * 100, 2
    ) AS YoY_Growth_Percentage
FROM Crop_Yield
GROUP BY Crop_Year
ORDER BY Crop_Year;




