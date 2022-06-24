--SQL for Devs Finals 2/5
--2. Implement a stored procedure that returns a list of products with the following requirements (6 pts):
----a. Supports filtering:
------i. Filter products by product name
------ii. Filter by brand id
------iii. Filter by category id 
------iv. Filter by model year
----b. Supports pagination (Default page size: 10)
----c. Result set should always be sorted by Latest Model Year, Highest List Price and Product Name

CREATE PROCEDURE dbo.GetProductList --exec dbo.GetProductList @ProductName = 'Trek', @Pageindex = 1;
@ProductName varchar(255) = NULL, 
@BrandId INT = NULL, 
@CategoryId INT = NULL, 
@ModelYear INT = NULL,
@Pageindex INT = 1

AS
BEGIN
DECLARE @PageStart INT = NULL
DECLARE @PageSize INT = 10
DECLARE @PageEnd INT = NULL

 SELECT   
   @PageStart = CASE WHEN @Pageindex > 1   
          THEN   
      ((@Pageindex-1)*@PageSize)+1    
       ELSE   
      @Pageindex   
     END   

 SET @PageEnd = @Pageindex*@PageSize  
-- use cte 
;WITH CTE AS    
(    
 select p.ProductId, p.ProductName, p.BrandId, b.BrandName, p.CategoryId, c.CategoryName, p.ModelYear, p.ListPrice 
 from dbo.Product p JOIN dbo.Brand b on p.BrandId = b.BrandId JOIN dbo.Category c on p.CategoryId = c.CategoryId 
 Where p.ProductName LIKE '%'+COALESCE(@ProductName, p.ProductName)+'%'
 AND p.BrandId = COALESCE(@BrandId, p.BrandId)
 AND p.ModelYear = COALESCE(@ModelYear, p.ModelYear)
)    
--now use cte with rownumber filter
select ProductId, ProductName, BrandId, BrandName, CategoryId, CategoryName, ModelYear, ListPrice  
from  
(  
 SELECT ROW_NUMBER() OVER (ORDER BY ModelYear DESC, ListPrice DESC, ProductName ASC) as rowID,
 *, noofRows= (SELECT count(ProductId) FROM CTE)    
 FROM CTE   
 where CTE.ProductId is not null  
) cte  
WHERE    
 rowID between @PageStart AND @PageEnd

END 

SET NOCOUNT ON
GO