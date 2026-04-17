CREATE TABLE [dbo].[StrRozv] (
    [CdVyr]  VARCHAR (10) NOT NULL,
    [CdSb]   VARCHAR (10) NOT NULL,
    [CdKp]   VARCHAR (10) NOT NULL,
    [QtyKp]  INT          NOT NULL,
    [RivNb]  INT          CONSTRAINT [DF_StrRozv_RivNb] DEFAULT ((1)) NOT NULL,
    [RivGrf] VARCHAR (10) CONSTRAINT [DF_StrRozv_RivGrf] DEFAULT ('.1') NOT NULL
);

