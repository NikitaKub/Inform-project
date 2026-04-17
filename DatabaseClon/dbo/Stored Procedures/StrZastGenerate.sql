CREATE PROCEDURE [dbo].[StrZastGenerate] 
AS
BEGIN
	DELETE FROM StrZast
	
	DECLARE
		@CdVyr varchar(10),
		@CdSb varchar(10),
		@CdKp varchar(10),
		@QtyKp int,
		@RivNb int,
		@RivGrf varchar(10);

	DECLARE cursor_StrZast CURSOR
	FOR SELECT
			CdVyr,
			CdKp,
			CdSb,
			QtyKp,
			RivNb,
			RivGrf
		FROM
			StrRozv
		order by CdVyr, CdKp;

	OPEN cursor_StrZast
	FETCH NEXT FROM cursor_StrZast INTO
		@CdVyr,
		@CdKp,
		@CdSb,
		@QtyKp,
		@RivNb,
		@RivGrf;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO STRZast 
				VALUES(@CdVyr, @CdKp, @CdSb, @QtyKp, @RivNb, @RivGrf)
			FETCH NEXT FROM cursor_StrZast 
				INTO @CdVyr, @CdKp, @CdSb, @QtyKp, @RivNb, @RivGrf
		END
	CLOSE cursor_StrZast

	DEALLOCATE cursor_StrZast
END
