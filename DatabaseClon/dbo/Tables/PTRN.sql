CREATE TABLE [dbo].[PTRN] (
    [CdPr]  VARCHAR (10) NOT NULL,
    [CdTO]  VARCHAR (10) NOT NULL,
    [NbTO]  INT          NOT NULL,
    [Godin] FLOAT (53)   NOT NULL,
    CONSTRAINT [FK_PTRN_DovTO] FOREIGN KEY ([CdTO]) REFERENCES [dbo].[DovTO] ([CdTO])
);

