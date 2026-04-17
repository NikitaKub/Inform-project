CREATE PROCEDURE SumZastGenerate
AS
BEGIN
	DELETE FROM SumZast;

	DECLARE
		@CdVyr varchar(10),
		@CdKp varchar(10),
		@SumKp int,
		@MinRiv int,
		@CdTp int;

	DECLARE cursor_SumZast CURSOR
	FOR SELECT
		CdVyr, 
		CdKp, 
		sum(QtyKp) as "SumKp", 
		MAX(RivNb) as "MinRiv", 
		GLPR.CdTp
		FROM
			StrZast 
			inner join GLPR 
			on StrZast.CdKp = GLPR.CdPr
		group by 
			CdVyr, 
			CdKp, 
			GLPR.CdTp 
		order by 
			CdVyr;

	OPEN cursor_SumZast
	FETCH NEXT FROM cursor_SumZast INTO
		@CdVyr,
		@CdKp,
		@SumKp,
		@MinRiv,
		@CdTp;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO SumZast 
				VALUES(@CdVyr, @CdKp, @SumKp, @MinRiv, @CdTp)
			FETCH NEXT FROM cursor_SumZast 
				INTO @CdVyr, @CdKp, @SumKp, @MinRiv, @CdTp
		END
	CLOSE cursor_SumZast

	DEALLOCATE cursor_SumZast
END
