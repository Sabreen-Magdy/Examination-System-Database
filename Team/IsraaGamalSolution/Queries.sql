-- ======================== Schema =======================

USE Examination_DB;
go

-- Create Schemas
CREATE SCHEMA [Instructor]
go
CREATE SCHEMA [Student]
go
CREATE SCHEMA [T_Manager]
go

-- ======================== Remove all inserted Data =======================

USE Examination_DB;
go

-- Delete data from Courses table
DELETE FROM Courses;

-- Delete data from Branch table
DELETE FROM Branch;

-- Delete data from Tracks table
DELETE FROM Tracks;

-- Delete data from Intake table
DELETE FROM Intake;

-- Delete data from Class table
DELETE FROM Class;

-- Delete data from Instructor table
DELETE FROM Instructor;

-- Delete data from Student table
DELETE FROM Student;

-- Delete data from Exam table
DELETE FROM Exam;

-- Delete data from Question table
DELETE FROM Question;

-- Delete data from StudentCourse table
DELETE FROM StudentCourse;

-- Delete data from User_Account table
DELETE FROM User_Account;

-- ======================== Index =======================

USE Examination_DB;
go

-- Index for Student table by student name
CREATE NONCLUSTERED INDEX stud_index_byname
ON dbo.Student(std_Name);
go
-- Index for Instructor table by instructor name
CREATE NONCLUSTERED INDEX instructor_index_byname
ON dbo.Instructor(name);
go
-- Index for Courses table by course name
CREATE NONCLUSTERED INDEX course_index_byname
ON dbo.Courses(name);
go
-- Index for Exam table by exam type
CREATE NONCLUSTERED INDEX exam_index_bytype
ON dbo.Exam(Type_Exam);
go
-- Index for Question table by question type
CREATE NONCLUSTERED INDEX question_index_bytype
ON dbo.Question(type);
go
-- Index for StudentExam table by student result
CREATE NONCLUSTERED INDEX examStudent_index_byresult
ON dbo.StudentExam(Result);

-- ======================== Procedure =======================

USE Examination_DB;
go

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
go

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
go

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
go

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
go

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
go

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
go