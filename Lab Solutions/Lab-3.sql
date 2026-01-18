-- Lab-3 : Advanced Stored Procedure

-- PART-A

--1. Create a stored procedure that accepts a date and returns all faculty members who joined on that date.
GO
CREATE OR ALTER PROCEDURE PR_GET_FACULTY_BY_JOIN_DATE
@DATE		DATE
AS
BEGIN
	SELECT * FROM FACULTY
	WHERE FacultyJoiningDate = @DATE;
END;

EXEC PR_GET_FACULTY_BY_JOIN_DATE '2015-06-10';

--2. Create a stored procedure for ENROLLMENT table where user enters either StudentID or CourseID and returns
--EnrollmentID, EnrollmentDate, Grade, and Status.

GO
CREATE OR ALTER PROCEDURE PR_GET_ENROLLMENT_DETAIL_BY_SID_OR_CID
@SID		INT				= NULL,
@CID		VARCHAR(10)		= NULL
AS
BEGIN
	SELECT EnrollmentID,StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus
	FROM ENROLLMENT
	WHERE StudentID = @SID OR CourseID = @CID;
END;

EXEC PR_GET_ENROLLMENT_DETAIL_BY_SID_OR_CID 1;
EXEC PR_GET_ENROLLMENT_DETAIL_BY_SID_OR_CID @CID = 'CS101';

--3. Create a stored procedure that accepts two integers (min and max credits) and returns all courses
-- whose credits fall between these values.

GO
CREATE OR ALTER PROCEDURE PR_GET_COURSES_BY_CREDITS
@MIN		INT,
@MAX		INT
AS
BEGIN
	SELECT * FROM COURSE
	WHERE CourseCredits BETWEEN @MIN AND @MAX;
END;

EXEC PR_GET_COURSES_BY_CREDITS 2,4;

--4. Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.

GO
CREATE OR ALTER PROCEDURE PR_GET_STUDENTS_BY_COURSE
@CNAME		VARCHAR(100)
AS
BEGIN
	SELECT S.StuName
	FROM STUDENT S JOIN ENROLLMENT E
	ON S.StudentID = E.StudentID
	JOIN COURSE C
	ON E.CourseID = C.CourseID
	WHERE C.CourseName = @CNAME;
END;

EXEC PR_GET_STUDENTS_BY_COURSE 'Database Management Systems';

--5. Create a stored procedure that accepts Faculty Name and returns all course assignments.

GO
CREATE OR ALTER PROCEDURE PR_GET_COURSE_ASSIGNMENTS_BY_FACULTY
@FNAME		VARCHAR(100)
AS
BEGIN
	SELECT *
	FROM FACULTY F JOIN COURSE_ASSIGNMENT CA
	ON F.FacultyID = CA.FacultyID
	WHERE F.FacultyName = @FNAME;
END;

EXEC PR_GET_COURSE_ASSIGNMENTS_BY_FACULTY 'Dr. Sheth';

--6. Create a stored procedure that accepts Semester number and Year, and returns all course
--assignments with faculty and classroom details.

GO
CREATE OR ALTER PROCEDURE PR_GET_COURSE_ASSIGNMENTS_BY_SEM_YEAR
@SEM		INT,
@YEAR		INT
AS
BEGIN
	SELECT C.CourseName,F.FacultyName,CA.ClassRoom,CA.Semester,CA.Year
	FROM COURSE_ASSIGNMENT CA JOIN COURSE C
	ON CA.CourseID = C.CourseID
	JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	WHERE CA.Semester = @SEM AND CA.Year = @YEAR;
END;

EXEC PR_GET_COURSE_ASSIGNMENTS_BY_SEM_YEAR 3,2024;

-- PART-B

--7. Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment
--details.

GO
CREATE OR ALTER PROCEDURE PR_GET_ENROLLMENT_BY_STATUS
@LETTER		CHAR(1)
AS
BEGIN
	SELECT * FROM ENROLLMENT
	WHERE EnrollmentStatus LIKE @LETTER + '%';
END;

exec PR_GET_ENROLLMENT_BY_STATUS 'C';

--8. Create a stored procedure that accepts either Student Name OR Department Name and returns
--student data accordingly.

