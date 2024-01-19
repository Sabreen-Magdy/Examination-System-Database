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