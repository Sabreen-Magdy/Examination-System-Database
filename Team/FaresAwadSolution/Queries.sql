-- ================ Database and Tables Creation ===================

-- Create Database
CREATE DATABASE Examination_DB
ON PRIMARY
(
    NAME = 'LibFile',
    FILENAME = 'D:\ITI\LibFile.mdf',
    SIZE = 10MB,
    FILEGROWTH = 20MB,
    MAXSIZE = UNLIMITED
),
FILEGROUP SecondaryFG
(
    NAME = 'LibFie2',
    FILENAME = 'D:\ITI\LibFie2.ndf',
    SIZE = 10MB,
    FILEGROWTH = 20MB,
    MAXSIZE = UNLIMITED
),
(
    NAME = 'LibFie3',
    FILENAME = 'D:\ITI\LibFie3.ndf',
    SIZE = 10MB,
    FILEGROWTH = 20MB,
    MAXSIZE = UNLIMITED
)
LOG ON
(
    NAME = 'LibLog',
    FILENAME = 'D:\ITI\LibLog.ldf',
    SIZE = 10MB,
    FILEGROWTH = 10MB
);
go

USE Examination_DB;
go

-- Creating Branch table
CREATE TABLE dbo.Branch (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(20)
);
go

-- Creating Intake table
CREATE TABLE dbo.Intake (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(20),
    Intake_Year INT
);
go

-- Creating Tracks table
CREATE TABLE dbo.Tracks (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Track VARCHAR(200)
);
go

-- Creating User_Account table
CREATE TABLE dbo.User_Account (
    User_ID INT IDENTITY(1,1) PRIMARY KEY,
    UserName VARCHAR(50),
    UserPassword VARCHAR(100),
    UserType VARCHAR(20) CHECK (UserType IN ('Training Manager', 'Instructor', 'Student', 'Admin'))
);
go

-- Creating Courses table
CREATE TABLE dbo.Courses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(MAX),
    max_degree INT NOT NULL,
    min_degree INT NOT NULL
);
go

-- Creating Question table
CREATE TABLE dbo.Question (
    ID VARCHAR(5) PRIMARY KEY,
    text VARCHAR(1000),
    type VARCHAR(50),
    degree INT,
    correct_answer VARCHAR(100)
);
go

-- Creating Choices table
CREATE TABLE dbo.Choices (
    ID VARCHAR(5),
    choose VARCHAR(100),
    PRIMARY KEY (ID, choose),
    FOREIGN KEY (ID) REFERENCES dbo.Question(ID)
);
go

-- Creating Class table
CREATE TABLE dbo.Class (
    ClassID INT PRIMARY KEY,
    TrackID INT,
    BranchID INT,
    IntakeID INT,
    FOREIGN KEY (BranchID) REFERENCES dbo.Branch(ID),
    FOREIGN KEY (IntakeID) REFERENCES dbo.Intake(ID),
    FOREIGN KEY (TrackID) REFERENCES dbo.Tracks(id)
);
go

-- Creating Student table
CREATE TABLE dbo.Student (
    Std_ID INT PRIMARY KEY,
    std_Name VARCHAR(50),
    std_Age INT,
    std_City VARCHAR(50),
    std_Email VARCHAR(100),
    Class_ID INT,
    User_ID INT,
    FOREIGN KEY (User_ID) REFERENCES dbo.User_Account(User_ID),
    FOREIGN KEY (Class_ID) REFERENCES dbo.Class(ClassID)
);
go

-- Creating Instructor table
CREATE TABLE dbo.Instructor (
    ID INT PRIMARY KEY,
    name VARCHAR(100),
    User_ID INT,
    FOREIGN KEY (User_ID) REFERENCES dbo.User_Account(User_ID)
);
go

-- Creating Instructor_Courses table
CREATE TABLE dbo.Instructor_Courses (
    Instructor_id INT,
    Course_id INT,
    PRIMARY KEY (Instructor_id, Course_id),
    FOREIGN KEY (Instructor_id) REFERENCES dbo.Instructor(ID),
    FOREIGN KEY (Course_id) REFERENCES dbo.Courses(id)
);
go

-- Creating StudentCourse table
CREATE TABLE dbo.StudentCourse (
    StudentID INT,
    CourseID INT,
    TotalDegree INT,
    FinalResult VARCHAR(20),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES dbo.Student(Std_ID),
    FOREIGN KEY (CourseID) REFERENCES dbo.Courses(id)
);
go

-- Creating Exam table
CREATE TABLE dbo.Exam (
    exam_ID INT IDENTITY(1,1) PRIMARY KEY,
    Type_Exam VARCHAR(15),
    Exam_Date DATE,
    exam_StartTime TIME(7),
    exam_TotalDuration INT,
    TotalDegree INT,
    Crs_Id INT,
    class_Id INT,
    Ins_Exam INT,
    FOREIGN KEY (class_Id) REFERENCES dbo.Class(ClassID),
    FOREIGN KEY (Crs_Id) REFERENCES dbo.Courses(id),
    FOREIGN KEY (Ins_Exam) REFERENCES dbo.Instructor(ID)
);
go

