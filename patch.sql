SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LOOKUPS]') AND type in (N'U'))
DROP TABLE [LOOKUPS]
GO

CREATE TABLE [LOOKUPS](
	[id] [bigint] NOT NULL,
	[type] [varchar](200) NULL,
	[name] [varchar](100) NULL,
	[description] [varchar](500) NULL
) ON [PRIMARY]
GO

CREATE FUNCTION [phub].[SplitAndReturnSegment]
(
    @inputString NVARCHAR(MAX),
    @delimiter NVARCHAR(10),
    @segmentNumber INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX);
    select   @Result = d.val from (SELECT value as val from String_Split(@inputString, @delimiter)) d 
    order by (select null) offset @segmentNumber row fetch next 1 row only
    RETURN @Result;
END;
GO


ALTER TABLE [LOOKUPS] ADD PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

alter table task add wbsname varchar(500)
GO

alter table delay_log add market varchar(10)
GO

alter table delay_log add taskuid int
GO

alter table assignments add actualFinish datetime2(7)
GO