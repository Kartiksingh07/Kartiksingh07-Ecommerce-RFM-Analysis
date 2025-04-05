SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [Ecommerce_db].[dbo].[Online Retail]

SELECT * FROM [Ecommerce_db].[dbo].[Online Retail]
WHERE InvoiceNo IS NULL OR StockCode IS NULL OR Description IS NULL 
OR Quantity IS NULL OR InvoiceDate IS NULL OR UnitPrice IS NULL OR CustomerID IS NULL OR Country IS NULL;

DELETE FROM [Ecommerce_db].[dbo].[Online Retail] WHERE CustomerID IS NULL;

DELETE FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE Description IS NULL;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY InvoiceNo, StockCode, Quantity, UnitPrice, CustomerID
        ORDER BY InvoiceDate
    ) AS rn
    FROM [Ecommerce_db].[dbo].[Online Retail]
)
DELETE FROM CTE WHERE rn > 1;

ALTER TABLE [Ecommerce_db].[dbo].[Online Retail] NOCHECK CONSTRAINT ALL;

SELECT DISTINCT [Quantity]
FROM [Ecommerce_db].[dbo].[Online Retail]
WHERE TRY_CONVERT(INT, [Quantity]) IS NULL;

DELETE FROM [Ecommerce_db].[dbo].[Online Retail]
WHERE TRY_CONVERT(INT, [Quantity]) IS NULL;

UPDATE [Ecommerce_db].[dbo].[Online Retail]
SET [Quantity] = NULL
WHERE TRY_CONVERT(INT, [Quantity]) IS NULL;

ALTER TABLE [Ecommerce_db].[dbo].[Online Retail]
ALTER COLUMN [Quantity] INT;

SELECT * FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE [Quantity] <= 0;

DELETE FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE [Quantity] <= 0;

UPDATE [Ecommerce_db].[dbo].[Online Retail]  
SET InvoiceDate = TRY_CONVERT(DATETIME, InvoiceDate, 103)
WHERE InvoiceDate IS NOT NULL;

UPDATE [Ecommerce_db].[dbo].[Online Retail]  
SET CustomerID = NULL  
WHERE CustomerID = 0;

SELECT * FROM [Ecommerce_db].[dbo].[Online Retail]  
ORDER BY InvoiceDate DESC;

SELECT CustomerID, MAX(InvoiceDate) AS LastPurchaseDate
FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY LastPurchaseDate DESC;

SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS TotalTransactions
FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalTransactions DESC;

SELECT COLUMN_NAME, DATA_TYPE  
FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME = 'Online Retail' AND TABLE_SCHEMA = 'dbo';

SELECT DISTINCT Quantity  
FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE TRY_CAST(Quantity AS INT) IS NULL;

SELECT *  
FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE TRY_CAST(Quantity AS INT) IS NOT NULL AND CAST(Quantity AS INT) <= 0;

DELETE FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE TRY_CAST(Quantity AS INT) IS NULL;

ALTER TABLE [Ecommerce_db].[dbo].[Online Retail]  
ALTER COLUMN Quantity INT;

SELECT * FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE Quantity <= 0;

SELECT DISTINCT Quantity  
FROM [Ecommerce_db].[dbo].[Online Retail]  
WHERE TRY_CAST(Quantity AS FLOAT) IS NULL;


SELECT CustomerID, SUM(CAST(Quantity AS FLOAT) * UnitPrice) AS TotalSpending
FROM [Ecommerce_db].[dbo].[Online Retail]
WHERE TRY_CAST(Quantity AS FLOAT) IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalSpending DESC;

WITH RecencyCTE AS (
    SELECT CustomerID, 
           DATEDIFF(DAY, MAX(InvoiceDate), '2011-12-10') AS Recency
    FROM [Ecommerce_db].[dbo].[Online Retail]
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
FrequencyCTE AS (
    SELECT CustomerID, 
           COUNT(DISTINCT InvoiceNo) AS Frequency
    FROM [Ecommerce_db].[dbo].[Online Retail]
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
MonetaryCTE AS (
    SELECT CustomerID, 
           SUM(CAST(Quantity AS FLOAT) * UnitPrice) AS Monetary
    FROM [Ecommerce_db].[dbo].[Online Retail]
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
RFM AS (
    SELECT 
        r.CustomerID,
        r.Recency,
        f.Frequency,
        m.Monetary
    FROM RecencyCTE r
    JOIN FrequencyCTE f ON r.CustomerID = f.CustomerID
    JOIN MonetaryCTE m ON r.CustomerID = m.CustomerID
)
SELECT * INTO RFM_Table_SQL FROM RFM;

WITH ScoredRFM AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY Recency DESC) AS R_Score,       -- lower recency = better
        NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score_Rev,  -- reverse first
        NTILE(4) OVER (ORDER BY Monetary ASC) AS M_Score_Rev
    FROM RFM_Table_SQL
)
SELECT CustomerID, Recency, Frequency, Monetary,
       (5 - R_Score) AS R_Score, -- reverse so higher score = better
       F_Score_Rev AS F_Score,
       M_Score_Rev AS M_Score,
       CAST((5 - R_Score) AS VARCHAR) + 
       CAST(F_Score_Rev AS VARCHAR) + 
       CAST(M_Score_Rev AS VARCHAR) AS RFM_Segment
INTO Final_RFM_Segmentation
FROM ScoredRFM;

SELECT * FROM Final_RFM_Segmentation;

