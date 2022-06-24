--SQL for Devs Finals 4/5
--4. Implement customer ranking (7 points)

----a. Create a table called ‘Ranking’ with two columns – Id (primary key, identity), and Description.
CREATE TABLE [dbo].[Ranking] (
    [Id] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Description] VARCHAR (250) NULL,
    CONSTRAINT [PK_Ranking] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO;

----b. Populate table Ranking with the following data
--------Id Description
--------1 Inactive
--------2 Bronze
--------3 Silver
--------4 Gold
--------5 Platinum
INSERT [dbo].[Ranking] SELECT N'Inactive'
INSERT [dbo].[Ranking] SELECT N'Bronze'
INSERT [dbo].[Ranking] SELECT N'Silver'
INSERT [dbo].[Ranking] SELECT N'Gold'
INSERT [dbo].[Ranking] SELECT N'Platinum'

----c. Add a column to Customer table called RankingId and make it a foreign key to Ranking.Id
ALTER TABLE [dbo].[Customer]
ADD RankingId INT CONSTRAINT [FK_Customer_Ranking] FOREIGN KEY ([RankingId]) REFERENCES [dbo].[Ranking] ([Id])
GO;

----d. Create a stored procedure uspRankCustomers that will populate Customer.RankingId
--------column:
--------i. Get the total amount of orders purchased by the customer (TotalAmount = (OrderItem.Quantity * OrderItem.ListPrice) / (1 + OrderItem.Discount))
--------ii. If TotalAmount = 0, then set RankingId to 1
--------iii. If TotalAmount < 1000, then set RankingId to 2
--------iv. If TotalAmount < 2000, then set RankingId to 3
--------v. If TotalAmount < 3000, then set RankingId to 4
--------vi. If TotalAmount >= 3000, then set RankingId to 5
CREATE PROCEDURE dbo.uspRankCustomers  --exec dbo.uspRankCustomers;
AS
UPDATE c
	SET c.RankingId = 
	CASE WHEN summary.TotalAmount = 0 THEN 1
		 WHEN summary.TotalAmount < 1000 THEN 2
		 WHEN summary.TotalAmount < 2000 THEN 3
		 WHEN summary.TotalAmount < 3000 THEN 4
		 WHEN summary.TotalAmount >= 3000 THEN 5
	ELSE 
		c.RankingId
	END
FROM Customer c
JOIN (
	SELECT  c.CustomerId
          , COALESCE(SUM((oi.Quantity * oi.ListPrice) / (1 + oi.Discount)),0) as TotalAmount
	FROM Customer c
	LEFT JOIN [Order] o on c.CustomerId = o.CustomerId
	LEFT JOIN OrderItem oi on o.OrderId = oi.OrderId
	GROUP BY c.CustomerId	
) summary on c.CustomerId = summary.CustomerId
GO;

----e. Create a view vwCustomerOrders that will display -
--------i. CustomerId,
--------ii. FirstName
--------iii. LastName
--------iv. TotalAmount (sum of TotalAmount)
--------v. CustomerRanking (Ranking.Description)
CREATE VIEW dbo.vwCustomerOrders AS --SELECT * FROM dbo.vwCustomerOrders ORDER BY CustomerId
SELECT c.CustomerId
	 , c.FirstName
	 , c.LastName
	 , COALESCE(SUM((oi.Quantity * oi.ListPrice) / (1 + oi.Discount)),0) as TotalAmount
	 , r.Description as CustomerRanking

FROM Customer c
LEFT JOIN [Order] o on c.CustomerId = o.CustomerId
LEFT JOIN OrderItem oi on o.OrderId = oi.OrderId
JOIN Ranking r on c.RankingId = r.Id
	
GROUP BY c.CustomerId
	   , c.FirstName
	   , c.LastName
	   , r.Description

