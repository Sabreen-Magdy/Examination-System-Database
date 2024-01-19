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

-- ======================== FUNCTION =======================

USE Examination_DB;
go

-- [dbo].[InstructorDataOrderedBy_Function]
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
go

-- [Instructor].[InstructorSearchByPattern_FN]
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
go

-- [Student].[StdCourseInfoByStudentID_FN]
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
go

-- [T_Manager].[InstructorSearchByPattern_FN]
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
go

-- [T_Manager].[ManagerSearchByPattern_FN] 
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
go

-- [T_Manager].[SearchByPatternStdTable_FN]
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

-- ======================== Procedure =======================
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

-- ======================== View =======================

USE Examination_DB;
go

-- View for Instructor Course
CREATE VIEW [dbo].[InstructorCourseView]
AS
SELECT i.Name AS Instructor_name, c.[name] AS course_name
FROM Instructor i
INNER JOIN [dbo].[Instructor_Courses] ic ON i.[ID] = ic.[Instructor_id]
INNER JOIN [dbo].[Courses] c ON ic.[Course_id] = c.[id];
go

-- View for Student
CREATE VIEW [dbo].[StudentView]
AS
SELECT [std_Name] AS Name, [std_Age] AS Age, [std_Email] AS 'E-mail', [std_City] AS City
FROM [dbo].[Student];
go

-- View for Instructor Exam
CREATE VIEW [Instructor].[ExamInstructorView]
AS
SELECT e.[Type_Exam], e.exam_TotalDuration, e.TotalDegree, i.Name AS InstructorName
FROM Exam e
LEFT JOIN Instructor i ON e.[Ins_Exam] = i.[ID];
go

-- View for Instructor Student Course
CREATE VIEW [Instructor].[StudentCourseView]
AS
SELECT s.std_Name AS Student_Name, s.std_Email AS 'E-mail', s.std_Age AS Age, c.[name] AS 'Course Name', FinalResult
FROM [dbo].[Student] s
INNER JOIN StudentCourse sc ON s.Std_ID = sc.StudentID
INNER JOIN [dbo].[Courses] c ON sc.CourseID = c.id;
go

-- View for Training Manager Class Details
CREATE VIEW [T_Manager].[ClassDetailsView]
AS
SELECT t.Track, i.[Name] AS IntakeName, b.[Name] AS BranchName
FROM [dbo].[Class] c
LEFT JOIN [dbo].[Tracks] t ON c.[TrackID] = t.[id]
LEFT JOIN [dbo].[Intake] i ON c.[IntakeID] = i.[ID]
LEFT JOIN [dbo].[Branch] b ON c.[BranchID] = b.[ID];
go

-- View for Training Manager Course
CREATE VIEW [T_Manager].[CourseView]
AS
SELECT [name] AS Name, [description] AS Description
FROM [dbo].[Courses];
go

-- View for Training Manager Student Course
CREATE VIEW [T_Manager].[StudentCourseView]
AS
SELECT s.[std_Name], c.[name], se.[TotalDegree]
FROM [dbo].[StudentCourse] se
LEFT JOIN [dbo].[Student] s ON se.[StudentID] = s.[Std_ID]
LEFT JOIN [dbo].[Courses] c ON se.[CourseID] = c.[id];
go

-- View for Training Manager Student Exam
CREATE VIEW [T_Manager].[StudentExamView]
AS
SELECT se.[ExamID], se.QuestionID, s.[std_Name], ISNULL(se.StudentAnswer, 'Not Answer Yet') AS StudentAnswer, se.Result, q.[text]
FROM [dbo].[StudentExam] se
LEFT JOIN Exam e ON se.ExamID = e.[exam_ID]
LEFT JOIN Question q ON se.QuestionID = q.[ID]
LEFT JOIN Student s ON se.StudentID = s.[Std_ID];

-- ======================== Test Queries =======================

USE Examination_DB;
go

-- ======================== Test Views =======================

-- Testing InstructorCourseView
SELECT * FROM [dbo].[InstructorCourseView];

-- Testing StudentView
SELECT * FROM [dbo].[StudentView];

-- Testing ExamInstructorView
SELECT * FROM [Instructor].[ExamInstructorView];

-- Testing StudentCourseView
SELECT * FROM [Instructor].[StudentCourseView];

-- Testing ClassDetailsView
SELECT * FROM [T_Manager].[ClassDetailsView];

-- Testing CourseView
SELECT * FROM [T_Manager].[CourseView];

-- Testing StudentCourseView
SELECT * FROM [T_Manager].[StudentCourseView];

-- Testing StudentExamView
SELECT * FROM [T_Manager].[StudentExamView];

-- ======================== Test Triggers =======================

-- Testing Exam Created Trigger
INSERT INTO Exam (Type_Exam, Exam_Date, exam_StartTime, exam_TotalDuration, TotalDegree, Crs_Id, class_Id, Ins_Exam)
VALUES ('Midterm', '2024-02-15', '10:00:00', 120, 100, 1, 1, 1);

