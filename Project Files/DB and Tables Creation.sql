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