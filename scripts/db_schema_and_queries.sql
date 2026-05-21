/* المشروع: تحليل إنتاج الطاقة الشمسية
الغرض: حساب متوسط الأداء الساعي واليومي لإثبات كفاءة المحطة
*/

-- 1. استعلام تحليل ساعات الذروة (لعمل الـ Heatmap)
SELECT 
    DATEPART(HOUR, [DATE_TIME]) AS Production_Hour, -- استخراج الساعة من الوقت
    AVG([AC_POWER]) AS Average_AC_Output,          -- متوسط الإنتاج الفعلي
    AVG([IRRADIATION]) AS Average_Sunlight,       -- متوسط شدة الشمس
    COUNT(*) AS Number_of_Readings                -- عدد القراءات للتأكد من اكتمال البيانات
FROM 
    [Plant_1_Generation_Data]
WHERE 
    [AC_POWER] > 0 -- التركيز فقط على الساعات اللي كان فيها إنتاج (ساعات النهار)
GROUP BY 
    DATEPART(HOUR, [DATE_TIME])
ORDER BY 
    Production_Hour;

-- 2. استعلام كفاءة التحويل اليومية (لعمل شارت الـ Efficiency)
SELECT 
    CAST([DATE_TIME] AS DATE) AS Production_Date,  -- تحويل الوقت لتاريخ فقط
    SUM([AC_POWER]) AS Total_Daily_Yield,          -- إجمالي الإنتاج اليومي
    AVG([MODULE_TEMPERATURE]) AS Avg_Temp,         -- متوسط حرارة الألواح
    AVG([IRRADIATION]) AS Avg_Irradiation          -- متوسط الإشعاع الشمسي
FROM 
    [Plant_1_Generation_Data]
GROUP BY 
    CAST([DATE_TIME] AS DATE)
ORDER BY 
    Production_Date;
-- تصليح دمج الجداول بناءً على الوقت
SELECT * FROM Plant_1_Generation_Data Gen
INNER JOIN Plant_1_Weather_Sensor_Data Wea 
ON Gen.DATE_TIME = Wea.DATE_TIME;