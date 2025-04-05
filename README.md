🛍️ E-commerce RFM Segmentation Project
📊 Overview
This project performs RFM (Recency, Frequency, Monetary) analysis on e-commerce customer data to segment users into meaningful categories like:

Champions
Loyal Customers
Big Spenders
Hibernating
New Customers
...and more!
These segments help in targeted marketing and customer retention strategies.

🔧 Tools Used
SQL
Python (Pandas, NumPy, Scikit-learn, Seaborn, Matplotlib)
Power BI (for dashboard visualization)
Jupyter Notebook 
Git & GitHub

📁 Files Included
Final_RFM_Segmentation.csv → Cleaned RFM data
RFM_Final_With_Segments.csv → Data with segment labels

SQL For : 
Data Cleaning 
RFM Analysis 

Python script for:
KMeans clustering
Segment labeling
Visualization

Power BI Dashboard (.pbix file)

📌 Key Features
RFM Aggregation & Clustering using KMeans
Custom segment labeling using business logic

Clean, interactive Power BI dashboard with:
KPIs (Avg Recency, Frequency, Monetary)
Bar Charts (Segment-wise customers)
Scatter Plot (Monetary vs Frequency)
Segment-wise Insights

📈 Sample Segments Logic
python
Copy
Edit
if Recency <= 30 and Frequency >= 10 and Monetary >= 500:
    return "Champions"
elif Recency <= 60 and Frequency >= 8:
    return "Loyal Customers"
...
📸 Dashboard Preview
![image](https://github.com/user-attachments/assets/90f93973-4f4e-4935-8e21-df7971b6ae9d)


🙋‍♂️ Author
Kartik Dhatwalia

📧 kartikdhatwaliaaz@gmail.com
