--5. Using the script from #3, use a cursor to print the records following the format below (3 pts):

DECLARE   @StoreName VARCHAR(255)
	    , @OrderYear VARCHAR(4)
	    , @OrderCount INT
	    , @Ctr INT = 1;

DECLARE   storeCursor CURSOR FOR

--Script from #3 Start
select    s.StoreName
		, YEAR(o.OrderDate) as OrderYear
		, COUNT(o.OrderId) as OrderCount
		
FROM      [dbo].[Store] s
JOIN      [dbo].[Order] o on s.StoreId = o.StoreId

GROUP BY  s.StoreName
        , YEAR(o.OrderDate) 

ORDER BY  s.StoreName
        , YEAR(o.OrderDate) DESC
--Script from #3 End

OPEN storeCursor; 
FETCH NEXT FROM storeCursor 
INTO @StoreName, @OrderYear, @OrderCount;

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CAST(CONCAT(@StoreName,' ', @OrderYear,' ', @OrderCount) AS VARCHAR(50))
	SELECT @Ctr = @Ctr + 1
	FETCH NEXT FROM storeCursor 
	INTO @StoreName, @OrderYear, @OrderCount;

END;
CLOSE storeCursor; 
DEALLOCATE storeCursor;