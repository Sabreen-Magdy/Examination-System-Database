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
