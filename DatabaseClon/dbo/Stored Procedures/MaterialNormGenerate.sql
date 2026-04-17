CREATE PROCEDURE MaterialNormGenerate
AS
BEGIN
	DELETE FROM MaterialNorm;

	DECLARE
		@CdVyr varchar(10),
		@NmPr varchar(50),
		@CdMtr int,
		@CommMtr float

	DECLARE cursor_MaterialNorm CURSOR
	FOR SELECT 
		SR.CdVyr, 
		GL.NmPr, 
		ZM.CdMtr, 
		Sum(ZM.OtyMtr * SR.SumKp) AS CommMtr 
		FROM (SELECT * FROM SumRozv WHERE CdTp = 3) AS SR 
			inner join ZastMtr AS ZM ON SR.CdKp = ZM.CdKp 
			inner join GLPR AS GL ON SR.CdVyr = GL.CdPr 
		GROUP BY 
			CdVyr, 
			CdMtr, 
			NmPr 
		ORDER BY 
			CdVyr;

	OPEN cursor_MaterialNorm
	FETCH NEXT FROM cursor_MaterialNorm INTO
		@CdVyr,
		@NmPr,
		@CdMtr,
		@CommMtr;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO MaterialNorm 
				VALUES(@CdVyr, @NmPr, @CdMtr, @CommMtr)
			FETCH NEXT FROM cursor_MaterialNorm 
				INTO @CdVyr, @NmPr, @CdMtr, @CommMtr
		END
	CLOSE cursor_MaterialNorm

	DEALLOCATE cursor_MaterialNorm
END