-- Creating ExamQuestion table
CREATE TABLE dbo.ExamQuestion (
    ExamID INT,
    QuestionID VARCHAR(5),
    Degree INT,
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES dbo.Exam(exam_ID),
    FOREIGN KEY (QuestionID) REFERENCES dbo.Question(ID)
);
go

-- Creating StudentExam table
CREATE TABLE dbo.StudentExam (
    ExamID INT,
    QuestionID VARCHAR(5),
    StudentID INT,
    StudentAnswer VARCHAR(255),
    Result INT,
    PRIMARY KEY (ExamID, QuestionID, StudentID),
    FOREIGN KEY (ExamID) REFERENCES dbo.Exam(exam_ID),
    FOREIGN KEY (QuestionID) REFERENCES dbo.Question(ID),
    FOREIGN KEY (StudentID) REFERENCES dbo.Student(Std_ID)
);

-- ======================== Insert Data =======================

USE Examination_DB;
go

-- Insert data into Branch table
INSERT INTO dbo.Branch (Name) VALUES ('Branch1'), ('Branch2'), ('Branch3');
go

-- Insert data into Intake table
INSERT INTO dbo.Intake (Name, Intake_Year) VALUES ('Intake1', 2022), ('Intake2', 2023), ('Intake3', 2024);
go

-- Insert data into Tracks table
INSERT INTO dbo.Tracks (Track) VALUES ('Track1'), ('Track2'), ('Track3');
go

-- Insert data into User_Account table
INSERT INTO dbo.User_Account (UserName, UserPassword, UserType) VALUES
    ('admin', 'admin123', 'Admin'),
    ('student1', 'student123', 'Student'),
    ('instructor1', 'instructor123', 'Instructor');
go

-- Insert data into Courses table
INSERT INTO dbo.Courses (name, description, max_degree, min_degree) VALUES
    ('Mathematics', 'Introduction to Mathematics', 100, 50),
    ('Physics', 'Basic Physics Concepts', 90, 60),
    ('History', 'World History Overview', 80, 40);
go

-- Insert data into Question table
INSERT INTO dbo.Question (ID, text, type, degree, correct_answer) VALUES
    ('Q1', 'What is 2 + 2?', 'Multiple Choice', 10, '4'),
    ('Q2', 'Is the Earth round?', 'True/False', 5, 'True'),
    ('Q3', 'Name one element on the periodic table.', 'Short Answer', 15, 'Oxygen');
go

-- Insert data into Choices table
INSERT INTO dbo.Choices (ID, choose) VALUES
    ('Q1', 'Option A'), ('Q1', 'Option B'), ('Q1', 'Option C'),
    ('Q2', 'True'), ('Q2', 'False');
go

-- Insert data into Class table
INSERT INTO dbo.Class (ClassID, TrackID, BranchID, IntakeID) VALUES
    (1, 1, 1, 1),
    (2, 2, 2, 2),
    (3, 3, 3, 3);
go

-- Insert data into Student table
INSERT INTO dbo.Student (Std_ID, std_Name, std_Age, std_City, std_Email, Class_ID, User_ID) VALUES
    (1, 'Alice Johnson', 20, 'New York', 'alice.j@example.com', 1, 1),
    (2, 'Charlie Brown', 22, 'Los Angeles', 'charlie.b@example.com', 2, 2),
    (3, 'Eva White', 21, 'Chicago', 'eva.white@example.com', 3, 3);
go

-- Insert data into Instructor table
INSERT INTO dbo.Instructor (ID, name, User_ID) VALUES
    (1, 'Instructor1', 1),
    (2, 'Instructor2', 2),
    (3, 'Instructor3', 3);
go

-- Insert data into Instructor_Courses table
INSERT INTO dbo.Instructor_Courses (Instructor_id, Course_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3);
go

-- Insert data into StudentCourse table
INSERT INTO dbo.StudentCourse (StudentID, CourseID, TotalDegree, FinalResult) VALUES
    (1, 1, 80, 'Pass'),
    (2, 2, 55, 'Corrective'),
    (3, 3, 90, 'Pass');
go

-- Insert data into Exam table
INSERT INTO dbo.Exam (Type_Exam, Exam_Date, exam_StartTime, exam_TotalDuration, TotalDegree, Crs_Id, class_Id, Ins_Exam) VALUES
    ('Midterm', '2024-02-15', '10:00:00', 120, 100, 1, 1, 1),
    ('Final', '2024-05-20', '14:00:00', 180, 150, 2, 2, 2),
    ('Quiz', '2024-03-10', '09:30:00', 60, 50, 3, 3, 3);
go

