--SQL for Devs Midterms 2/7
--2. Write a script with the following criteria (4 pts):
--a. Query all Products from Baldwin Bikes store with the model year of 2017 to 2018
--b. Query should return the following fields: Product Id, Product Name, Brand Name, Category Name and Quantity
--c. Result set should be sorted from the highest quantity, Product Name, Brand Name and Category Name

select    p.ProductId
		, p.ProductName
		, b.BrandName
		, c.CategoryName
		, stock.Quantity
		
FROM      [dbo].[Product] p
JOIN      [dbo].[Stock] stock on p.ProductId = Stock.ProductId
JOIN      [dbo].[Store] store on stock.StoreId = store.StoreId
JOIN      [dbo].[Brand] b on p.BrandId = b.BrandId
JOIN      [dbo].[Category] c on p.CategoryId = c.CategoryId

WHERE     store.StoreName = 'Baldwin Bikes'

ORDER BY  stock.Quantity DESC
        , p.ProductName
		, b.BrandName
		, c.CategoryName