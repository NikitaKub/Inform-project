CREATE PROCEDURE WorkerNormGenerate
AS
BEGIN
	DELETE FROM WorkerNorm;

	DECLARE
		@CdVyr varchar(10),
		@CdPf float,
		@NmPf varchar(100),
		@TotalGod float;

	DECLARE cursor_WorkerNorm CURSOR
	FOR SELECT 
			TN.CdVyr, 
			TP.CdPf, 
			DP.NmPf, 
			SUM(TN.SumGodin) AS TotalGod 
		FROM TechnNorm AS TN 
			INNER JOIN TO_PF AS TP ON TN.CdTO = TP.CdTO 
			INNER JOIN DovPrf AS DP ON TP.CdPf = DP.CdPf 
		GROUP BY 
			TN.CdVyr, 
			TP.CdPf, 
			DP.NmPf 
		ORDER BY 
			TN.CdVyr;

	OPEN cursor_WorkerNorm
	FETCH NEXT FROM cursor_WorkerNorm INTO
		@CdVyr,
		@CdPf,
		@NmPf,
		@TotalGod;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO WorkerNorm 
				VALUES(@CdVyr, @CdPf, @NmPf, @TotalGod)
			FETCH NEXT FROM cursor_WorkerNorm 
				INTO @CdVyr, @CdPf, @NmPf, @TotalGod
		END
	CLOSE cursor_WorkerNorm

	DEALLOCATE cursor_WorkerNorm
END
