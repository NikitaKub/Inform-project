CREATE PROCEDURE [dbo].[SumRzvtGenerate] 
AS
BEGIN
	DELETE FROM SumRzvT;

	DECLARE
		@CdPr varchar(10),
		@CdTp int;

	DECLARE cursor_SumRzvT CURSOR
	FOR SELECT
		CdPr,
		CdTp
		FROM
			GLPR
		WHERE CdTp = 1;

	OPEN cursor_SumRzvT
	FETCH NEXT FROM cursor_SumRzvT INTO
		@CdPr,
		@CdTp;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO SumRzvT 
				VALUES(@CdPr, @CdPr, 1, 0, @CdTp);
			INSERT INTO SumRzvT 
				SELECT * 
					FROM SumRozv 
					WHERE CdVyr = @CdPr AND (CdTp = 2 OR CdTp = 3);
			FETCH NEXT FROM cursor_SumRzvT 
				INTO @CdPr, @CdTp
		END
	CLOSE cursor_SumRzvT

	DEALLOCATE cursor_SumRzvT
END
