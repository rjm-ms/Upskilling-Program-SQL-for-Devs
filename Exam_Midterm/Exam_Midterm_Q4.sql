--SQL for Devs Midterms 4/7
--4. Write a script with the following criteria (4 pts):
--a. Using a CTE and Window function, select the top 5 most expensive products per brand
--b. Data should be sorted by the most expensive product and product name

WITH cteRankedBrand AS (
	SELECT    b.BrandName
			, p.ProductId
			, p.ProductName
			, p.ListPrice
			, RANK() OVER (PARTITION BY BrandName ORDER BY ListPrice DESC, ProductName) AS RankId
	FROM      [dbo].[Brand] b
	JOIN      [dbo].[Product] p on b.BrandId = p.BrandId
)

SELECT        BrandName
			, ProductId
			, ProductName
			, ListPrice
FROM          cteRankedBrand
WHERE         RankId <= 5