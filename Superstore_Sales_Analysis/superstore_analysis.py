import os
import pandas as pd

# Load data reliably from same folder
file_path = os.path.join(os.path.dirname(__file__), 'superstore_sales.csv')
df = pd.read_csv(file_path, parse_dates=['OrderDate'])

# 1) Quick look
print('Rows, Columns:', df.shape)
print(df.head())

# 2) Convert OrderDate to year_month for aggregation
df['year_month'] = df['OrderDate'].dt.to_period('M').astype(str)

# 3) Monthly sales & profit
monthly = df.groupby('year_month', as_index=False).agg(monthly_sales=('Sales','sum'),
                                                      monthly_profit=('Profit','sum'),
                                                      orders=('OrderID','count'))
monthly.to_csv(os.path.join(os.path.dirname(__file__), 'monthly_sales_summary.csv'), index=False)
print('\nMonthly summary saved to monthly_sales_summary.csv')

# 4) Region performance
region_perf = df.groupby('Region', as_index=False).agg(region_sales=('Sales','sum'),
                                                       region_profit=('Profit','sum'))
region_perf.to_csv(os.path.join(os.path.dirname(__file__), 'region_performance.csv'), index=False)
print('Region performance saved to region_performance.csv')

# 5) Category & sub-category performance
category_perf = df.groupby('Category', as_index=False).agg(category_sales=('Sales','sum'),
                                                           category_profit=('Profit','sum'))
category_perf.to_csv(os.path.join(os.path.dirname(__file__), 'category_performance.csv'), index=False)
subcat_perf = df.groupby('Sub-Category', as_index=False).agg(subcat_sales=('Sales','sum'),
                                                              subcat_profit=('Profit','sum'))
subcat_perf.to_csv(os.path.join(os.path.dirname(__file__), 'subcat_performance.csv'), index=False)
print('Category and Sub-category summaries saved')

# 6) Top 20 customers by sales
top_customers = df.groupby('CustomerID', as_index=False).agg(orders=('OrderID','count'),
                                                             lifetime_sales=('Sales','sum'),
                                                             lifetime_profit=('Profit','sum')).sort_values('lifetime_sales', ascending=False).head(20)
top_customers.to_csv(os.path.join(os.path.dirname(__file__), 'top_customers.csv'), index=False)
print('Top customers saved')

# 7) Loss-making orders
loss_orders = df[df['Profit'] < 0]
loss_orders.to_csv(os.path.join(os.path.dirname(__file__), 'loss_orders.csv'), index=False)
print('Loss orders saved')

# 8) Simple chart outputs (PNG) - monthly sales trend and category profit
import matplotlib.pyplot as plt
monthly['year_month_dt'] = pd.to_datetime(monthly['year_month'] + '-01')

plt.figure(figsize=(10,4))
plt.plot(monthly['year_month_dt'], monthly['monthly_sales'])
plt.title('Monthly Sales Trend (Superstore)')
plt.xlabel('Month')
plt.ylabel('Sales')
plt.tight_layout()
plt.savefig(os.path.join(os.path.dirname(__file__), 'monthly_sales_trend.png'))
plt.close()

cat = category_perf.sort_values('category_sales', ascending=False)
plt.figure(figsize=(6,4))
plt.bar(cat['Category'], cat['category_profit'])
plt.title('Category Profit')
plt.tight_layout()
plt.savefig(os.path.join(os.path.dirname(__file__), 'category_profit.png'))
plt.close()

print('Charts saved as PNGs')
