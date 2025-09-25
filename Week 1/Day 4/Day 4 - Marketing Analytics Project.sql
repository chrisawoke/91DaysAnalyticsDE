-- Key Task: clean the dataset and get it ready for analysis

/*Do the following:
1. Write a query to join customer and geography tables (it's good for the Dmodel in BI)
2. Write a query to categorize the products based on price
3. Clean & standardize the engagement data table
4. Remove whitespaces from the customer_reviews table (ReviewText column)
5. 
*/

-- Task 1: 
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

-- Task 2:
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

