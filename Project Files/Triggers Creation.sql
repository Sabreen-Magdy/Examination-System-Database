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