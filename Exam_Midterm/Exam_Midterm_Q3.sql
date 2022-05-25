--SQL for Devs Midterms 3/7
--3. Write a script with the following criteria (3 pts):
--a. Return the total number of orders per year and store name
--b. Query should return the following fields: Store Name, Order Year and the Number of Orders of that year
--c. Result set should be sorted by Store Name and most recent order year

select    s.StoreName
	, YEAR(o.OrderDate) as OrderYear
	, COUNT(o.OrderId) as OrderCount
		
FROM      [dbo].[Store] s
JOIN      [dbo].[Order] o on s.StoreId = o.StoreId

GROUP BY  s.StoreName
        , YEAR(o.OrderDate) 

ORDER BY  s.StoreName
        , YEAR(o.OrderDate) DESC