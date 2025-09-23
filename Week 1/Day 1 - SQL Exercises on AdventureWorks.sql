/*
The goal is to strengthen the basics and create a solid 
starting point for the journey through the ADE challenge.
*/

-- Que 1:
SELECT 
    FirstName,
    LastName,
    GeographyKey
FROM DimCustomer;

-- Que 2: The first 20 products
SELECT TOP 20
    p.EnglishProductName AS ProductName,
    p.ProductSubcategoryKey,
    s.EnglishProductSubcategoryName
FROM DimProduct p
INNER JOIN DimProductSubcategory s
ON p.ProductSubcategoryKey = s.ProductSubcategoryKey;

-- All customers living in United States
SELECT
    c.FirstName,
    ISNULL(c.MiddleName,'') AS MiddleName,
    c.LastName,
    c.Gender,
    c.EmailAddress,
    g.City,
    g.EnglishCountryRegionName
FROM DimCustomer c
INNER JOIN DimGeography g
ON c.GeographyKey = g.GeographyKey
WHERE g.CountryRegionCode = 'US';

-- Customers by EnglishEducation
SELECT 
    EnglishEducation,
    COUNT(*) AS Num_of_Customers
FROM DimCustomer
GROUP BY EnglishEducation
ORDER BY Num_of_Customers DESC;

-- Average SalesAmount in FactInternetSales
SELECT
    ROUND(AVG(SalesAmount), 2) AS Avg_Sales
FROM FactInternetSales;

-- Total internet sales grouped by SalesTerritoryKey
SELECT
    SalesTerritoryKey,
    ROUND(SUM(SalesAmount), 2) AS Total_Internet_Sales
FROM FactInternetSales
GROUP BY SalesTerritoryKey;

-- Customer full names along with their total sales
SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    SUM(f.SalesAmount) AS TotalSales
FROM DimCustomer c
INNER JOIN FactInternetSales f
    ON c.CustomerKey = f.CustomerKey
GROUP BY CONCAT(c.FirstName, ' ', c.LastName)
ORDER BY TotalSales DESC;

-- Show products and their category name
SELECT
    p.EnglishProductName AS ProductName,
    pc.EnglishProductCategoryName AS CategoryName
FROM DimProduct p
INNER JOIN DimProductSubcategory ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN DimProductCategory pc
ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY CategoryName, ProductName;

-- All internet sales with product name, customer name, and order date
SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    p.EnglishProductName AS ProductName,
    f.SalesAmount,
    d.FullDateAlternateKey AS OrderDate
FROM FactInternetSales f
INNER JOIN DimCustomer c
    ON f.CustomerKey = c.CustomerKey
INNER JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
INNER JOIN DimDate d
    ON f.OrderDateKey = d.DateKey;

-- Product categories where total sales > 100,000
SELECT 
    pc.EnglishProductCategoryName AS CategoryName,
    SUM(f.SalesAmount) AS TotalSales
FROM FactInternetSales f
INNER JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
INNER JOIN DimProductSubcategory ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN DimProductCategory pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY 
    pc.EnglishProductCategoryName
HAVING
    SUM(f.SalesAmount) > 100000
ORDER BY TotalSales DESC;
    







