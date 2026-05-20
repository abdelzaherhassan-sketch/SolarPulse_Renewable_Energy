USE SolarPulse_DB;

-- 1. مسح الجدول القديم لو موجود عشان ما يعملش تضارب
IF OBJECT_ID('Plant_1_Generation_Data', 'U') IS NOT NULL 
    DROP TABLE Plant_1_Generation_Data;

-- 2. بناء الجدول من جديد بأنواع بيانات سليمة
CREATE TABLE Plant_1_Generation_Data (
    DATE_TIME VARCHAR(100),
    PLANT_ID BIGINT,
    SOURCE_KEY VARCHAR(50),
    DC_POWER FLOAT,
    AC_POWER FLOAT,
    DAILY_YIELD FLOAT,
    TOTAL_YIELD FLOAT
);

-- 3. صب البيانات الخام من ملف الـ CSV فوراً
BULK INSERT Plant_1_Generation_Data
FROM 'D:\depi\FinalProject\project\Team work\18052026\Graduation project-Team-1\Plant_1_Generation_Data.CSV'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
-- 1. بناء جدول الطقس
CREATE TABLE Plant_1_Weather_Sensor_Data (
    DATE_TIME VARCHAR(100),
    PLANT_ID BIGINT,
    SOURCE_KEY VARCHAR(50),
    AMBIENT_TEMPERATURE FLOAT,
    MODULE_TEMPERATURE FLOAT,
    IRRADIANCE FLOAT
);
-- 2. صب بيانات ملف الطقس الخام بالصيغة الصحيحة للسيرفر
BULK INSERT Plant_1_Weather_Sensor_Data
FROM 'D:\depi\FinalProject\project\Team work\18052026\Graduation project-Team-1\Plant_1_Weather_Sensor_Data.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'   -- الترميز الصحيح للـ UTF-8 في SQL Server
);
-- فحص سريع للجدولين معاً
SELECT TOP 5 * FROM Plant_1_Generation_Data;
SELECT TOP 5 * FROM Plant_1_Weather_Sensor_Data;
-- 1. فحص الخلايا الفاضية (Nulls) في جدول الإنتاج
SELECT 
    SUM(CASE WHEN DATE_TIME IS NULL THEN 1 ELSE 0 END) AS Null_DateTime,
    SUM(CASE WHEN PLANT_ID IS NULL THEN 1 ELSE 0 END) AS Null_PlantID,
    SUM(CASE WHEN SOURCE_KEY IS NULL THEN 1 ELSE 0 END) AS Null_SourceKey,
    SUM(CASE WHEN DC_POWER IS NULL THEN 1 ELSE 0 END) AS Null_DCPower,
    SUM(CASE WHEN AC_POWER IS NULL THEN 1 ELSE 0 END) AS Null_ACPower,
    SUM(CASE WHEN DAILY_YIELD IS NULL THEN 1 ELSE 0 END) AS Null_DailyYield,
    SUM(CASE WHEN TOTAL_YIELD IS NULL THEN 1 ELSE 0 END) AS Null_TotalYield
FROM Plant_1_Generation_Data;

-- 2. فحص الخلايا الفاضية (Nulls) في جدول الطقس
SELECT 
    SUM(CASE WHEN DATE_TIME IS NULL THEN 1 ELSE 0 END) AS Null_DateTime,
    SUM(CASE WHEN PLANT_ID IS NULL THEN 1 ELSE 0 END) AS Null_PlantID,
    SUM(CASE WHEN SOURCE_KEY IS NULL THEN 1 ELSE 0 END) AS Null_SourceKey,
    SUM(CASE WHEN AMBIENT_TEMPERATURE IS NULL THEN 1 ELSE 0 END) AS Null_AmbientTemp,
    SUM(CASE WHEN MODULE_TEMPERATURE IS NULL THEN 1 ELSE 0 END) AS Null_ModuleTemp,
    SUM(CASE WHEN IRRADIANCE IS NULL THEN 1 ELSE 0 END) AS Null_Irradiance
FROM Plant_1_Weather_Sensor_Data;
-- 1. فحص السطور المتكررة في جدول الإنتاج
SELECT DATE_TIME, PLANT_ID, SOURCE_KEY, COUNT(*) AS Duplicate_Count
FROM Plant_1_Generation_Data
GROUP BY DATE_TIME, PLANT_ID, SOURCE_KEY
HAVING COUNT(*) > 1;

-- 2. فحص السطور المتكررة في جدول الطقس
SELECT DATE_TIME, PLANT_ID, SOURCE_KEY, COUNT(*) AS Duplicate_Count
FROM Plant_1_Weather_Sensor_Data
GROUP BY DATE_TIME, PLANT_ID, SOURCE_KEY
HAVING COUNT(*) > 1;