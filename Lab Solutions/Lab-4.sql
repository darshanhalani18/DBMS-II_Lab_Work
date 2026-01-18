-- Lab-4 : UDF

-- PART-A

--1. Write a scalar function to print "Welcome to DBMS Lab".

GO
CREATE OR ALTER FUNCTION FN_WELCOME()
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN 'Welcome to DBMS Lab';
END;
GO

SELECT dbo.FN_WELCOME() as [Welcome Msg];

--2. Write a scalar function to calculate simple interest.

GO
CREATE OR ALTER FUNCTION FN_SIMPLE_INTEREST
(
	@P FLOAT,
	@R FLOAT,
	@N FLOAT
)
RETURNS FLOAT
AS
BEGIN
	RETURN (@P * @R * @N) / 100;
END;
GO

SELECT DBO.FN_SIMPLE_INTEREST(1000,2,2) AS SimpleInterest;

--3. Function to Get Difference in Days Between Two Given Dates.

GO
CREATE OR ALTER FUNCTION FN_DATE_DIFF_DAYS
(
	@DATE1	DATE,
	@DATE2	DATE
)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(DAY,@DATE1,@DATE2);
END;
GO

SELECT DBO.FN_DATE_DIFF_DAYS('2025-12-31','2026-01-05') as Difference;

--4. Write a scalar function which returns the sum of Credits for two given CourseIDs.

GO
CREATE OR ALTER FUNCTION FN_SUM_OF_CREDITS
(
	@CID1 VARCHAR(10),
	@CID2 VARCHAR(10)
)
RETURNS INT
AS
BEGIN
	DECLARE @TOTAL INT;

	SELECT @TOTAL = SUM(CourseCredits) FROM COURSE
	WHERE CourseID IN (@CID1,@CID2);

	RETURN @TOTAL;
END;
GO

SELECT DBO.FN_SUM_OF_CREDITS('CS101','CS201') AS SUM;

--5. Write a function to check whether the given number is ODD or EVEN.

