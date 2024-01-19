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
