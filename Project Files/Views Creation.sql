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