GO
CREATE OR ALTER FUNCTION FN_ODD_EVEN
(
	@N	INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @RESULT VARCHAR(50)
	IF(@N % 2 = 0)
		SET @RESULT = 'EVEN NUMBER'
	ELSE
		SET @RESULT = 'ODD NUMBER'
	RETURN @RESULT
END;
GO

SELECT DBO.FN_ODD_EVEN(4) AS RESULT;

-- OR

GO
CREATE OR ALTER FUNCTION FN_ODD_EVEN
(
	@N INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN CASE
		WHEN @N % 2 = 0 THEN 'EVEN NUMBER'
		ELSE 'ODD NUMBER'
	END;
END;
GO

SELECT DBO.FN_ODD_EVEN(5) AS RESULT;

--6. Write a function to print number from 1 to N. (Using while loop)

GO
CREATE OR ALTER FUNCTION FN_PRINT_1_TO_N
(
	@N INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @I INT = 1;
	DECLARE @RESULT VARCHAR(MAX) = '';

	WHILE @I <= @N
	BEGIN
		SET @RESULT = @RESULT + CAST(@I AS VARCHAR) + ' ';
		SET @I = @I + 1;
	END;
	RETURN @RESULT;
END;
GO

SELECT DBO.FN_PRINT_1_TO_N(10);

--7. Write a scalar function to calculate factorial of total credits for a given CourseID.

GO
CREATE OR ALTER FUNCTION FN_FACTORIAL_CREDITS
(
	@CID VARCHAR(10)
)
RETURNS INT
AS
BEGIN
	DECLARE @CREDITS INT,@FACT INT = 1,@I INT = 1;

	SELECT @CREDITS = CourseCredits FROM COURSE WHERE CourseID = @CID;

	WHILE @I <= @CREDITS
	BEGIN
		SET @FACT = @FACT * @I;
		SET @I = @I + 1;
	END;
	RETURN @FACT;
END;
GO

SELECT DBO.FN_FACTORIAL_CREDITS('CS101') AS FACTORIAL;

--8. Write a scalar function to check whether a given EnrollmentYear is in the past, current or future (Case
--statement)

GO
CREATE OR ALTER FUNCTION FN_CHECK_ENROLLYEAR
(
	@YEAR INT
)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @RESULT VARCHAR(50);

	SET @RESULT =
		CASE
		WHEN @YEAR < YEAR(GETDATE()) THEN 'PAST'
		WHEN @YEAR = YEAR(GETDATE()) THEN 'CURRENT'
		ELSE 'FUTURE'
	END;
	
	RETURN @RESULT;
END;
GO

SELECT DBO.FN_CHECK_ENROLLYEAR(2026);

--9. Write a table-valued function that returns details of students whose names start with a given letter.

GO
CREATE OR ALTER FUNCTION FN_STUDENTS_BY_START_LETTER
(
	@LETTER CHAR(1)
)
RETURNS TABLE
AS
RETURN
	SELECT * FROM STUDENT WHERE StuName LIKE @LETTER + '%';
GO

SELECT * FROM DBO.FN_STUDENTS_BY_START_LETTER('R');

--10. Write a table-valued function that returns unique department names from the STUDENT table.

GO
CREATE OR ALTER FUNCTION FN_UNIQUE_DEPARTMENTS()
RETURNS TABLE
AS
RETURN
	(SELECT DISTINCT StuDepartment FROM STUDENT);
GO

SELECT * FROM DBO.FN_UNIQUE_DEPARTMENTS();

--PART-B

--11. Write a scalar function that calculates age in years given a DateOfBirth.

GO
CREATE OR ALTER FUNCTION FN_CALCULATE_AGE
(
	@DOB	DATE
)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(YEAR,@DOB,GETDATE());
END;
GO

SELECT DBO.FN_CALCULATE_AGE('2005-09-18') AS AGE;

--12. Write a scalar function to check whether given number is palindrome or not.

GO
CREATE OR ALTER FUNCTION FN_CHECK_PALINDROME
(
	@N	INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @TEMP	INT = @N;
	DECLARE @REM	INT;
	DECLARE @REV	INT = 0;
	DECLARE @RESULT VARCHAR(50);

	WHILE @TEMP > 0
	BEGIN
		SET @REM = @TEMP % 10;
		SET @REV = (@REV * 10) + @REM;
		SET @TEMP = @TEMP / 10;
	END;

	IF @REV = @N
		SET @RESULT = 'PALINDROME';
	ELSE
		SET @RESULT = 'NOT PALINDROME';

	RETURN @RESULT;
END;
GO

SELECT  DBO.FN_CHECK_PALINDROME(121);

-- OR

GO
CREATE OR ALTER FUNCTION FN_CHECK_PALINDROME
(
	@N	INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @TEMP	INT = @N;
	DECLARE @REM	INT;
	DECLARE @REV	INT = 0;

	WHILE @TEMP > 0
	BEGIN
		SET @REM = @TEMP % 10;
		SET @REV = (@REV * 10) + @REM;
		SET @TEMP = @TEMP / 10;
	END;
	
	RETURN CASE
		WHEN @REV = @N THEN 'PALINDROME'
		ELSE 'NOT PALINDROME'
		END;
END;
GO

-- Palindrome using REVERSE()

GO
CREATE OR ALTER FUNCTION FN_CHECK_PALINDROME
(
	@N INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	IF CAST(@N AS VARCHAR) = REVERSE(CAST(@N AS VARCHAR))
		RETURN 'PALINDROME';

	RETURN 'NOT PALINDROME'
END;
GO

--13. Write a scalar function to calculate the sum of Credits for all courses in the 'CSE' department.

GO
CREATE OR ALTER FUNCTION FN_TOTAL_CSE_CREDITS()
RETURNS INT
AS
BEGIN
	DECLARE @TOTAL INT;

	SELECT @TOTAL = SUM(CourseCredits) FROM COURSE
	WHERE CourseDepartment = 'CSE';

	RETURN @TOTAL;
END;
GO

SELECT DBO.FN_TOTAL_CSE_CREDITS() AS Total_Credits;

--14. Write a table-valued function that returns all courses taught by faculty with a specific designation.

GO
CREATE OR ALTER FUNCTION FN_COURSES_BY_DESIGNATION
(
	@DESIGNATION	VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
	SELECT C.CourseName,F.FacultyName,F.FacultyDesignation
	FROM COURSE_ASSIGNMENT CA JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	JOIN COURSE C
	ON CA.CourseID = C.CourseID
	WHERE F.FacultyDesignation = @DESIGNATION
);
GO

SELECT * FROM DBO.FN_COURSES_BY_DESIGNATION('Professor');

--PART-C

--15. Write a scalar function that accepts StudentID and returns their total enrolled credits (sum of credits
--from all active enrollments).

GO
CREATE OR ALTER FUNCTION FN_TOTAL_ENROLLED_CREDITS
(
	@SID	INT
)
RETURNS INT
AS
BEGIN
	DECLARE @TOTAL INT;

	SELECT @TOTAL = SUM(C.CourseCredits)
	FROM ENROLLMENT E JOIN COURSE C
	ON E.CourseID = C.CourseID
	WHERE E.StudentID = @SID AND E.EnrollmentStatus = 'Active';

	RETURN @TOTAL;
END;
GO

SELECT DBO.FN_TOTAL_ENROLLED_CREDITS(1) AS Total_Enrolled_Credits;

--16. Write a scalar function that accepts two dates (joining date range) and returns the count of faculty who
--joined in that period.

GO
CREATE OR ALTER FUNCTION FN_COUNT_FACULTY_BY_JOIN_DATE
(
	@FROMDATE	DATE,
	@TODATE		DATE
)
RETURNS INT
AS
BEGIN
	DECLARE @COUNT	INT;

	SELECT @COUNT = COUNT(*) FROM FACULTY
	WHERE FacultyJoiningDate BETWEEN @FROMDATE AND @TODATE;

	RETURN @COUNT;
END;
GO

SELECT DBO.FN_COUNT_FACULTY_BY_JOIN_DATE('2012-01-01','2015-12-31') AS COUNT;