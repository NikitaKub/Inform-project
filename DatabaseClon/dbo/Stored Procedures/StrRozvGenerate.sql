CREATE PROCEDURE StrRozvGenerate 
AS
BEGIN
		-- Clear Temp CTE all nods
	DELETE FROM StrRozvCTETemp; 

	-- Clear and Insert new Temp tree heads
	DELETE FROM StrRozvTemp 
	INSERT INTO StrRozvTemp SELECT TempVyr.CdVyr, Spec.CdSb, Spec.CdKp, Spec.QtyKp, 1 AS RivNb, '.1' AS RivGrf FROM Spec inner join TempVyr ON Spec.CdSb = TempVyr.CdVyr;

	-- Insert new CTE all nods
	WITH StrRozvCTE AS (

		SELECT 
			CdVyr, CdSb, CdKp, QtyKp, RivNb, RivGrf
		FROM 
			StrRozvTemp

		UNION ALL

		SELECT 
			sr.CdVyr,     
			sp.CdSb,      
			sp.CdKp,      
			sr.QtyKp * sp.QtyKp,  
			sr.RivNb + 1,  
			CAST(CONCAT(REPLACE(sr.RivGrf, CAST(sr.RivNb as varchar(10)), ''), '.', sr.RivNb + 1) AS varchar(10)) AS RivGrf
		FROM 
			StrRozvCTE sr
		JOIN 
			Spec sp ON sr.CdKp = sp.CdSb
	)
	INSERT INTO StrRozvCTETemp SELECT * FROM StrRozvCTE
	ORDER BY CdVyr, RivNb, CdSb;

	-- Create Needed StrRozv
	DECLARE
		@CdVyr varchar(10),
		@CdSb varchar(10),
		@CdKp varchar(10),
		@QtyKp int,
		@RivNb int,
		@RivGrf varchar(10);

	DELETE FROM StrRozv;

	DECLARE cursor_StrRozv CURSOR
	FOR SELECT
			CdVyr,
			CdSb,
			CdKp,
			QtyKp,
			RivNb,
			RivGrf
		FROM
			StrRozvTemp;

	OPEN cursor_StrRozv
	FETCH NEXT FROM cursor_StrRozv INTO
		@CdVyr,
		@CdSb,
		@CdKp,
		@QtyKp,
		@RivNb,
		@RivGrf;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC StrRozvTreeCreate @CdVyr, @CdSb, @CdKp, @QtyKp, @RivNb, @RivGrf
			FETCH NEXT FROM cursor_StrRozv INTO @CdVyr, @CdSb, @CdKp, @QtyKp, @RivNb, @RivGrf
		END
	CLOSE cursor_StrRozv

	DEALLOCATE cursor_StrRozv
END
