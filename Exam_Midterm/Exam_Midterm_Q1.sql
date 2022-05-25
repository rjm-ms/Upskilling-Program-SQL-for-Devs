--SQL for Devs Midterms 1/7
--1. Write a script that would return the id and name of the store that does NOT have any Order record (1 pt).

select    s.StoreId
		, s.StoreName
		, o.OrderId
		
FROM      [dbo].[Store] s
LEFT JOIN [dbo].[Order] o on s.StoreId = o.StoreId

WHERE     o.OrderId is NULL