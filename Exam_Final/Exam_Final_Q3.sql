--SQL for Devs Finals 3/5
--3. Improve the slow running query below: (Pre-requisite - Create a backup of the dbo.Product table) (3 pts).
--HINT: Do NOT use cursor
IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'Product_Bak'))
BEGIN
	SELECT *
	INTO dbo.Product_Bak
	FROM dbo.Product
	Print 'Product_Bak created'
END

--UPDATED QUERY
UPDATE p
	SET p.ListPrice = 
	CASE WHEN c.CategoryName IN ('Children Bicycles', 'Cyclocross Bicycles', 'Road Bikes') THEN (p.ListPrice * 1.2)
		 WHEN c.CategoryName IN ('Comfort Bicycles', 'Cruisers Bicycles', 'Electric Bikes') THEN (p.ListPrice * 1.7)
		 WHEN c.CategoryName IN ('Mountain Bikes') THEN (p.ListPrice * 1.4)
	ELSE 
		p.ListPrice
	END
FROM Product_Bak p 
JOIN Category c on p.CategoryId = c.CategoryId