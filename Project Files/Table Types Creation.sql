-- ======================== Table Type =======================

USE Examination_DB;
go

-- AnswerTableType
CREATE TYPE [dbo].[AnswerTableType] AS TABLE (
    [QuestionID] CHAR(3),
    [StudentAnswer] VARCHAR(255)
);
go

-- AnswerTableTypes
CREATE TYPE [dbo].[AnswerTableTypes] AS TABLE (
    [QuestionID] CHAR(3),
    [StudentAnswer] VARCHAR(255)
);
go

-- QuestionDegreesType
CREATE TYPE [dbo].[QuestionDegreesType] AS TABLE (
    [QuestionID] VARCHAR(5),
    [QuestionDegree] INT
);
go

-- StudentListType
CREATE TYPE [dbo].[StudentListType] AS TABLE (
    [Std_ID] INT
);
