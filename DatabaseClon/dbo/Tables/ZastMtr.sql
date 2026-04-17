CREATE TABLE [dbo].[ZastMtr] (
    [CdKp]   VARCHAR (10) NOT NULL,
    [CdMtr]  INT          NOT NULL,
    [OdVym]  VARCHAR (10) NOT NULL,
    [OtyMtr] FLOAT (53)   NOT NULL,
    CONSTRAINT [PK_ZastMtr] PRIMARY KEY CLUSTERED ([CdKp] ASC),
    CONSTRAINT [FK_ZastMtr_DovMtr] FOREIGN KEY ([CdMtr]) REFERENCES [dbo].[DovMtr] ([CdMt])
);

