-- Task: Who are our most valuable customers when we look at all the money they’ve ever spent with us?
-- What to do: Rank customers by total spend across all years
SELECT
	c.CustomerKey,
	CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
	SUM(f.SalesAmount) AS Totalspend,
	RANK() OVER(ORDER BY SUM(f.SalesAmount) DESC) AS SpendRank
FROM FactInternetSales f
INNER JOIN DimCustomer c
	ON f.CustomerKey = c.CustomerKey
GROUP BY
	c.CustomerKey, c.FirstName, c.LastName
ORDER BY
	SpendRank;

/*Task 2: For each product, calculate the average sales 
per order and show each order with a flag AboveAverage if it exceeds 
the product average.*/

