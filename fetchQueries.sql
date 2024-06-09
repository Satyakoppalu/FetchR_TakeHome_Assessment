# 1. What are the top 5 brands by receipts scanned for most recent month?
WITH cte1 AS(SELECT month, year
FROM dates 
ORDER BY date DESC
LIMIT 1
),
 cte2 AS(
SELECT dateId
FROM dates
WHERE (month, year) = (SELECT month, year FROM cte1)
),
cte3 AS(
SELECT name, COUNT(DISTINCT receiptId) AS n_scanned_receipts, DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT receiptId) DESC) AS ranking
FROM brands
JOIN itemslist
USING(barcode)
JOIN points
USING(receiptId)
WHERE dateScannedId IS NOT NULL AND dateScannedId IN(SELECT * FROM cte2)
GROUP BY 1
)
# Query to get brand ranking for the most recent month
SELECT name, n_scanned_receipts
FROM cte3
WHERE ranking<=5;

# 2. How does the rankings of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
WITH cte1 AS(SELECT month, year
FROM dates 
ORDER BY date DESC
LIMIT 1
),
 cte2 AS(
SELECT dateId
FROM dates
WHERE (month, year) = (SELECT month-1, year FROM cte1)
),
cte3 AS(
SELECT name, COUNT(DISTINCT receiptId) AS n_scanned_receipts, DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT receiptId) DESC) AS ranking
FROM brands
JOIN itemslist
USING(barcode)
JOIN points
USING(receiptId)
WHERE dateScannedId IS NOT NULL AND dateScannedId IN(SELECT * FROM cte2)
GROUP BY 1
)
# Query to get brand rankings for the 2nd most recent month. Answer for this question would depend on the outputs of Q1 and Q2
SELECT name, n_scanned_receipts
FROM cte3
WHERE ranking<=5;


# 3. What are the top 5 brands by receipts scanned for most recent month?
SELECT rewardsReceiptStatus, AVG(totalSpent) AS average_spend, RANK() OVER(ORDER BY AVG(totalSpent) DESC) AS ranking
FROM points p 
JOIN receipts r 
USING(receiptId)
WHERE LOWER(rewardsReceiptStatus) LIKE '%accepted%' OR LOWER(rewardsReceiptStatus) LIKE '%rejected%'
GROUP BY 1;


# 4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT rewardsReceiptStatus, SUM(purchaseItemCount) AS total_item_count, RANK() OVER(ORDER BY SUM(purchaseItemCount) DESC) AS ranking
FROM points p 
JOIN receipts r 
USING(receiptId)
WHERE LOWER(rewardsReceiptStatus) LIKE '%accepted%' OR LOWER(rewardsReceiptStatus) LIKE '%rejected%'
GROUP BY 1;


# 5. Which brand has the most spend among users who were created within the past 6 months?
 WITH cte1 AS(
 SELECT receiptId
 FROM points
 JOIN users
 USING(userId)
 WHERE DATEDIFF(CURRENT_TIMESTAMP, users.createdDate) <=180
 ),
 cte2 AS(SELECT name, SUM(totalSpent) AS total_spent, RANK() OVER(ORDER BY SUM(totalSpent) DESC) AS ranking
 FROM brands
 JOIN itemslist
 USING(barcode)
 JOIN points 
 USING(receiptId)
 WHERE receiptId IN (SELECT * FROM cte1)
 GROUP BY brandId)
 
 SELECT name, total_spent
 FROM cte2
 WHERE ranking=1;
 
 
# 6. Which brand has the most transactions among users who were created within the past 6 months?
WITH cte1 AS(
 SELECT receiptId
 FROM points
 JOIN users
 USING(userId)
 WHERE DATEDIFF(CURRENT_TIMESTAMP, users.createdDate) <=180
 ),
 cte2 AS(SELECT name, COUNT(DISTINCT receiptId) AS total_transactions, RANK() OVER(ORDER BY COUNT(DISTINCT receiptId) DESC) AS ranking
 FROM brands
 JOIN itemslist
 USING(barcode)
 JOIN points 
 USING(receiptId)
 WHERE receiptId IN (SELECT * FROM cte1)
 GROUP BY brandId)
 
 SELECT name, total_transactions
 FROM cte2
 WHERE ranking=1;
 
 
 
 
 