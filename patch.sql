SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [DBO].[HISTORY](
    [PRJID] [VARCHAR](255) NULL,
    [TASKUID] [INT] NULL,
    [TASKID] [INT] NULL,
    [DURATION] [INT] NULL,
    [REMAININGDURATION] [INT] NULL,
    [ORGCHAIN] [INT] NULL,
    [CHAINLEFT] [INT] NULL,
    [BUFFERCOLOR] [INT] NULL,
    [MARKET] [VARCHAR](100) NULL,
    [CREATEDON] [DATETIME2](7) NULL,
    [LBE] [DATETIME2](7) NULL,
    [RVERSION] [INT] NULL
);

GO

ALTER TABLE [DBO].[TASK] ADD [ORGCHAIN] [VARCHAR](10) NULL, [CHAINLEFT] [VARCHAR](10) NULL [BUFFERCOLOR] INT NULL;

GO