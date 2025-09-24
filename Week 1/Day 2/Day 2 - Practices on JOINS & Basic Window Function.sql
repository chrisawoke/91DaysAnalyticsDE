-- Day 2: Multi-Table Joins & Window Functions

/*
My Goal for Today:
- Strengthen SQL joins with multiple dimensions
- Understand window functions deeply
- Practice ranking, running totals, comparisons
- Keep theory + practice together for review
*/

-- 1. THEORY: Joins vs Window Functions
/*
GROUP BY: collapses rows, only shows aggregates per group.
WINDOW FUNCTIONS: keep all rows but add group-level or row-level insights.

Key syntax:
    <function>() OVER(
        PARTITION BY <column(s)>
        ORDER BY <column(s)>
    )

PARTITION BY: creates groups (like GROUP BY but without collapsing rows).
ORDER BY: defines the sequence within each group (needed for rankings, running totals, etc).

✅3 Types of Window Functions:
- Aggregate: SUM(), AVG(), MIN(), MAX(), COUNT() with OVER()
- Ranking: ROW_NUMBER(), RANK(), DENSE_RANK()
- Value-based: LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()
*/

-- 2. PRACTICE SECTION (Build upon yesterday's practice)
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
ORDER BY TotalSales DESC;

-- B: Window Functions

-- Task 3: Find total of sales per customer
SELECT
    f.SalesOrderNumber,
    f.SalesAmount,
    f.OrderDateKey,
    c.CustomerKey,
    SUM(f.SalesAmount) OVER (
        PARTITION BY c.CustomerKey
        ORDER BY f.OrderDateKey
    ) AS TotalSales
FROM FactInternetSales f
INNER JOIN DimCustomer c 
    ON f.CustomerKey = c.CustomerKey;

-- Task 4: Compare each order to the product average
SELECT
    f.SalesOrderNumber,
    p.EnglishProductName,
    f.SalesAmount,
    AVG(f.SalesAmount) OVER (PARTITION BY p.ProductKey) AS AvgProductSales,
    CASE
        WHEN f.SalesAmount >= AVG(f.SalesAmount) OVER (PARTITION BY p.ProductKey)
            THEN 'Above Avg'
        ELSE 'Below Avg'
    END AS Comparison
FROM FactInternetSales f
INNER JOIN DimProduct p 
    ON f.ProductKey = p.ProductKey;