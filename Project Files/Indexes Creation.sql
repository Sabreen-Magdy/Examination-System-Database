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
