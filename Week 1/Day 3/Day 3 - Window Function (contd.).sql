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

SELECT
    p.EnglishProductName,
    f.SalesOrderNumber,
    f.SalesOrderLineNumber,
    f.SalesAmount,
    AVG(f.SalesAmount) OVER (PARTITION BY f.ProductKey) AS AvgProductSales,
    CASE
        WHEN f.SalesAmount > AVG(f.SalesAmount) OVER (PARTITION BY f.ProductKey)
        THEN 'AboveAverage'
        ELSE 'BelowAverage'
    END AS OrderPerformance
FROM FactInternetSales f
INNER JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
ORDER BY
    p.EnglishProductName,
    f.SalesAmount DESC;

-- Show top 3 products by sales for each year
SELECT
    ProductName,
    Years,
    TotalSales,
    SalesRank
FROM(
SELECT
    p.EnglishProductName AS ProductName,
    d.CalendarYear AS Years,
    SUM(f.SalesAmount) AS TotalSales,
    RANK() OVER(
        PARTITION BY d.CalendarYear 
        ORDER BY SUM(f.SalesAmount) DESC
        ) AS SalesRank
FROM FactInternetSales f
INNER JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
INNER JOIN DimDate d
    ON f.DueDateKey = d.DateKey
GROUP BY
    p.EnglishProductName,
    d.CalendarYear
) AS RankedSales
WHERE SalesRank <= 3
ORDER BY Years, SalesRank;
