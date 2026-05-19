import pandas as pd
from sklearn.linear_model import LinearRegression

# 1. تجهيز البيانات
df = dataset.copy()

# 2. تنظيف البيانات (الخطوة دي هي اللي هتحل المشكلة)
# بنختار العواميد اللي محتاجينها وبنمسح أي صف فيه خانة فاضية
cols_to_use = ['IRRADIATION', 'MODULE_TEMPERATURE', 'AC_POWER']
df_clean = df[cols_to_use].dropna()

# 3. تدريب الموديل
X = df_clean[['IRRADIATION', 'MODULE_TEMPERATURE']]
y = df_clean['AC_POWER']
model = LinearRegression().fit(X, y)

# 4. حساب التوقع على البيانات الأصلية
# بنعوض عن أي خانة فاضية بـ 0 عشان الكود ما يقفش
df['Predicted_AC'] = model.predict(df[['IRRADIATION', 'MODULE_TEMPERATURE']].fillna(0))

# 5. حساب "فقد الكفاءة"
df['System_Efficiency_Loss'] = df['AC_POWER'] - df['Predicted_AC']