--Assignment 1/2
--1. Write a query that would return customer order records with the following criteria: 
---- a. Use [dbo].[Order] table to query the result 
---- b. List of customer ids with total number of orders for the year 2017 and 2018. 
---- c. Customer�s orders should be at least 2 
---- d. Orders should not have been shipped yet 
---- e. Fields to return: CustomerId and OrderCount 

SELECT    CustomerId
		, Count(OrderId) AS OrderCount 
FROM      [dbo].[Order]
WHERE     (OrderDate >= '2017-01-01' AND OrderDate < '2019-01-01')
	AND   ShippedDate IS NULL
GROUP BY  CustomerId
HAVING Count(OrderId) > 1 
