USE [master]
GO
/****** Object:  Database [Examination_DB]    Script Date: 1/16/2024 9:52:24 PM ******/
CREATE DATABASE [Examination_DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LibFile', FILENAME = N'D:\ITI\LibFile.mdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 20480KB ), 
 FILEGROUP [SecondaryFG] 
( NAME = N'LibFie2', FILENAME = N'D:\ITI\LibFie2.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 20480KB ),
( NAME = N'LibFie3', FILENAME = N'D:\ITI\LibFie3.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 20480KB )
 LOG ON 
( NAME = N'LibLog', FILENAME = N'D:\ITI\LibLog.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10240KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Examination_DB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Examination_DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Examination_DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Examination_DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Examination_DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Examination_DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Examination_DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [Examination_DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Examination_DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Examination_DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Examination_DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Examination_DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Examination_DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Examination_DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Examination_DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Examination_DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Examination_DB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Examination_DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Examination_DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Examination_DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Examination_DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Examination_DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Examination_DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Examination_DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Examination_DB] SET RECOVERY FULL 
GO
ALTER DATABASE [Examination_DB] SET  MULTI_USER 
GO
ALTER DATABASE [Examination_DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Examination_DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Examination_DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Examination_DB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Examination_DB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Examination_DB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Examination_DB', N'ON'
GO
ALTER DATABASE [Examination_DB] SET QUERY_STORE = ON
GO
ALTER DATABASE [Examination_DB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Examination_DB]
GO
/****** Object:  User [TrainingManager]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE USER [TrainingManager] FOR LOGIN [TrainingManager] WITH DEFAULT_SCHEMA=[T_Manager]
GO
/****** Object:  User [Student]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE USER [Student] FOR LOGIN [Student] WITH DEFAULT_SCHEMA=[Student]
GO
/****** Object:  User [NewUser]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE USER [NewUser] FOR LOGIN [NewUser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Instructor]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE USER [Instructor] FOR LOGIN [Instructor] WITH DEFAULT_SCHEMA=[Instructor]
GO
/****** Object:  Schema [Instructor]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE SCHEMA [Instructor]
GO
/****** Object:  Schema [Student]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE SCHEMA [Student]
GO
/****** Object:  Schema [T_Manager]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE SCHEMA [T_Manager]
GO
/****** Object:  UserDefinedTableType [dbo].[AnswerTableType]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE TYPE [dbo].[AnswerTableType] AS TABLE(
	[QuestionID] [char](3) NULL,
	[StudentAnswer] [varchar](255) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[AnswerTableTypes]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE TYPE [dbo].[AnswerTableTypes] AS TABLE(
	[QuestionID] [char](3) NULL,
	[StudentAnswer] [varchar](255) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[QuestionDegreesType]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE TYPE [dbo].[QuestionDegreesType] AS TABLE(
	[QuestionID] [varchar](5) NULL,
	[QuestionDegree] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentListType]    Script Date: 1/16/2024 9:52:25 PM ******/
CREATE TYPE [dbo].[StudentListType] AS TABLE(
	[Std_ID] [int] NULL
)
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](max) NULL,
	[max_degree] [int] NOT NULL,
	[min_degree] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Instructor]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructor](
	[ID] [int] NOT NULL,
	[name] [varchar](100) NULL,
	[User_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exam]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam](
	[exam_ID] [int] IDENTITY(1,1) NOT NULL,
	[Type_Exam] [varchar](15) NULL,
	[Exam_Date] [date] NULL,
	[exam_StartTime] [time](7) NULL,
	[exam_TotalDuration] [int] NULL,
	[TotalDegree] [int] NULL,
	[Crs_Id] [int] NULL,
	[class_Id] [int] NULL,
	[Ins_Exam] [int] NULL,
	[exam_EndTime]  AS (dateadd(minute,[exam_TotalDuration],[exam_StartTime])),
PRIMARY KEY CLUSTERED 
(
	[exam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[InstructorDataOrderedBy_Function]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- InstructorDataOrderedBy_Function
CREATE FUNCTION [dbo].[InstructorDataOrderedBy_Function] (@OrderByColumn VARCHAR(max))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Ins.ID AS InstructorID, 
        Ins.name AS InstructorName, 
        Ex.exam_ID AS ExamID,
        Ex.Type_Exam AS ExamType,
        Ex.Exam_Date AS ExamDate, 
        Crs.id AS CourseID,
        Crs.name AS CourseName,
        Crs.description AS CourseDescription,
        ROW_NUMBER() OVER (ORDER BY
            CASE
                WHEN @OrderByColumn = 'InstructorName' THEN Ins.name
                WHEN @OrderByColumn = 'ExamDate' THEN CAST(Ex.Exam_Date AS varchar(max))
                WHEN @OrderByColumn = 'CourseName' THEN Crs.name
                WHEN @OrderByColumn = 'CourseID' THEN CAST(Crs.id AS varchar(max))
                WHEN @OrderByColumn = 'InstructorID' THEN CAST(Ins.ID AS varchar(max))
                ELSE NULL
            END
        ) AS RowNum
    FROM 
        Instructor Ins 
    INNER JOIN Exam Ex ON Ins.ID = Ex.[Ins_Exam]
    INNER JOIN Courses Crs ON Ex.Crs_Id = Crs.id
);
GO
/****** Object:  UserDefinedFunction [Instructor].[InstructorSearchByPattern_FN]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- InstructorSearchByPattern_FN
CREATE FUNCTION [Instructor].[InstructorSearchByPattern_FN]
(
    @Option1 VARCHAR(MAX),
    @SearchPattern VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        Ins.ID AS InstructorID, 
        Ins.name AS InstructorName, 
        Ex.exam_ID AS ExamID,
        Ex.Type_Exam AS ExamType,
        Ex.Exam_Date AS ExamDate, 
        Crs.id AS CourseID,
        Crs.name AS CourseName,
        Crs.description AS CourseDescription
    FROM
        Instructor Ins INNER JOIN Exam Ex ON Ins.ID = Ex.Ins_Exam
    INNER JOIN Courses Crs ON Ex.Crs_Id = Crs.id
    WHERE
        (
            (@Option1 = 'InstructorName' AND Ins.name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'CourseName' AND Crs.name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'CourseID' AND CAST(Crs.id AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'InstructorID' AND CAST(Ins.ID AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'ExamID' AND CAST(Ex.exam_ID AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'ExamType' AND CAST(Ex.Type_Exam AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') 
        )
);
GO
/****** Object:  Table [dbo].[Student]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[Std_ID] [int] NOT NULL,
	[std_Name] [varchar](50) NULL,
	[std_Age] [int] NULL,
	[std_City] [varchar](50) NULL,
	[std_Email] [varchar](100) NULL,
	[Class_ID] [int] NULL,
	[User_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Std_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentCourse]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentCourse](
	[StudentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[TotalDegree] [int] NULL,
	[FinalResult] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC,
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Student].[StdCourseInfoByStudentID_FN]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- StdCourseInfoByStudentID_FN
CREATE FUNCTION [Student].[StdCourseInfoByStudentID_FN] (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.std_Name AS StudentName,
        C.[name] AS CourseName,
        SC.TotalDegree,
        SC.FinalResult
    FROM
        StudentCourse SC
    INNER JOIN
        Student S ON SC.StudentID = S.Std_ID
    INNER JOIN
        Courses C ON SC.CourseID = C.id
    WHERE
        SC.StudentID = @StudentID
);
GO
/****** Object:  UserDefinedFunction [T_Manager].[InstructorSearchByPattern_FN]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- InstructorSearchByPattern_FN
CREATE FUNCTION [T_Manager].[InstructorSearchByPattern_FN]
(
    @Option1 VARCHAR(MAX),
    @SearchPattern VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        Ins.ID AS InstructorID, Ins.name AS InstructorName, Ex.exam_ID AS ExamID,
        Ex.Type_Exam AS ExamType, Ex.Exam_Date AS ExamDate,Crs.id AS CourseID,
        Crs.name AS CourseName, Crs.description AS CourseDescription
    FROM
        Instructor Ins INNER JOIN Exam Ex ON Ins.ID = Ex.Ins_Exam
    INNER JOIN Courses Crs ON Ex.Crs_Id = Crs.id
    WHERE
        (
            (@Option1 = 'InstructorName' AND Ins.name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'CourseName' AND Crs.name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'CourseID' AND CAST(Crs.id AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'InstructorID' AND CAST(Ins.ID AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'ExamID' AND CAST(Ex.exam_ID AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'ExamType' AND CAST(Ex.Type_Exam AS VARCHAR(MAX)) LIKE '%' + @SearchPattern + '%') 
        )
);
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Intake]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intake](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NULL,
	[Intake_Year] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tracks]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tracks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Track] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Class]    Script Date: 1/16/2024 9:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Class](
	[ClassID] [int] NOT NULL,
	[TrackID] [int] NULL,
	[BranchID] [int] NULL,
	[IntakeID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [T_Manager].[ManagerSearchByPattern_FN]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ManagerSearchByPattern_FN
CREATE FUNCTION [T_Manager].[ManagerSearchByPattern_FN] 
    (@Option1 VARCHAR(MAX),
    @SearchPattern VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.Std_ID AS StudentID, S.std_Name AS StudentName, S.std_City AS StudentCity,
        S.std_Email AS StudentEmail,
        T.Track AS TrackName, B.Name AS BranchName, I.Name AS IntakeName
    FROM
        Student S
    INNER JOIN
        [dbo].[Class] C ON S.class_Id = C.ClassID
    INNER JOIN
        Tracks T ON C.TrackID = T.id
    INNER JOIN
        Branch B ON C.BranchID = B.ID
    INNER JOIN
        Intake I ON C.IntakeID = I.ID
    WHERE
        (
            (@Option1 = 'StudentName' AND  S.std_Name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'StudentEmail' AND  S.std_Email LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'StudentCity' AND  S.std_City LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'BrancheName' AND B.Name LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'TrackName' AND T.Track LIKE '%' + @SearchPattern + '%') OR
            (@Option1 = 'IntakeName' AND I.Name LIKE '%' + @SearchPattern + '%')  
        )
);
GO
/****** Object:  UserDefinedFunction [T_Manager].[SearchByPatternStdTable_FN]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SearchByPatternStdTable_FN
CREATE FUNCTION [T_Manager].[SearchByPatternStdTable_FN]
    (@option1 VARCHAR(15), @SearchPattern NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Student
    WHERE
        (
            CASE 
                WHEN @option1 = 'Name' THEN std_Name
                WHEN @option1 = 'Email' THEN std_Email
                WHEN @option1 = 'City' THEN std_City
            END
        ) LIKE '%' + @SearchPattern + '%'
);
GO
/****** Object:  Table [dbo].[Instructor_Courses]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructor_Courses](
	[Instructor_id] [int] NOT NULL,
	[Course_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Instructor_id] ASC,
	[Course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[InstructorCourseView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Instructor Course
CREATE VIEW [dbo].[InstructorCourseView]
AS
SELECT i.Name AS Instructor_name, c.[name] AS course_name
FROM Instructor i
INNER JOIN [dbo].[Instructor_Courses] ic ON i.[ID] = ic.[Instructor_id]
INNER JOIN [dbo].[Courses] c ON ic.[Course_id] = c.[id];
GO
/****** Object:  View [dbo].[StudentView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Student
CREATE VIEW [dbo].[StudentView]
AS
SELECT [std_Name] AS Name, [std_Age] AS Age, [std_Email] AS 'E-mail', [std_City] AS City
FROM [dbo].[Student];
GO
/****** Object:  View [Instructor].[ExamInstructorView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Instructor Exam
CREATE VIEW [Instructor].[ExamInstructorView]
AS
SELECT e.[Type_Exam], e.exam_TotalDuration, e.TotalDegree, i.Name AS InstructorName
FROM Exam e
LEFT JOIN Instructor i ON e.[Ins_Exam] = i.[ID];
GO
/****** Object:  View [Instructor].[StudentCourseView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Instructor Student Course
CREATE VIEW [Instructor].[StudentCourseView]
AS
SELECT s.std_Name AS Student_Name, s.std_Email AS 'E-mail', s.std_Age AS Age, c.[name] AS 'Course Name', FinalResult
FROM [dbo].[Student] s
INNER JOIN StudentCourse sc ON s.Std_ID = sc.StudentID
INNER JOIN [dbo].[Courses] c ON sc.CourseID = c.id;
GO
/****** Object:  View [T_Manager].[ClassDetailsView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Training Manager Class Details
CREATE VIEW [T_Manager].[ClassDetailsView]
AS
SELECT t.Track, i.[Name] AS IntakeName, b.[Name] AS BranchName
FROM [dbo].[Class] c
LEFT JOIN [dbo].[Tracks] t ON c.[TrackID] = t.[id]
LEFT JOIN [dbo].[Intake] i ON c.[IntakeID] = i.[ID]
LEFT JOIN [dbo].[Branch] b ON c.[BranchID] = b.[ID];
GO
/****** Object:  View [T_Manager].[CourseView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Training Manager Course
CREATE VIEW [T_Manager].[CourseView]
AS
SELECT [name] AS Name, [description] AS Description
FROM [dbo].[Courses];
GO
/****** Object:  View [T_Manager].[StudentCourseView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Training Manager Student Course
CREATE VIEW [T_Manager].[StudentCourseView]
AS
SELECT s.[std_Name], c.[name], se.[TotalDegree]
FROM [dbo].[StudentCourse] se
LEFT JOIN [dbo].[Student] s ON se.[StudentID] = s.[Std_ID]
LEFT JOIN [dbo].[Courses] c ON se.[CourseID] = c.[id];
GO
/****** Object:  Table [dbo].[Question]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[ID] [varchar](5) NOT NULL,
	[text] [varchar](1000) NULL,
	[type] [varchar](50) NULL,
	[degree] [int] NULL,
	[correct_answer] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentExam]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentExam](
	[ExamID] [int] NOT NULL,
	[QuestionID] [varchar](5) NOT NULL,
	[StudentID] [int] NOT NULL,
	[StudentAnswer] [varchar](255) NULL,
	[Result] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ExamID] ASC,
	[QuestionID] ASC,
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [T_Manager].[StudentExamView]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View for Training Manager Student Exam
CREATE VIEW [T_Manager].[StudentExamView]
AS
SELECT se.[ExamID], se.QuestionID, s.[std_Name], ISNULL(se.StudentAnswer, 'Not Answer Yet') AS StudentAnswer, se.Result, q.[text]
FROM [dbo].[StudentExam] se
LEFT JOIN Exam e ON se.ExamID = e.[exam_ID]
LEFT JOIN Question q ON se.QuestionID = q.[ID]
LEFT JOIN Student s ON se.StudentID = s.[Std_ID];
GO
/****** Object:  Table [dbo].[Choices]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Choices](
	[ID] [varchar](5) NOT NULL,
	[choose] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[choose] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamQuestion]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamQuestion](
	[ExamID] [int] NOT NULL,
	[QuestionID] [varchar](5) NOT NULL,
	[Degree] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ExamID] ASC,
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_Account]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Account](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[UserPassword] [varchar](100) NULL,
	[UserType] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [course_index_byname]    Script Date: 1/16/2024 9:52:26 PM ******/
CREATE NONCLUSTERED INDEX [course_index_byname] ON [dbo].[Courses]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [exam_index_bytype]    Script Date: 1/16/2024 9:52:26 PM ******/
CREATE NONCLUSTERED INDEX [exam_index_bytype] ON [dbo].[Exam]
(
	[Type_Exam] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [instructor_index_byname]    Script Date: 1/16/2024 9:52:26 PM ******/
CREATE NONCLUSTERED INDEX [instructor_index_byname] ON [dbo].[Instructor]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [question_index_bytype]    Script Date: 1/16/2024 9:52:26 PM ******/
CREATE NONCLUSTERED INDEX [question_index_bytype] ON [dbo].[Question]
(
	[type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [stud_index_byname]    Script Date: 1/16/2024 9:52:26 PM ******/
CREATE NONCLUSTERED INDEX [stud_index_byname] ON [dbo].[Student]
(
	[std_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [examStudent_index_byresult]    Script Date: 1/16/2024 9:52:26 PM ******/
CREATE NONCLUSTERED INDEX [examStudent_index_byresult] ON [dbo].[StudentExam]
(
	[Result] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Choices]  WITH CHECK ADD FOREIGN KEY([ID])
REFERENCES [dbo].[Question] ([ID])
GO
ALTER TABLE [dbo].[Class]  WITH CHECK ADD FOREIGN KEY([BranchID])
REFERENCES [dbo].[Branch] ([ID])
GO
ALTER TABLE [dbo].[Class]  WITH CHECK ADD FOREIGN KEY([IntakeID])
REFERENCES [dbo].[Intake] ([ID])
GO
ALTER TABLE [dbo].[Class]  WITH CHECK ADD FOREIGN KEY([TrackID])
REFERENCES [dbo].[Tracks] ([id])
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD FOREIGN KEY([class_Id])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD FOREIGN KEY([Crs_Id])
REFERENCES [dbo].[Courses] ([id])
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD FOREIGN KEY([Ins_Exam])
REFERENCES [dbo].[Instructor] ([ID])
GO
ALTER TABLE [dbo].[ExamQuestion]  WITH CHECK ADD FOREIGN KEY([ExamID])
REFERENCES [dbo].[Exam] ([exam_ID])
GO
ALTER TABLE [dbo].[ExamQuestion]  WITH CHECK ADD FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([ID])
GO
ALTER TABLE [dbo].[Instructor]  WITH CHECK ADD FOREIGN KEY([User_ID])
REFERENCES [dbo].[User_Account] ([User_ID])
GO
ALTER TABLE [dbo].[Instructor_Courses]  WITH CHECK ADD FOREIGN KEY([Course_id])
REFERENCES [dbo].[Courses] ([id])
GO
ALTER TABLE [dbo].[Instructor_Courses]  WITH CHECK ADD FOREIGN KEY([Instructor_id])
REFERENCES [dbo].[Instructor] ([ID])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([Class_ID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([User_ID])
REFERENCES [dbo].[User_Account] ([User_ID])
GO
ALTER TABLE [dbo].[StudentCourse]  WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Courses] ([id])
GO
ALTER TABLE [dbo].[StudentCourse]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([Std_ID])
GO
ALTER TABLE [dbo].[StudentExam]  WITH CHECK ADD FOREIGN KEY([ExamID])
REFERENCES [dbo].[Exam] ([exam_ID])
GO
ALTER TABLE [dbo].[StudentExam]  WITH CHECK ADD FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([ID])
GO
ALTER TABLE [dbo].[StudentExam]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([Std_ID])
GO
ALTER TABLE [dbo].[User_Account]  WITH CHECK ADD CHECK  (([UserType]='Admin' OR [UserType]='Student' OR [UserType]='Instructor' OR [UserType]='Training Manager'))
GO
/****** Object:  StoredProcedure [Instructor].[AddQuestions_Proc]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- AddQuestions_Proc
CREATE PROCEDURE [Instructor].[AddQuestions_Proc]
    @InstructorID INT,
    @CourseID INT,
    @RandomSelection VARCHAR(15),
    @ExamID INT,
    @NumberOfRandomQuestion INT,
    @QuestionDegrees QuestionDegreesType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Exam
        WHERE Ins_Exam = @InstructorID AND Crs_Id = @CourseID AND exam_ID = @ExamID
    )
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM ExamQuestion
            WHERE ExamID = @ExamID
        )
        BEGIN
            IF @RandomSelection IN ('Random', 'random')
            BEGIN
                -- Random Questions
                INSERT INTO ExamQuestion (ExamID, QuestionID, Degree)
                SELECT TOP (@NumberOfRandomQuestion) @ExamID, ID, CAST(RAND() * 5 + 1 AS INT)
                FROM Question
                ORDER BY NEWID();
            END
            ELSE IF @RandomSelection IN ('Manual', 'manual')
            BEGIN
                -- Manually Questions
                INSERT INTO ExamQuestion (ExamID, QuestionID, Degree)
                SELECT @ExamID, QuestionID, QuestionDegree
                FROM @QuestionDegrees;
            END
            ELSE
            BEGIN
                PRINT 'Please Enter Random or Manual';
            END
        END
        ELSE
        BEGIN
            PRINT 'This Exam has already added';
        END

        DECLARE @TotalDegree INT;
        SELECT @TotalDegree = TotalDegree
        FROM Exam
        WHERE Crs_Id = @CourseID;

        -- Calculate Total degree of exam
        DECLARE @TotalDegQuestion INT;
        SELECT @TotalDegQuestion = SUM(Degree)
        FROM ExamQuestion
        WHERE ExamID = @ExamID;

        -- Check Total degree is greater than Course Max Degree
        IF @TotalDegQuestion > @TotalDegree
        BEGIN
            PRINT 'Error: Total degree questions exceed Total Degree Of Exam.';
            DELETE FROM ExamQuestion WHERE ExamID = @ExamID; 
            RETURN;
        END
    END
    ELSE
    BEGIN
        PRINT 'Check that ExamID, CourseID, InstructorID are related';
    END
END;
GO
/****** Object:  StoredProcedure [Instructor].[AddStudentsToExam]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- AddStudentsToExam
CREATE PROCEDURE [Instructor].[AddStudentsToExam]
    @InstructorID INT,
    @StudentIDs NVARCHAR(MAX),
    @ExamID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Instructor WHERE ID = @InstructorID) OR
       @StudentIDs IS NULL OR @StudentIDs = '' OR
       NOT EXISTS (SELECT 1 FROM Exam WHERE exam_ID = @ExamID)
    BEGIN
        PRINT 'Invalid input parameters.';
        RETURN;
    END;

    DECLARE @CourseID INT = (SELECT Crs_Id FROM Exam WHERE exam_ID = @ExamID);

    IF EXISTS (
        SELECT 1
        FROM StudentCourse sc
        INNER JOIN STRING_SPLIT(@StudentIDs, ',') s ON sc.StudentID = CAST(s.value AS INT)
        WHERE sc.CourseID = @CourseID AND sc.FinalResult = 'pass'
    )
    BEGIN
        PRINT 'One or more students have already passed the course related to this exam.';
        RETURN;
    END;

    BEGIN TRY
        CREATE TABLE #TempStudentList (StudentID INT);

        INSERT INTO #TempStudentList (StudentID)
        SELECT CAST(value AS INT)
        FROM String_Split(@StudentIDs, ',');

        INSERT INTO dbo.StudentExam (StudentID, ExamID, QuestionID)
        SELECT ts.StudentID, @ExamID, eq.value
        FROM #TempStudentList ts
        CROSS JOIN STRING_SPLIT((SELECT STRING_AGG(QuestionID, ',') FROM ExamQuestion WHERE ExamID = @ExamID), ',') eq
        WHERE NOT EXISTS (
            SELECT 1
            FROM dbo.StudentExam se
            WHERE se.StudentID = ts.StudentID
              AND se.ExamID = @ExamID
              AND se.QuestionID = eq.value
        );

        DROP TABLE #TempStudentList;
    END TRY
    BEGIN CATCH
        PRINT 'Error in Your Data Please Check';
    END CATCH
END;
GO
/****** Object:  StoredProcedure [Instructor].[CreateExam]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- CreateExam
CREATE PROCEDURE [Instructor].[CreateExam]
    @Type NVARCHAR(50),
    @ExamDate DATE,
    @StartTime NVARCHAR(8),
    @TotalTime INT,
    @TotalDegree INT,
    @Crs_Id INT,
    @Class_Id INT,
    @InstructorId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @ExamDate < GETDATE()
    BEGIN
        PRINT 'ExamDate must be in the future.';
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1 
        FROM dbo.Instructor_Courses 
        WHERE Instructor_id = @InstructorId 
        AND Course_Id = @Crs_Id
    )
    BEGIN
        PRINT 'Instructor does not have the specified Course';
        RETURN;
    END

    INSERT INTO dbo.Exam (Type_Exam, Exam_Date, exam_StartTime, exam_TotalDuration, TotalDegree, Crs_Id, Class_Id, Ins_Exam)
    VALUES (@Type, @ExamDate, @StartTime, @TotalTime, @TotalDegree, @Crs_Id, @Class_Id, @InstructorId);
END;
GO
/****** Object:  StoredProcedure [Instructor].[GetExamsByYearCourseInstructor]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- GetExamsByYearCourseInstructor
CREATE PROCEDURE [Instructor].[GetExamsByYearCourseInstructor] 
    @year INT,
    @courseId INT,
    @instructorId INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Class c INNER JOIN Intake i ON c.IntakeID = i.ID WHERE i.[Intake_Year] = @year)
    BEGIN
        PRINT 'Year does not exist in the Class table';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Courses] WHERE id = @courseId)
    BEGIN
        PRINT 'Course ID does not exist in the Course table';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE ID = @instructorId)
    BEGIN
        PRINT 'Instructor ID does not exist in the Instructor table';
        RETURN;
    END

    SELECT 
        e.Type_Exam, e.Exam_Date, e.exam_StartTime, e.exam_TotalDuration, 
        e.TotalDegree, cr.[name] AS CourseName, i.name AS Ins_Name, Ik.Name AS Intake, 
        B.Name AS Branch, T.Track, Ik.Intake_Year
    FROM 
        Exam e
    INNER JOIN 
        Class c ON e.class_Id = c.[ClassID]
    INNER JOIN 
        Instructor i ON e.Ins_Exam = i.ID
    INNER JOIN 
        [dbo].[Courses] cr ON e.Crs_Id = cr.id
    INNER JOIN 
        Intake intake ON c.IntakeID = intake.ID
    INNER JOIN 
        Branch B ON c.BranchID = B.ID
    INNER JOIN 
        Intake Ik ON c.IntakeID = Ik.ID
    INNER JOIN 
        Tracks T ON c.TrackID = T.id
    WHERE 
        Ik.Intake_Year = @year
        AND e.Crs_Id = @courseId
        AND e.[Ins_Exam] = @instructorId;
END;
GO
/****** Object:  StoredProcedure [Instructor].[OrderBYStd_Proc]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- OrderBYStd_Proc
CREATE PROC [Instructor].[OrderBYStd_Proc] 
    @option1 NVARCHAR(100)
AS
BEGIN
    DECLARE @OrderByColumn NVARCHAR(100);

    SET @OrderByColumn =
        CASE
            WHEN @option1 = 'Name' THEN 'std_Name'
            WHEN @option1 = 'Age' THEN 'CAST(std_Age AS varchar(100))'
            WHEN @option1 = 'Email' THEN 'std_Email'
            WHEN @option1 = 'City' THEN 'std_City'
            ELSE 'std_Name'  -- Default to sorting by Name if option is not recognized
        END;

    DECLARE @SqlQuery NVARCHAR(MAX);

    SET @SqlQuery = 
        'SELECT * FROM Student ORDER BY ' + @OrderByColumn;

    EXEC sp_executesql @SqlQuery;
END;
GO
/****** Object:  StoredProcedure [Instructor].[StudentDataOrderedBy_Proc]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- StudentDataOrderedBy_Proc
CREATE PROCEDURE [Instructor].[StudentDataOrderedBy_Proc] 
    @OrderByColumn VARCHAR(100)
AS
BEGIN
    SELECT
        Stu.Std_ID AS StudentID,  
        Stu.std_Name AS StudentName,
        ES.ExamID,  
        ES.StudentAnswer,  
        ES.Result
    FROM
        StudentExam ES
    INNER JOIN
        Student Stu ON ES.StudentID = Stu.Std_ID  
    INNER JOIN
        Exam Ex ON ES.ExamID = Ex.exam_ID
    ORDER BY
        CASE
            WHEN @OrderByColumn = 'ID' THEN CAST(Stu.Std_ID AS varchar(100))
            WHEN @OrderByColumn = 'Name' THEN Stu.std_Name
            WHEN @OrderByColumn = 'ExamID' THEN CAST(ES.ExamID AS varchar(100))
            WHEN @OrderByColumn = 'StudentAnswer' THEN ES.StudentAnswer
            WHEN @OrderByColumn = 'Result' THEN CAST(ES.Result AS varchar(100))
        END;
END;
GO
/****** Object:  StoredProcedure [Instructor].[UpdateResults]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- UpdateResults
CREATE PROC [Instructor].[UpdateResults]
    @std_id INT,
    @exam_id INT
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        IF NOT EXISTS (SELECT 1 FROM [dbo].[Student] WHERE Std_ID = @std_id)
        BEGIN
            PRINT 'Student does not exist.';
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[Exam] E
            INNER JOIN [dbo].[StudentExam] S ON E.exam_ID = S.ExamID
            WHERE E.exam_ID = @exam_id
        )
        BEGIN
            PRINT 'Exam does not exist.';
            RETURN;
        END

        IF EXISTS (
            SELECT 1
            FROM [dbo].[StudentCourse] SC
            WHERE SC.StudentID = @std_id AND SC.CourseID IN (SELECT Crs_Id FROM [dbo].[Exam] WHERE exam_ID = @exam_id)
        )
        BEGIN
            PRINT 'Exam For This Student Already Marked.';
            RETURN;
        END

        UPDATE SE
        SET Result = CASE WHEN Q.correct_answer = SE.StudentAnswer THEN Q.degree ELSE 0 END
        FROM [dbo].[StudentExam] SE
        INNER JOIN [dbo].[ExamQuestion] EQ ON SE.ExamID = EQ.ExamID AND SE.QuestionID = EQ.QuestionID
        INNER JOIN [dbo].[Question] Q ON EQ.QuestionID = Q.ID
        WHERE SE.StudentID = @std_id AND SE.ExamID = @exam_id;

        DECLARE @total_degree INT,
                @Crs_ID INT;

        SELECT 
            @total_degree = ISNULL(SUM(R.Result) OVER(), 0),
            @Crs_ID = E.Crs_Id
        FROM [dbo].[StudentExam] R
        INNER JOIN [dbo].[Exam] E ON R.ExamID = E.exam_ID
        WHERE R.StudentID = @std_id AND R.ExamID = @exam_id;

        INSERT INTO [dbo].[StudentCourse] ([CourseID], [StudentID], [TotalDegree])
        VALUES (@Crs_ID, @std_id, @total_degree);

    END TRY
    BEGIN CATCH
        PRINT 'Please Add Correct Data';
    END CATCH
END;
GO
/****** Object:  StoredProcedure [Student].[StoreStudentAnswers]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [Student].[StoreStudentAnswers] 
CREATE PROC [Student].[StoreStudentAnswers] 
    @std_id INT, 
    @exam_id INT, 
    @student_answers AnswerTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the @std_id and @exam_id exist in the ExamStudent table
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[StudentExam]
        WHERE StudentID = @std_id AND ExamID = @exam_id
    )
    BEGIN
        RAISERROR('Invalid Student ID or Exam ID.', 16, 1);
        RETURN;
    END;

    -- Check if it's allowed to answer at this time
    DECLARE @CurrentTime TIME = CAST(GETDATE() AS TIME);
    DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE);
    DECLARE @ExamStartTime TIME, @ExamEndTime TIME, @ExamDate DATE;

    SELECT @ExamStartTime = [exam_StartTime], @ExamEndTime = [exam_EndTime], @ExamDate = [Exam_Date] 
    FROM Exam 
    WHERE exam_ID = @exam_id;

    IF @CurrentTime < @ExamStartTime OR @CurrentTime > @ExamEndTime OR @CurrentDate != @ExamDate
    BEGIN
        RAISERROR('Not allowed to answer at this time.', 16, 1);
        RETURN;
    END;

    -- Update StudentExam table with provided answers
    UPDATE se
    SET StudentAnswer = sa.StudentAnswer
    FROM [dbo].[StudentExam] se
    INNER JOIN @student_answers sa ON se.QuestionID = sa.QuestionID
    WHERE se.ExamID = @exam_id AND se.StudentID = @std_id;

END;
GO
/****** Object:  StoredProcedure [T_Manager].[CreateUserLogin]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [T_Manager].[CreateUserLogin]
CREATE PROCEDURE [T_Manager].[CreateUserLogin]
    @Name NVARCHAR(255),
    @Password NVARCHAR(255),
    @UserType NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF @UserType IN ('Student', 'Training Manager', 'Admin', 'Instructor')
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @Name)
        BEGIN
            DECLARE @SQLLogin NVARCHAR(MAX) = 'CREATE LOGIN ' + QUOTENAME(@Name) + ' WITH PASSWORD = ''' + @Password + ''', CHECK_POLICY = OFF;';
            EXEC sp_executesql @SQLLogin;

            IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @Name)
            BEGIN
                DECLARE @SQLUser NVARCHAR(MAX) = 'CREATE USER ' + QUOTENAME(@Name) + ' FOR LOGIN ' + QUOTENAME(@Name) + ';';
                EXEC sp_executesql @SQLUser;

                INSERT INTO User_Account (UserName, UserPassword, UserType)
                VALUES (@Name, @Password, @UserType);
            END
            ELSE
            BEGIN
                RAISERROR('User with the same name already exists.', 16, 1);
            END
        END
        ELSE
        BEGIN
            RAISERROR('Login with the same name already exists.', 16, 1);
        END
    END
    ELSE
    BEGIN
        RAISERROR('Invalid UserType. Allowed values are Student, Training Manager, Admin, and Instructor.', 16, 1);
    END
END;
GO
/****** Object:  StoredProcedure [T_Manager].[crs_std_inst_INFO_by_course_id]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [T_Manager].[crs_std_inst_INFO_by_course_id]
CREATE PROCEDURE [T_Manager].[crs_std_inst_INFO_by_course_id]
    @CourseID INT
AS
BEGIN
    SELECT 
        c.id AS CourseID,
        c.name AS CourseName,
        c.description AS CourseDescription,
        i.ID AS InstructorID,
        i.name AS InstructorName,
        s.Std_ID AS StudentID,
        s.std_Name AS StudentName,
        s.std_Age AS StudentAge,
        s.std_City AS StudentCity,
        s.std_Email AS StudentEmail
    FROM Courses c 
    LEFT JOIN Instructor i ON c.ID = i.ID
    LEFT JOIN Student s ON c.ID = s.[class_Id]
    WHERE c.id = @CourseID;
END;
GO
/****** Object:  StoredProcedure [T_Manager].[InstructorDataOrderedBy_Proc]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [T_Manager].[InstructorDataOrderedBy_Proc]
CREATE PROCEDURE [T_Manager].[InstructorDataOrderedBy_Proc] 
    @OrderByColumn NVARCHAR(MAX)
AS
BEGIN
    SELECT 
        Ins.ID AS InstructorID, 
        Ins.name AS InstructorName, 
        Ex.exam_ID AS ExamID,
        Ex.Type_Exam AS ExamType,
        Ex.Exam_Date AS ExamDate, 
        Crs.id AS CourseID,
        Crs.name AS CourseName,
        Crs.description AS CourseDescription
    FROM 
        Instructor Ins
    INNER JOIN Exam Ex ON Ins.ID = Ex.[Ins_Exam]
    INNER JOIN Courses Crs ON Ex.Crs_Id = Crs.id
    ORDER BY 
        CASE
            WHEN @OrderByColumn = 'InstructorName' THEN Ins.name
            WHEN @OrderByColumn = 'ExamDate' THEN CONVERT(VARCHAR(MAX), Ex.Exam_Date, 121)
            WHEN @OrderByColumn = 'CourseName' THEN Crs.name
            WHEN @OrderByColumn = 'CourseID' THEN CAST(Crs.id AS NVARCHAR(MAX))
            WHEN @OrderByColumn = 'InstructorID' THEN CAST(Ins.ID AS NVARCHAR(MAX))
        END;
END;
GO
/****** Object:  StoredProcedure [T_Manager].[MangerDataOrderedBy_Proc]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [T_Manager].[MangerDataOrderedBy_Proc]
CREATE PROCEDURE [T_Manager].[MangerDataOrderedBy_Proc] @Option1 NVARCHAR(MAX)
AS
BEGIN
    SELECT
        S.Std_ID AS StudentID, S.std_Name AS StudentName, S.std_City AS StudentCity,
        S.std_Email AS StudentEmail,
        T.Track AS TrackName, B.Name AS BranchName, I.Name AS IntakeName
    FROM
        dbo.Student S
    INNER JOIN
        dbo.Class C ON S.class_Id = C.ClassID
    INNER JOIN
        dbo.Tracks T ON C.TrackID = T.ID
    INNER JOIN
        dbo.Branch B ON C.BranchID = B.ID
    INNER JOIN
        dbo.Intake I ON C.IntakeID = I.ID
    ORDER BY
        CASE
            WHEN @Option1 = 'StudentName' THEN S.std_Name
            WHEN @Option1 = 'StudentEmail' THEN S.std_Email
            WHEN @Option1 = 'StudentCity' THEN S.std_City
            WHEN @Option1 = 'BranchName' THEN B.Name
            WHEN @Option1 = 'TrackName' THEN T.Track
            WHEN @Option1 = 'IntakeName' THEN I.Name
        END;
END;
GO
/****** Object:  StoredProcedure [T_Manager].[OrderBYStd_Proc]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [T_Manager].[OrderBYStd_Proc] 
CREATE PROC [T_Manager].[OrderBYStd_Proc] 
    @option1 VARCHAR(100)
AS
BEGIN
    SELECT *
    FROM Student
    ORDER BY
        CASE @option1
            WHEN 'Name' THEN std_Name
            WHEN 'Age' THEN CAST(std_Age AS varchar(100))
            WHEN 'Email' THEN std_Email
            WHEN 'City' THEN std_City
        END;
END;
GO
/****** Object:  StoredProcedure [T_Manager].[ShowDataByYear]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [T_Manager].[ShowDataByYear]
CREATE PROCEDURE [T_Manager].[ShowDataByYear]
    @inputYear INT
AS
BEGIN
    SELECT  
        C.id AS CourseID,
        C.[name] AS CourseName, 
        C.[description] AS CourseDescription,
        Cl.ClassID AS ClassID,
        B.Name AS BranchName,
        N.Name AS IntakeName,
        T.Track AS TrackName,
        N.Intake_Year AS ClassYear,
        I.ID AS InstructorID,
        I.name AS InstructorName
    FROM 
        Courses C
        INNER JOIN Class Cl ON C.id = Cl.ClassID
        INNER JOIN Intake N ON Cl.IntakeID = N.ID
        INNER JOIN Branch B ON Cl.BranchID = B.ID
        INNER JOIN Tracks T ON Cl.TrackID = T.id
        INNER JOIN Exam E ON E.class_Id = Cl.ClassID AND C.id = E.Crs_Id
        INNER JOIN Instructor I ON E.Ins_Exam = I.ID
    WHERE 
        N.Intake_Year = @inputYear;
END;
GO
/****** Object:  StoredProcedure [T_Manager].[UpdateYearOnIntakeInsert]    Script Date: 1/16/2024 9:52:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [T_Manager].[UpdateYearOnIntakeInsert]
CREATE PROCEDURE [T_Manager].[UpdateYearOnIntakeInsert]
    @intake VARCHAR(50),
    @id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @currentYear INT = YEAR(GETDATE());
    DECLARE @userProvidedYear INT = TRY_CAST(@intake AS INT);

    IF @userProvidedYear IS NOT NULL 
        AND @userProvidedYear >= @currentYear 
        AND @userProvidedYear <= @currentYear + 5
    BEGIN
        IF EXISTS (SELECT 1 FROM Intake WHERE [id] = @id)
        BEGIN
            UPDATE Intake
            SET Intake_Year = @userProvidedYear
            WHERE [id] = @id;

            PRINT 'Year successfully updated.';
        END
        ELSE
        BEGIN
            PRINT 'Invalid ID provided. The specified ID does not exist in the Intake table.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Invalid year provided. Please ensure the year is within a valid range.';
    END
END;



GO
USE [master]
GO
ALTER DATABASE [Examination_DB] SET  READ_WRITE 
GO
