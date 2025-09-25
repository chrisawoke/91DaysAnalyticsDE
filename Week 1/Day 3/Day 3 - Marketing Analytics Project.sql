-- Key Task: clean the dataset and get it ready for analysis
/*Do the following:
1. Write a query to categorize the products based on price
2. 
*/
SELECT 
	ProductID,
	ProductName,
	Price,
	CASE
		WHEN Price < 50 THEN 'Low'
		WHEN Price BETWEEN 50 AND 200 THEN 'Medium'
		ELSE 'High'
	END AS PriceCategory
FROM dbo.products
ORDER BY Price DESC

-- Write a query to join customer and geography
SELECT
	c.CustomerName,
    c.Email,
    c.Gender,
    c.Age,
    g.Country,
    g.City
FROM dbo.customers c
LEFT JOIN dbo.geography g
ON c.GeographyID = g.GeographyID