GO
CREATE OR ALTER PROCEDURE PR_GET_STUDENTS_BY_NAME_OR_DEPT
@SNAME		VARCHAR(100) = NULL,
@DNAME		VARCHAR(50)	 = NULL
AS
BEGIN
	SELECT * FROM STUDENT
	WHERE StuName = @SNAME OR StuDepartment = @DNAME;
END;

EXEC PR_GET_STUDENTS_BY_NAME_OR_DEPT @DNAME = 'CSE';
--OR

GO
CREATE OR ALTER PROCEDURE PR_GET_STUDENTS_BY_NAME_OR_DEPT
@NAME		VARCHAR(100)
AS
BEGIN
	SELECT * FROM STUDENT
	WHERE StuName = @NAME OR StuDepartment = @NAME;
END;

EXEC PR_GET_STUDENTS_BY_NAME_OR_DEPT 'CSE';
EXEC PR_GET_STUDENTS_BY_NAME_OR_DEPT 'Raj Patel';

--9. Create a stored procedure that accepts CourseID and returns all students enrolled grouped by
--enrollment status with counts.

GO
CREATE OR ALTER PROCEDURE PR_GET_COURSE_ENROLLMENT_STATUS_COUNT
@CID		VARCHAR(10)
AS
BEGIN
	SELECT E.EnrollmentStatus,COUNT(S.StudentID) AS COUNT
	FROM STUDENT S JOIN ENROLLMENT E
	ON S.StudentID = E.StudentID
	JOIN COURSE C
	ON E.CourseID = C.CourseID
	WHERE C.CourseID = @CID
	GROUP BY E.EnrollmentStatus;
END;

EXEC PR_GET_COURSE_ENROLLMENT_STATUS_COUNT 'IT201';

-- PART-C

--10. Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in
--that year with classroom details.

GO
CREATE OR ALTER PROCEDURE PR_GET_COURSES_BY_YEAR
@YEAR		INT
AS
BEGIN
	SELECT C.CourseName,F.FacultyName,CA.Year,CA.ClassRoom
	FROM COURSE_ASSIGNMENT CA JOIN COURSE C
	ON CA.CourseID = C.CourseID
	JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	WHERE CA.Year = @YEAR;
END;

EXEC PR_GET_COURSES_BY_YEAR 2024;

--11. Create a stored procedure that accepts From Date and To Date and returns all enrollments within
--that range with student and course details.

GO
CREATE OR ALTER PROCEDURE PR_GET_ENROLLMENTS_BY_DATE_RANGE
@FROMDATE		DATE,
@TODATE			DATE
AS
BEGIN
	SELECT S.StuName,C.CourseName,E.EnrollmentDate,E.EnrollmentStatus
	FROM STUDENT S JOIN ENROLLMENT E
	ON S.StudentID = E.StudentID
	JOIN COURSE C
	ON E.CourseID = C.CourseID
	WHERE E.EnrollmentDate BETWEEN @FROMDATE AND @TODATE;
END;

EXEC PR_GET_ENROLLMENTS_BY_DATE_RANGE '2021-01-01','2022-12-31';

--12. Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of
--credits of all courses assigned).

GO
CREATE OR ALTER PROCEDURE PR_GET_FACULTY_TEACHING_LOAD
@FID		INT
AS
BEGIN
	SELECT F.FacultyName,SUM(C.CourseCredits) AS [TOTAL TEACHING LOAD]
	FROM COURSE_ASSIGNMENT CA JOIN COURSE C
	ON CA.CourseID = C.CourseID
	JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	WHERE F.FacultyID = @FID
	GROUP BY F.FacultyName;
END;

EXEC PR_GET_FACULTY_TEACHING_LOAD 104;


-- Example of SP with OUT Parameter.

-- SP to Find the number of courses offered by given department.

GO
CREATE OR ALTER PROCEDURE PR_COUNT_COURSES_BY_DEPT
@DEPT		VARCHAR(50),
@COUNT		INT  OUT
AS
BEGIN
	SELECT @COUNT = COUNT(*)
	FROM COURSE
	WHERE CourseDepartment = @DEPT
	GROUP BY CourseDepartment;
END;

DECLARE @COURSE_COUNT	INT
EXEC PR_COUNT_COURSES_BY_DEPT @DEPT = 'CSE', @COUNT = @COURSE_COUNT OUTPUT
SELECT @COURSE_COUNT AS COURSES