-- Testing Update Student Answer Trigger
UPDATE [dbo].[StudentExam] SET StudentAnswer = 'New Answer' WHERE ExamID = 1 AND QuestionID = 'Q1' AND StudentID = 1;

-- Testing Add Student to Exam Trigger
INSERT INTO [dbo].[StudentExam] (ExamID, QuestionID, StudentID, StudentAnswer, Result)
VALUES (1, 'Q2', 2, 'True', 1);

-- Testing Mark Exam Trigger
UPDATE [dbo].[StudentExam] SET Result = 2 WHERE ExamID = 1 AND QuestionID = 'Q2' AND StudentID = 2;

-- Testing Insert Data in ExamQuestion Table Trigger
INSERT INTO ExamQuestion (ExamID, QuestionID, Degree)
VALUES (1, 'Q3', 10);

-- Testing Update Final Result Trigger
INSERT INTO [StudentCourse] (StudentID, CourseID, TotalDegree, FinalResult)
VALUES (1, 1, 80, NULL);

-- OR

UPDATE [StudentCourse] SET TotalDegree = 40 WHERE StudentID = 1 AND CourseID = 1;

-- ======================== Test Functions =======================

-- Test for InstructorDataOrderedBy_Function
SELECT * FROM dbo.InstructorDataOrderedBy_Function('InstructorName');
SELECT * FROM dbo.InstructorDataOrderedBy_Function('ExamDate');
SELECT * FROM dbo.InstructorDataOrderedBy_Function('CourseName');
SELECT * FROM dbo.InstructorDataOrderedBy_Function('CourseID');
SELECT * FROM dbo.InstructorDataOrderedBy_Function('InstructorID');

-- Test for InstructorSearchByPattern_FN
SELECT * FROM Instructor.InstructorSearchByPattern_FN('InstructorName', 'John');
SELECT * FROM Instructor.InstructorSearchByPattern_FN('CourseName', 'Math');
SELECT * FROM Instructor.InstructorSearchByPattern_FN('CourseID', '1');
SELECT * FROM Instructor.InstructorSearchByPattern_FN('InstructorID', '2');
SELECT * FROM Instructor.InstructorSearchByPattern_FN('ExamID', '3');

-- Test for StdCourseInfoByStudentID_FN
SELECT * FROM Student.StdCourseInfoByStudentID_FN(1);

-- Test for T_Manager.InstructorSearchByPattern_FN
SELECT * FROM T_Manager.InstructorSearchByPattern_FN('InstructorName', 'John');
SELECT * FROM T_Manager.InstructorSearchByPattern_FN('CourseName', 'Math');
SELECT * FROM T_Manager.InstructorSearchByPattern_FN('CourseID', '1');
SELECT * FROM T_Manager.InstructorSearchByPattern_FN('InstructorID', '2');
SELECT * FROM T_Manager.InstructorSearchByPattern_FN('ExamID', '3');

-- Test for T_Manager.ManagerSearchByPattern_FN
SELECT * FROM T_Manager.ManagerSearchByPattern_FN('StudentName', 'John');
SELECT * FROM T_Manager.ManagerSearchByPattern_FN('StudentEmail', 'john@example.com');
SELECT * FROM T_Manager.ManagerSearchByPattern_FN('StudentCity', 'City');
SELECT * FROM T_Manager.ManagerSearchByPattern_FN('BrancheName', 'Branch');
SELECT * FROM T_Manager.ManagerSearchByPattern_FN('TrackName', 'Track');
SELECT * FROM T_Manager.ManagerSearchByPattern_FN('IntakeName', 'Intake');

-- Test for T_Manager.SearchByPatternStdTable_FN
SELECT * FROM T_Manager.SearchByPatternStdTable_FN('Name', 'John');
SELECT * FROM T_Manager.SearchByPatternStdTable_FN('Email', 'john@example.com');
SELECT * FROM T_Manager.SearchByPatternStdTable_FN('City', 'City');

-- ======================== Test Procedures =======================

-- Test for [Instructor].[AddQuestions_Proc]
-- Declare variables
DECLARE @InstructorID INT = 2; 
DECLARE @CourseID INT = 1; 
DECLARE @RandomSelection VARCHAR(15) = 'Random'; 
DECLARE @ExamID INT = 1; 
DECLARE @NumberOfRandomQuestion INT = 3; 

-- Declare a table variable for manual questions
DECLARE @QuestionDegrees QuestionDegreesType;
INSERT INTO @QuestionDegrees (QuestionID, QuestionDegree)
VALUES ('Q1', 50), ('Q2', 100), ('Q3', 30);

-- Execute the stored procedure
EXEC [Instructor].[AddQuestions_Proc]
    @InstructorID,
    @CourseID,
    @RandomSelection,
    @ExamID,
    @NumberOfRandomQuestion,
    @QuestionDegrees;
go

