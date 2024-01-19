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
go

-- Add the computed column [exam_EndTime]
ALTER TABLE dbo.Exam
ADD [exam_EndTime] AS (DATEADD(MINUTE, [exam_TotalDuration], [exam_StartTime]));
go

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
go

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
go

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
go

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
go

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
go

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
go

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
go

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



