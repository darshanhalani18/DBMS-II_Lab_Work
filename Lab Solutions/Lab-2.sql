
-- Lab-2 : Stored Procedure

-- PART-A

-- 1. INSERT Procedures: Create stored procedures to insert records into STUDENT tables.(PR_INSERT_STUDENT)

GO
CREATE OR ALTER PROCEDURE PR_INSERT_STUDENT
@SID			INT,
@NAME			VARCHAR(100),
@EMAIL			VARCHAR(100),
@PHONE			VARCHAR(15),
@DEPARTMENT		VARCHAR(50),
@DOB			DATE,
@ENROLLYEAR		INT
AS
BEGIN
	INSERT INTO STUDENT(StudentID,StuName,StuEmail,StuPhone,StuDepartment,StuDateOfBirth,StuEnrollmentYear)
	VALUES
	(@SID,@NAME,@EMAIL,@PHONE,@DEPARTMENT,@DOB,@ENROLLYEAR);
END;

execute PR_INSERT_STUDENT 10,'Harsh Parmar','harsh@univ.edu','9876543219','CSE','2005-09-18',2023;
exec    PR_INSERT_STUDENT 11,'Om Patel','om@univ.edu','9876543220','IT','2002-08-22',2022;

-- 2. INSERT Procedures: Create stored procedures to insert records into COURSE tables.(PR_INSERT_COURSE)

GO
CREATE OR ALTER PROCEDURE PR_INSERT_COURSE
@CID			VARCHAR(10),
@NAME			VARCHAR(100),
@CREDITS		INT,
@DEPARTMENT		VARCHAR(50),
@SEMESTER		INT
AS
BEGIN
	INSERT INTO COURSE(CourseID,CourseName,CourseCredits,CourseDepartment,CourseSemester)
	VALUES
	(@CID,@NAME,@CREDITS,@DEPARTMENT,@SEMESTER);
END

exec PR_INSERT_COURSE 'CS330','Computer Networks',4,'CSE',5;
exec PR_INSERT_COURSE 'EC120','Electronic Circuits',3,'ECE',2;

-- 3. UPDATE Procedures: Create stored procedure PR_UPDATE_STUDENT to update Email and Phone in STUDENT table. (Update using studentID)

GO
CREATE OR ALTER PROCEDURE PR_UPDATE_STUDENT
@SID		INT,
@EMAIL		VARCHAR(100),
@PHONE		VARCHAR(15)
AS
BEGIN
	UPDATE STUDENT SET StuEmail = @EMAIL,StuPhone = @PHONE
	WHERE StudentID = @SID;
END;

exec PR_UPDATE_STUDENT 10,'harsh.parmar@univ.edu','9879999084';

-- 4. DELETE Procedures: Create stored procedure PR_DELETE_STUDENT to delete records from STUDENT where Student Name is Om Patel.

GO
CREATE OR ALTER PROCEDURE PR_DELETE_STUDENT
@NAME		VARCHAR(100)
AS
BEGIN
	DELETE FROM STUDENT WHERE StuName = @NAME;
END;

EXEC PR_DELETE_STUDENT 'Om Patel';

-- 5. SELECT BY PRIMARY KEY: Create stored procedures to select records by primary key (PR_SELECT_STUDENT_BY_ID) from Student table.

GO
CREATE OR ALTER PROCEDURE PR_SELECT_STUDENT_BY_ID
@SID		INT
AS
BEGIN
	SELECT * FROM STUDENT WHERE StudentID = @SID;
END;

EXEC PR_SELECT_STUDENT_BY_ID 2;

-- 6. Create a stored procedure that shows details of the first N students ordered by EnrollmentYear.

GO
CREATE OR ALTER PROCEDURE PR_TOPN_STUDENTS_BY_ENROLLYEAR
@N		INT
AS
BEGIN
	SELECT TOP (@N) * FROM STUDENT
	ORDER BY StuEnrollmentYear;
END;

EXEC PR_TOPN_STUDENTS_BY_ENROLLYEAR 3;

-- 7. Create a stored procedure which displays faculty designation-wise count.

GO
CREATE OR ALTER PROCEDURE PR_FACULTY_DESIGNATION_COUNT
AS
BEGIN
	SELECT FacultyDesignation,COUNT(*) AS COUNT
	FROM FACULTY
	GROUP BY FacultyDesignation;
END;

EXEC PR_FACULTY_DESIGNATION_COUNT;

-- 8. Create a stored procedure that takes department name as input and returns all students in that department.

GO
CREATE OR ALTER PROCEDURE PR_GET_STUDENTS_BY_DEPT
@DEPT		VARCHAR(50)
AS
BEGIN
	SELECT StuName FROM STUDENT
	WHERE StuDepartment = @DEPT;
END;

EXEC PR_GET_STUDENTS_BY_DEPT 'CSE';


-- PART-C

-- 9. Create a stored procedure which displays department-wise maximum, minimum, and average credits of courses.

GO
CREATE OR ALTER PROCEDURE PR_GET_DEPT_CREDITS_STATISTICS
AS
BEGIN
	SELECT CourseDepartment,
		   MAX(CourseCredits) AS Maximum,
		   MIN(CourseCredits)AS Minimum,
		   AVG(CourseCredits) AS Average
	FROM COURSE
	GROUP BY CourseDepartment;
END;

EXEC PR_GET_DEPT_CREDITS_STATISTICS;

-- 10. Create a stored procedure that accepts StudentID as parameter and returns all courses the student is enrolled in with their grades.

GO
CREATE OR ALTER PROCEDURE PR_GET_STUDENT_COURSES_GRADES
@SID		INT
AS
BEGIN
	SELECT C.CourseName,E.Grade
	FROM STUDENT S
	JOIN ENROLLMENT E
	ON S.StudentID = E.StudentID
	JOIN COURSE C
	ON E.CourseID = C.CourseID
	WHERE S.StudentID = @SID;
END;

EXEC PR_GET_STUDENT_COURSES_GRADES 1;