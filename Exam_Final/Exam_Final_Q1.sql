--SQL for Devs Finals 1/5
----1. Implement a stored procedure that creates a new Brand and move all the Products of an existing brand (3 pts):
------a. SP Name: CreateNewBrandAndMoveProducts; Parameters: New Brand Name, Old BrandId
------b. Move all products of the existing brand to the new brand
------c. Delete the existing brand
------d. Include transactions to catch errors
------e. If there is an error – rollback the transaction

CREATE PROCEDURE dbo.CreateNewBrandAndMoveProducts  --exec dbo.CreateNewBrandAndMoveProducts @NewBrandName = 'Trek_V2', @OldBrandId = 9;
@NewBrandName varchar(255) = NULL, 
@OldBrandId INT
AS
BEGIN TRY
    BEGIN TRANSACTION

    --Insert new brand name
	INSERT INTO dbo.Brand
	SELECT @NewBrandName

	--All products of the existing brand to the new brand
	UPDATE dbo.Product
	SET BrandId = (SELECT TOP 1 BrandId from dbo.Brand WHERE BrandName = @NewBrandName)
	WHERE BrandId = @OldBrandId

	--Delete the existing brand
	DELETE FROM dbo.Brand
	WHERE BrandId = @OldBrandId

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    DECLARE 
        @ErrorMessage NVARCHAR(4000),
        @ErrorSeverity INT,
        @ErrorState INT;
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();
    RAISERROR (
        @ErrorMessage,
        @ErrorSeverity,
        @ErrorState    
        );
	IF(@@TRANCOUNT > 0)
		ROLLBACK TRANSACTION
END CATCH

SET NOCOUNT ON
GO