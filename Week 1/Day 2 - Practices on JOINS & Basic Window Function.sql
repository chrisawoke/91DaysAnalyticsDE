-- Day 2: Multi-Table Joins & Window Functions

/*
Goal:
- Strengthen SQL joins with multiple dimensions
- Understand window functions deeply
- Practice ranking, running totals, comparisons
- Keep theory + practice together for review
*/

-- Task 1: List each internet order with customer full name, product name, and territory name.
SELECT
	f.SalesOrderNumber,
	CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
	p.EnglishProductName AS ProductName,
	s.SalesTerritoryRegion AS TerritoryName,
	f.SalesAmount
FROM FactInternetSales f
INNER JOIN DimCustomer c
	ON f.CustomerKey = c.CustomerKey
INNER JOIN DimProduct p
	ON f.ProductKey = p.ProductKey
INNER JOIN DimSalesTerritory s
	ON f.SalesTerritoryKey = s.SalesTerritoryKey;

-- Task 2: Show total sales per customer by territory
SELECT
	CONCAT(c.FirstName, ' ', c.LastName) AS Customer,
	s.SalesTerritoryRegion AS Territory,
	SUM(f.SalesAmount) AS TotalSales
FROM FactInternetSales f
INNER JOIN DimCustomer c
	ON f.CustomerKey = c.CustomerKey
INNER JOIN DimSalesTerritory s
	ON f.SalesTerritoryKey = s.SalesTerritoryKey
GROUP BY
	CONCAT(c.FirstName, ' ', c.LastName),
	s.SalesTerritoryRegion
ORDER BY
	TotalSales DESC;


