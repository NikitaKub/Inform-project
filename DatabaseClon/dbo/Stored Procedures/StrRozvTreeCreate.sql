CREATE PROCEDURE [dbo].[StrRozvTreeCreate]
(
	@CdVyr varchar(10),
	@CdSb varchar(10),
	@CdKp varchar(10),
	@QtyKp int,
	@RivNb int,
	@RivGrf varchar(10)
)
AS
BEGIN
	INSERT INTO StrRozv 
	VALUES
	(
		@CdVyr,
		@CdSb,
		@CdKp,
		@QtyKp,
		@RivNb,
		@RivGrf
	)
	IF EXISTS(SELECT TOP 1 * FROM StrRozvCTETemp WHERE (CdVyr = @CdVyr) AND (CdSb = @CdKp) AND (RivNb = @RivNb + 1))
	BEGIN
		DECLARE
			@CdVyrTemp varchar(10),
			@CdSbTemp varchar(10),
			@CdKpTemp varchar(10),
			@QtyKpTemp int,
			@RivNbTemp int,
			@RivGrfTemp varchar(10)
		SELECT TOP 1 @CdVyrTemp = CdVyr, @CdSbTemp = CdSb, @CdKpTemp = CdKp, @QtyKpTemp = QtyKp, @RivNbTemp = RivNb, @RivGrfTemp = RivGrf
		FROM StrRozvCTETemp WHERE (CdVyr = @CdVyr) AND (CdSb = @CdKp) AND (RivNb = @RivNb + 1)
		EXEC StrRozvTreeCreate @CdVyrTemp, @CdSbTemp, @CdKpTemp, @QtyKpTemp, @RivNbTemp, @RivGrfTemp
	END
	INSERT INTO StrRozv 
		SELECT * 
		FROM StrRozvCTETemp 
		WHERE (CdVyr = @CdVyr) AND (CdSb = @CdKp) AND (RivNb = @RivNb + 1) 
		EXCEPT (SELECT TOP 1 * 
		FROM StrRozvCTETemp 
		WHERE (CdVyr = @CdVyr) AND (CdSb = @CdKp) AND (RivNb = @RivNb + 1))
		ORDER BY CdVyr, RivNb, CdSb 
END
