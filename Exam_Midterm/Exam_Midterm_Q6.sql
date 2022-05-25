--SQL for Devs Midterms 6/7
--6. Create a script with one loop is nested within another to output the multiplication tables for the numbers one to ten

DECLARE   @Ctr INT = 1
        , @Multiplicand INT = 1
		, @Multiplier INT = 1;

WHILE @Multiplicand <= 10
BEGIN
	PRINT CAST(CONCAT(@Multiplicand,' * ', @Multiplier,' = ', @Multiplicand * @Multiplier) AS VARCHAR(15))
	IF @Ctr = 10
	BEGIN
		SELECT @Multiplicand = @Multiplicand + 1, @Ctr = 0
	END
	SELECT @Ctr = @Ctr + 1, @Multiplier = @Ctr
END;