----------------------------------------
--Assignment #2:
----------------------------------------
--1. Display the total number of items sold per PRODUCT from orders in the database with the following requirements:
--a) Only count orders from TX state
--b) Total items sold per product should be greater than 10
--c) Sort by total units sold from highest to lowest
--d) Return columns should include: ProductName, TotalQuantity
select    p.ProductName
		, SUM(oi.Quantity) as TotalQuantity
		
FROM      [dbo].[Order] o
JOIN      [dbo].[OrderItem] oi on o.OrderId = oi.OrderId
JOIN      [dbo].[Product] p on oi.ProductId = p.ProductId
JOIN      [dbo].[Store] s on o.StoreId = s.StoreId
WHERE     s.State = 'TX'
GROUP BY  p.ProductName
HAVING SUM(oi.Quantity) > 10
ORDER BY SUM(oi.Quantity) DESC

--2. Display the total number of items sold per CATEGORY from orders in the database with the following requirements:
--a) For categories with "Bikes" on the name, make it Bicycle instead (ex. "Road Bikes" will be "Road Bicycles" instead)
--b) Sort by total units sold from highest to lowest
--c) Return columns should include: CategoryName, TotalQuantity

WITH cteUpdatedCategory AS
(
	SELECT    CategoryId
		    , CategoryName as OldCategoryName
		    , CASE WHEN CategoryName LIKE '%Bikes%'
			       THEN REPLACE(CategoryName,'Bikes', 'Bicycles')
			  ELSE CategoryName
		      END AS CategoryName
	FROM      [dbo].[Category]
)
SELECT    c.CategoryName
		, SUM(oi.Quantity) as TotalQuantity
FROM      [dbo].[OrderItem] oi
JOIN      [dbo].[Product] p on oi.ProductId = p.ProductId
JOIN      cteUpdatedCategory c on p.CategoryId = c.CategoryId
GROUP BY  c.CategoryName
ORDER BY  SUM(oi.Quantity) desc

--3. Merge the results of items #1 and #2:
--a) Sort by total units sold from highest to lowest

WITH cteUpdatedCategory AS
(
	SELECT CategoryId
		, CategoryName as OldCategoryName
		, CASE WHEN CategoryName LIKE '%Bikes%'
			THEN REPLACE(CategoryName,'Bikes', 'Bicycles')
		  ELSE CategoryName
		  END AS CategoryName
	FROM [dbo].[Category]
)
SELECT *  FROM (
select    p.ProductName
		, SUM(oi.Quantity) as TotalQuantity
		
FROM      [dbo].[Order] o
JOIN      [dbo].[OrderItem] oi on o.OrderId = oi.OrderId
JOIN      [dbo].[Product] p on oi.ProductId = p.ProductId
JOIN      [dbo].[Store] s on o.StoreId = s.StoreId
WHERE     s.State = 'TX'
GROUP BY  p.ProductName
HAVING    SUM(oi.Quantity) > 10

UNION ALL

SELECT    c.CategoryName
		, SUM(oi.Quantity) as TotalQuantity
FROM      [dbo].[OrderItem] oi
JOIN      [dbo].[Product] p on oi.ProductId = p.ProductId
JOIN      cteUpdatedCategory c on p.CategoryId = c.CategoryId
GROUP BY  c.CategoryName
) a
ORDER BY  TotalQuantity Desc

--4. For all orders in the database, retrieve the top selling product per month year with the following requirements:
--a) Return columns should include: OrderYear, OrderMonth, ProductName, TotalQuantity
--b) Sort the result by Year and Month in ascending order
--c) In cases where there are more than 1 top-selling product in a month, we should display ALL products in TOP 1 position

WITH ctePre AS (
	SELECT    ROW_NUMBER() OVER (ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)) AS RowId
		    , YEAR(o.OrderDate) as OrderYear
		    , MONTH(o.OrderDate) as OrderMonthId
		    , p.ProductName AS ProductName
		    , SUM(oi.Quantity) AS TotalQuantity
	FROM      [dbo].[OrderItem] oi
	JOIN      [dbo].[Order] o ON oi.OrderId = o.OrderId
	JOIN      [dbo].[Product] p ON oi.ProductId = p.ProductId
	GROUP BY  YEAR(o.OrderDate)
		    , MONTH(o.OrderDate)
		    , p.ProductName
)

, cteFinal AS (
	SELECT    RANK() OVER (PARTITION BY OrderYear, OrderMonthId ORDER BY TotalQuantity DESC) AS RankId
	          , *
	FROM      ctePre 
)
SELECT    OrderYear
		, DateName(month, DateAdd(MONTH, OrderMonthId , 0 ) - 1 ) AS OrderMonth
		, ProductName
		, TotalQuantity
FROM      cteFinal
WHERE     RankId = 1
ORDER BY  OrderYear
        , OrderMonthId
