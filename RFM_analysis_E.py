#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
import seaborn as sns
import matplotlib.pyplot as plt


# In[2]:


# Load Data
df = pd.read_csv(r"C:\Users\ASUS\Desktop\Project\Ecomerece_Project\Final_RFM_Segmentation.csv")
df


# In[4]:


# Clean data
df = df.dropna(subset=['Recency', 'Frequency', 'Monetary'])
df.replace([np.inf, -np.inf], np.nan, inplace=True)
df = df.dropna(subset=['Recency', 'Frequency', 'Monetary'])


# In[5]:


# Scale Data
scaler = StandardScaler()
rfm_scaled = scaler.fit_transform(df[['Recency', 'Frequency', 'Monetary']])


# In[6]:


# Apply KMeans
kmeans = KMeans(n_clusters=4, random_state=42)
df['Cluster'] = kmeans.fit_predict(rfm_scaled)


# In[7]:


# Segment Label function
def segment_customer(row):
    if row['Recency'] <= 30 and row['Frequency'] >= 10 and row['Monetary'] >= 500:
        return 'Champions'
    elif row['Recency'] <= 60 and row['Frequency'] >= 8:
        return 'Loyal Customers'
    elif row['Recency'] <= 90 and row['Frequency'] >= 5:
        return 'Potential Loyalist'
    elif row['Recency'] > 120 and row['Frequency'] <= 2:
        return 'Hibernating'
    elif row['Recency'] > 90 and row['Frequency'] >= 3 and row['Monetary'] >= 300:
        return 'Big Spenders'
    elif row['Recency'] <= 30 and row['Frequency'] <= 2:
        return 'New Customers'
    else:
        return 'Others'


# In[8]:


#Apply Segment
df['Segment_Label'] = df.apply(segment_customer, axis=1)


# In[9]:


#Visuale Clusters
sns.scatterplot(data=df, x='Recency', y='Monetary', hue='Cluster', palette='Set2')
plt.title("Customer Segments (Recency vs Monetary)")
plt.show()


# In[10]:


#Summary
cluster_summary = df.groupby('Cluster').agg({
    'Recency': 'mean',
    'Frequency': 'mean',
    'Monetary': 'mean',
    'Customer_ID': 'count'
}).rename(columns={'Customer_ID': 'Count'})

print(cluster_summary)


# In[11]:


#Save Final File
df.to_csv(r"C:\Users\ASUS\Desktop\Project\Ecomerece_Project\RFM_Final_With_Segments.csv", index=False)

print("✅ Segment_Label added & final CSV saved: RFM_Final_With_Segments.csv")


# In[ ]:




