# Examination-System-Database

The Examination System Database stands as a sophisticated and comprehensive solution meticulously crafted to streamline the intricacies of exam management, creation, and evaluation. This system integrates a plethora of features catering to question management, student assessment, and administrative functionalities.

### Core Features

1. *Question Pool Management:*
   - Instructors have access to a versatile question pool, including multiple-choice, true/false, and text questions.
   - Seamless question selection for exam creation is facilitated.

2. *Question Types:*
   - Automated storage of correct answers for multiple-choice and true/false questions.
   - Manual evaluation for text questions, utilizing stored best-accepted answers with text functions and regular expressions.

3. *Course Management:*
   - Centralized storage of course information, with dynamic association of instructors and students to specific courses.

4. *Instructor Responsibilities:*
   - Instructors can add, update, and delete questions within their assigned courses.
   - Facilitates exam creation with the ability to select questions, assign degrees, and define exam parameters.

5. *Training Manager Responsibilities:*
   - Authority over instructors and courses, with granular control over branches, tracks, and intakes.
   - Oversight in adding students and defining their personal data, intake, branch, and track.

6. *User Authentication:*
   - Robust login authentication with role-based access control for training managers, instructors, and students.

### Exam Administration

7. *Exam Creation:*
   - Intuitive exam creation for instructors with flexibility in question selection, degree assignment, and parameters.

8. *Exam Details:*
   - Capture comprehensive details including exam type, intake, branch, track, course, start time, end time, total time, and allowance options.

9. *Student Selection:*
   - Streamlined process for instructors to select eligible students for specific exams.
   - Empowers instructors to define exam-specific details such as date, start time, and end time.

10. *Student Responses:*
    - Automated tracking of student responses during exams.
    - Real-time calculation of correct answers and final results for each student within the course.

11. *Data Integrity and Security:*
    - Stringent implementation of constraints and triggers ensuring data integrity.
    - Utilization of SQL users and permissions for secure, role-based access control.

### Technical Specifications

12. *Database Implementation:*
    - Thoughtful use of file groups based on data size considerations.
    - Implementation of optimal data types with adherence to systematic naming conventions.

13. *Performance Optimization:*
    - Rigorous implementation of indexes to enhance database performance.

14. *Backup System:*
    - Automated daily backup functionality ensuring data resilience.

15. *Query Abstraction:*
    - Adoption of stored procedures and functions for seamless execution of system tasks.
    - User-friendly views for displaying results, eliminating the necessity for users to directly interact with queries.

16. *User Interface:*
    - Intuitive and diverse options for users to search and display results based on varied criteria.

### Testing

17. *Test Data:*
    - Rigorous insertion of test data across all tables to validate and ensure the robust functionality of the system.

This project embodies a meticulously designed system that not only simplifies exam-related tasks but also prioritizes data integrity, security, and optimal performance. The user-friendly interface coupled with robust features ensures a seamless experience for instructors, training managers, and students alike.
