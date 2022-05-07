--Assignment 2/2
--2. Write a script with the following criteria: 
---- a. Create a backup of dbo.Product table with this format: <table name>_<yyyymmdd> and exclude records with Model Year of 2016 
DECLARE @tblProduct varchar(7)= 'Product'
DECLARE @tblProduct_bkDate varchar(17) = concat(@tblProduct,'_', convert(int, convert(varchar(10), getdate(), 112)))
print @tblProduct_bkDate
EXEC('select * into '+@tblProduct_bkDate+' from '+@tblProduct+' where ModelYear <> 2016')

---- b. Using the backup table, raise the list price of each product by 20% for "Heller" and "Sun Bicycles" brands while 10% for the other brands. 
DECLARE @backupTable varchar(17) = concat('Product_', convert(int, convert(varchar(10), getdate(), 112)))
EXEC('SELECT p.ProductId , p.ProductName , b.BrandName , p.ListPrice , 
CASE WHEN b.BrandName in (''Heller'',''Sun Bicycles'') THEN p.ListPrice + (p.ListPrice * 0.2) ELSE p.ListPrice + (p.ListPrice * 0.1) END AS AdjustedPrice 
FROM '+@backupTable+' p join Brand b on p.BrandId = b.BrandId')
