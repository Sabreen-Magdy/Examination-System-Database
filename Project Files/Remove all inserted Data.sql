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