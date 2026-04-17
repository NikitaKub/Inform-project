CREATE PROCEDURE [dbo].[SumRozvGenerate] 
AS
BEGIN
	DELETE FROM SumRozv;

	DECLARE
		@CdVyr varchar(10),
		@CdKp varchar(10),
		@SumKp int,
		@MinRiv int,
		@CdTp int;

	DECLARE cursor_SumRozv CURSOR
	FOR SELECT
		CdVyr, 
		CdKp, 
		sum(QtyKp) as "SumKp", 
		MAX(RivNb) as "MinRiv", 
		GLPR.CdTp
		FROM
			StrRozv 
			inner join GLPR 
			on StrRozv.CdKp = GLPR.CdPr
		group by 
			CdVyr, 
			CdKp, 
			GLPR.CdTp 
		order by 
			CdVyr;

	OPEN cursor_SumRozv
	FETCH NEXT FROM cursor_SumRozv INTO
		@CdVyr,
		@CdKp,
		@SumKp,
		@MinRiv,
		@CdTp;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO SumRozv 
				VALUES(@CdVyr, @CdKp, @SumKp, @MinRiv, @CdTp)
			FETCH NEXT FROM cursor_SumRozv 
				INTO @CdVyr, @CdKp, @SumKp, @MinRiv, @CdTp
		END
	CLOSE cursor_SumRozv

	DEALLOCATE cursor_SumRozv
END
