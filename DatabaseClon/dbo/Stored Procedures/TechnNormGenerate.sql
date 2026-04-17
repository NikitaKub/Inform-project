CREATE PROCEDURE TechnNormGenerate
AS
BEGIN
	DELETE FROM TechnNorm;

	DECLARE
		@CdVyr varchar(10),
		@CdTO varchar(10),
		@NmTO varchar(50),
		@SumGodin float;

	DECLARE cursor_TechnNorm CURSOR
	FOR SELECT
		S.CdVyr,
		P.CdTO,
		D.NmTO,
		Sum(P.Godin) AS SumGodin
		FROM 
			SumRzvT as S 
			inner join PTRN AS P ON S.CdKp = P.CdPr
			inner join DovTO AS D ON P.CdTO = D.CdTO
		GROUP BY 
			S.CdVyr, P.CdTO, D.NmTO
		ORDER BY 
			S.CdVyr, P.CdTO;

	OPEN cursor_TechnNorm
	FETCH NEXT FROM cursor_TechnNorm INTO
		@CdVyr,
		@CdTO,
		@NmTO,
		@SumGodin;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO TechnNorm 
				VALUES(@CdVyr, @CdTO, @NmTO, @SumGodin)
			FETCH NEXT FROM cursor_TechnNorm 
				INTO @CdVyr, @CdTO, @NmTO, @SumGodin
		END
	CLOSE cursor_TechnNorm

	DEALLOCATE cursor_TechnNorm
END