-- Insert data into ExamQuestion table
INSERT INTO dbo.ExamQuestion (ExamID, QuestionID, Degree) VALUES
    (1, 'Q1', 10),
    (2, 'Q2', 20),
    (3, 'Q3', 30);
go

-- Insert data into StudentExam table
INSERT INTO dbo.StudentExam (ExamID, QuestionID, StudentID, StudentAnswer, Result) VALUES
    (1, 'Q1', 1, 'Option A', 10),
    (2, 'Q2', 2, 'True', 15),
    (3, 'Q3', 3, 'Oxygen', 30);


-- ======================== Permission =======================

USE Examination_DB;
go

-- Admin

-- Training Manager
CREATE LOGIN TrainingManager WITH PASSWORD = 't123';
go

-- Create user for Training Manager
CREATE USER TrainingManager FOR LOGIN TrainingManager;
go

-- Permissions on tables
GRANT SELECT, INSERT, UPDATE ON OBJECT::[dbo].[Branch] TO TrainingManager;
GRANT SELECT, INSERT, UPDATE ON OBJECT::[dbo].[Tracks] TO TrainingManager;
GRANT SELECT, INSERT ON OBJECT::[dbo].[Intake] TO TrainingManager;
GRANT SELECT, INSERT ON OBJECT::[dbo].[Student] TO TrainingManager;
GRANT SELECT ON OBJECT::[dbo].[Instructor] TO TrainingManager;
go

-- Instructor
CREATE LOGIN Instructor WITH PASSWORD = 'i123';
go

-- Create user for Instructor
CREATE USER Instructor FOR LOGIN Instructor;
go

-- Permissions on tables 
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Instructor] TO Instructor;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Courses] TO Instructor;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Instructor_Courses] TO Instructor;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Question] TO Instructor;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Exam] TO Instructor;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[ExamQuestion] TO Instructor;
GRANT SELECT ON OBJECT::[dbo].[StudentExam] TO Instructor;
GRANT SELECT ON OBJECT::[dbo].[Student] TO Instructor;
go

-- Student
CREATE LOGIN Student WITH PASSWORD = 's123';
go

-- Create user for Student
CREATE USER Student FOR LOGIN Student;
go

-- Permissions on tables 
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Student] TO Student;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[StudentExam] TO Student;
GRANT SELECT ON OBJECT::[dbo].[StudentCourse] TO Student;
DENY SELECT ON OBJECT::[dbo].[ExamQuestion] TO Student;
go

-- Transfer each user to their respective schema
ALTER USER TrainingManager WITH DEFAULT_SCHEMA = T_Manager;
ALTER USER Instructor WITH DEFAULT_SCHEMA = Instructor;
ALTER USER Student WITH DEFAULT_SCHEMA = Student;
go

-- Grant Control permissions on schemas
GRANT CONTROL ON SCHEMA::T_Manager TO TrainingManager;
GRANT CONTROL ON SCHEMA::Instructor TO Instructor;
GRANT CONTROL ON SCHEMA::Student TO Student;

-- ======================== Trigger =======================

USE Examination_DB;
go

-- Exam Created Trigger
CREATE OR ALTER TRIGGER Trg_Exam
ON Exam
AFTER INSERT
AS
BEGIN
    PRINT 'Exam Created Successfully';
End;
go

-- Update Student Answer Trigger
CREATE OR ALTER TRIGGER Trg_UpdateStudentAnswer
ON [dbo].[StudentExam]
AFTER UPDATE
AS
BEGIN
    IF UPDATE([StudentAnswer])
    BEGIN
        PRINT 'Answer Added Successfully';
    END
END;
go

-- Add Student to Exam Trigger
CREATE OR ALTER TRIGGER Trg_AddStudentToExamFromInstructor
ON [dbo].[StudentExam]
AFTER INSERT
AS
BEGIN
    PRINT 'Students Added Successfully';
END;
go

-- Mark Exam Trigger
CREATE OR ALTER TRIGGER Trg_MarkExam
ON [dbo].[StudentExam]
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Result)
    BEGIN
        PRINT 'Exam Marked Successfully';
    END
END;
go

-- Insert Data in ExamQuestion Table Trigger
CREATE OR ALTER TRIGGER Trg_ExamQuestion_Inserted
ON ExamQuestion
AFTER INSERT
AS
BEGIN
    PRINT 'Inserting Process Is Successful';
END;
go

-- Update Final Result Trigger
CREATE OR ALTER TRIGGER Trg_UpdateFinalResult
ON [StudentCourse]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE sc
    SET FinalResult = 
        CASE 
            WHEN sc.TotalDegree < (SELECT TOP 1 e.min_degree FROM Courses e WHERE e.id = inserted.CourseID) THEN 'Corrective'
            ELSE 'Pass'
        END
    FROM [StudentCourse] sc
    INNER JOIN inserted ON sc.StudentID = inserted.StudentID;
END;

-- ======================== Procedure =======================

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


-- ======================== Backup =======================

-- SQL SERVER AGENT: [Examination_DB_Job]