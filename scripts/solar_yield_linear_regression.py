import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score
# التصحيح: استدعاء مكتبة تقسيم البيانات علمياً
from sklearn.model_selection import train_test_split

df = dataset.copy()
# تنظيف وتحويل الأسماء لحروف كبيرة
df.columns = [c.strip().upper() for c in df.columns]

try:
    # البحث الديناميكي عن الأعمدة
    col_ac = [c for c in df.columns if 'AC_POWER' in c][0]
    col_irr = [c for c in df.columns if 'IRRADIATION' in c][0]
    col_temp = [c for c in df.columns if 'MODULE_TEMPERATURE' in c][0]

    # تجهيز البيانات (حذف الصفوف الفاضية لضمان دقة التدريب)
    train_df = df[[col_irr, col_temp, col_ac]].dropna()

    # التصحيح التكنيكال: تقسيم البيانات إلى 80% للتدريب و 20% للاختبار الفعلي
    X = train_df[[col_irr, col_temp]]
    y = train_df[col_ac]
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # تدريب الموديل على بيانات التدريب فقط (X_train, y_train) لضمان الاحترافية
    model = LinearRegression().fit(X_train, y_train)
    
    # إضافة التوقعات والدقة الحقيقية بناءً على بيانات الاختبار (X_test)
    df['Predicted_AC_Power'] = model.predict(df[[col_irr, col_temp]].fillna(0))
    df['Model_Accuracy'] = r2_score(y_test, model.predict(X_test)) * 100

except Exception as e:
    df['Model_Accuracy'] = f"Error: {str(e)}"

result = df