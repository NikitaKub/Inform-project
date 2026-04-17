CREATE TABLE [dbo].[Spec] (
    [CdSb]  VARCHAR (10) NOT NULL,
    [CdKp]  VARCHAR (10) NOT NULL,
    [QtyKp] INT          NOT NULL
);


GO
CREATE TRIGGER [dbo].[RelationSheepRule]
ON dbo.Spec
FOR INSERT, UPDATE
AS
BEGIN
	declare @insertedCdSb char(10)
	declare @insertedCdKp char(10)
	set @insertedCdSb = (Select CdSb from Inserted)
	set @insertedCdKp = (Select CdKp from Inserted)

	IF EXISTS (Select CdPr from GLPR where CdPr = @insertedCdSb AND CdPr = @insertedCdKp) 
	BEGIN
		IF( (Select CdTp from GLPR where CdPr = @insertedCdSb) <> 1 AND (Select CdTp from GLPR where CdPr = @insertedCdSb) <> 2 )
		BEGIN
			RAISERROR('Not in CdSb[1,2]', 10, 1)
			ROLLBACK
		END
		IF( (Select CdTp from GLPR where CdPr = @insertedCdKp) <> 3 AND (Select CdTp from GLPR where CdPr = @insertedCdKp) <> 4 )
		BEGIN
			RAISERROR('Not in CdKp[3,4]', 10, 1)
			ROLLBACK
		END
	END
END
