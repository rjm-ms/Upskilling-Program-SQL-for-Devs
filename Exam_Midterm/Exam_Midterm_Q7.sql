--SQL for Devs Midterms 7/7
--7. Create a script using a PIVOT operator to get the monthly sales
--a. Use Order and OrderItem table

SELECT    SalesYear
		, ISNULL(Jan,0) AS Jan
		, ISNULL(Feb,0) AS Feb
		, ISNULL(Mar,0) AS Mar
		, ISNULL(Apr,0) AS Apr
		, ISNULL(May,0) AS May
		, ISNULL(Jun,0) AS Jun
		, ISNULL(Jul,0) AS Jul
		, ISNULL(Aug,0) AS Aug
		, ISNULL(Sep,0) AS Sep
		, ISNULL(Oct,0) AS Oct
		, ISNULL(Nov,0) AS Nov
		, ISNULL(Dec,0) AS Dec
FROM (
	SELECT  * FROM (
	SELECT    LEFT(DateName(month, DateAdd(MONTH, MONTH(o.OrderDate) , 0 ) - 1 ), 3) AS SalesMonth
			, YEAR(o.OrderDate) as SalesYear
			, oi.ListPrice AS ListPrice
	FROM      [dbo].[Order] o
	JOIN      [dbo].[OrderItem] oi on o.OrderId = oi.OrderId
	) Sales
	PIVOT (  
		SUM([ListPrice])
		FOR [SalesMonth]
		IN ( [Jan], [Feb], [Mar], [Apr], [May], [Jun], [Jul], [Aug], [Sep], [Oct], [Nov], [Dec] )
	) AS PivotTable
) AS Final
ORDER BY   SalesYear 