-- Test for [Instructor].[AddStudentsToExam]
-- Declare variables
DECLARE @InstructorID INT = 1;
DECLARE @StudentIDs NVARCHAR(MAX) = '1,2,3';
DECLARE @ExamID INT = 1;

-- Execute the stored procedure
EXEC [Instructor].[AddStudentsToExam]
    @InstructorID,
    @StudentIDs,
    @ExamID;

-- Test for [Instructor].[CreateExam]
-- Declare variables
DECLARE @Type NVARCHAR(50) = 'Midterm';
DECLARE @ExamDate DATE = '2024-02-20';
DECLARE @StartTime NVARCHAR(8) = '10:00:00';
DECLARE @TotalTime INT = 120;
DECLARE @TotalDegree INT = 100;
DECLARE @Crs_Id INT = 1;
DECLARE @Class_Id INT = 1;
DECLARE @InstructorId INT = 1;

-- Execute the stored procedure
EXEC [Instructor].[CreateExam]
    @Type,
    @ExamDate,
    @StartTime,
    @TotalTime,
    @TotalDegree,
    @Crs_Id,
    @Class_Id,
    @InstructorId;
go

-- Test for [Instructor].[GetExamsByYearCourseInstructor]
-- Declare variables
DECLARE @year INT = 2022;
DECLARE @courseId INT = 1;
DECLARE @instructorId INT = 1;

-- Execute the stored procedure
EXEC [Instructor].[GetExamsByYearCourseInstructor]
    @year,
    @courseId,
    @instructorId;
go

-- Test for [Instructor].[OrderBYStd_Proc]
-- Declare variables
DECLARE @option1 NVARCHAR(100) = 'Age';

-- Execute the stored procedure
EXEC [Instructor].[OrderBYStd_Proc]
    @option1;
go

-- Test for [Instructor].[StudentDataOrderedBy_Proc]
-- Declare variables
DECLARE @OrderByColumn VARCHAR(100) = 'Name';

-- Execute the stored procedure
EXEC [Instructor].[StudentDataOrderedBy_Proc]
    @OrderByColumn;
go

-- Test for [Instructor].[UpdateResults]
-- Declare variables
DECLARE @std_id INT = 1;
DECLARE @exam_id INT = 1;

-- Execute the stored procedure
EXEC [Instructor].[UpdateResults]
    @std_id,
    @exam_id;
go

-- Test for [Student].[StoreStudentAnswers]
-- Declare variables
DECLARE @std_id INT = 1;
DECLARE @exam_id INT = 1;

-- Declare a table variable for student answers
DECLARE @student_answers AnswerTableType;
INSERT INTO @student_answers (QuestionID, StudentAnswer)
VALUES 
    ('Q1', 'Option A'),
    ('Q2', 'True'),
    ('Q3', 'Oxygen');

-- Execute the stored procedure
EXEC [Student].[StoreStudentAnswers]
    @std_id,
    @exam_id,
    @student_answers;
go

-- Test for [T_Manager].[CreateUserLogin]
-- Declare variables
DECLARE @Name NVARCHAR(255) = 'NewUser';
DECLARE @Password NVARCHAR(255) = 's123';
DECLARE @UserType NVARCHAR(255) = 'Student';

-- Execute the stored procedure
EXEC [T_Manager].[CreateUserLogin]
    @Name,
    @Password,
    @UserType;
go

-- Test for [T_Manager].[crs_std_inst_INFO_by_course_id]
-- Declare variables
DECLARE @CourseID INT = 1;

-- Execute the stored procedure
EXEC [T_Manager].[crs_std_inst_INFO_by_course_id]
    @CourseID;
go

-- Test for [T_Manager].[InstructorDataOrderedBy_Proc]
-- Declare variables
DECLARE @OrderByColumn NVARCHAR(MAX) = 'InstructorName';

-- Execute the stored procedure
EXEC [T_Manager].[InstructorDataOrderedBy_Proc]
    @OrderByColumn;
go

-- Test for [T_Manager].[MangerDataOrderedBy_Proc]
-- Declare variables
DECLARE @Option1 NVARCHAR(MAX) = 'StudentName';

-- Execute the stored procedure
EXEC [T_Manager].[MangerDataOrderedBy_Proc]
    @Option1;
go

-- Test for [T_Manager].[OrderBYStd_Proc]
-- Declare variables
DECLARE @option1 VARCHAR(100) = 'Name';

-- Execute the stored procedure
EXEC [T_Manager].[OrderBYStd_Proc]
    @option1;
go

-- Test for [T_Manager].[ShowDataByYear]
-- Declare variables
DECLARE @inputYear INT = 2022;

-- Execute the stored procedure
EXEC [T_Manager].[ShowDataByYear]
    @inputYear;
go

-- Test for [T_Manager].[UpdateYearOnIntakeInsert]
-- Declare variables
DECLARE @intake VARCHAR(50) = '2025';
DECLARE @id INT = 1;

-- Execute the stored procedure
EXEC [T_Manager].[UpdateYearOnIntakeInsert]
    @intake,
    @id;

