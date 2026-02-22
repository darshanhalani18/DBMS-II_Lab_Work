
-- Lab-7 : Instead of Trigger

-- Table : Log(LogMessage varchar(100), logDate Datetime)

CREATE TABLE LOG(
LogMessage	varchar(100),
logDate		datetime
);

SELECT * FROM LOG;

-- To Show triggers on a table.

EXEC sp_helptrigger 'STUDENT';

-- List all triggers in database

SELECT name
FROM sys.triggers;

-- PART-A

--1. Create trigger for blocking student deletion.

GO
CREATE OR ALTER TRIGGER TR_BLOCK_STUDENT_DELETE
ON STUDENT
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'Student deletion is not allowed.';
END;
GO

DELETE FROM STUDENT WHERE StudentID = 1;

SELECT * FROM STUDENT;

DROP TRIGGER TR_BLOCK_STUDENT_DELETE;

-- OUTPUT:

-- Student deletion is not allowed.
-- (1 row affected)

-- Here Why does it show "1 row affected" ?

-- Ans. SQL Server counts rows matched by the DELETE statement.


--2. Create trigger for making course read-only.

GO
CREATE OR ALTER TRIGGER TR_COURSE_READONLY
ON COURSE
INSTEAD OF INSERT,UPDATE,DELETE
AS
BEGIN
	PRINT 'Course table is read-only.';
END;
GO

UPDATE COURSE SET CourseCredits = 5 WHERE CourseName = 'Database Management Systems';

DROP TRIGGER TR_COURSE_READONLY;

--3. Create trigger for preventing faculty removal.

GO
CREATE OR ALTER TRIGGER TR_BLOCK_FACULTY_DELETE
ON FACULTY
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Faculty removal is not allowed.';
END;
GO

DELETE FROM FACULTY WHERE FacultyName = 'Dr. Patel';
SELECT * FROM FACULTY;

DROP TRIGGER TR_BLOCK_FACULTY_DELETE;

--4. Create instead of trigger to log all operations on COURSE (INSERT/UPDATE/DELETE) into Log table.
-- (Example: INSERT/UPDATE/DELETE operations are blocked for you in course table)

GO
CREATE OR ALTER TRIGGER TR_LOG_COURSE_OPERATIONS
ON COURSE
INSTEAD OF INSERT,UPDATE,DELETE
AS
BEGIN
	PRINT 'You can only read course table,You can not modify course table.';

	INSERT INTO LOG(LogMessage,logDate)
	VALUES ('INSERT/UPDATE/DELETE operations are blocked for you in course table.',GETDATE());
END;
GO

INSERT INTO COURSE(CourseID,CourseName,CourseCredits,CourseDepartment,CourseSemester) VALUES
('2301CS401','DBMS-II',4,'CSE',4);

SELECT * FROM COURSE;
SELECT * FROM LOG;

--5. Create trigger to Block student to update their enrollment year and print message ‘students are not
--allowed to update their enrollment year.

GO
CREATE OR ALTER TRIGGER TR_BLOCK_ENROLLMENT_YEAR_UPDATE
ON STUDENT
INSTEAD OF UPDATE
AS
BEGIN

--  UPDATE(column) : checks if column is used in UPDATE statement.

	IF UPDATE(StuEnrollmentYear)
	BEGIN
		PRINT 'Students are not allowed to update enrollment year.';
		RETURN;
	END;
END;
GO

UPDATE STUDENT SET StuEnrollmentYear = 2026
WHERE StuName = 'Raj Patel';

-- Try updating another column

UPDATE STUDENT
SET StuDepartment = 'IT'
WHERE StuName = 'Raj Patel';

SELECT * FROM STUDENT;

-- Result:

-- Query shows "1 row affected",
-- but the department is not updated because
-- the INSTEAD OF UPDATE trigger replaces
-- the original update operation on the STUDENT table.


-- OR (Using Rollback)

GO
CREATE OR ALTER TRIGGER TR_BLOCK_ENROLLMENT_YEAR_UPDATE
ON STUDENT
AFTER UPDATE
AS
BEGIN
    DECLARE @OldYear INT,
            @NewYear INT;

    SELECT @OldYear = StuEnrollmentYear FROM deleted;
    SELECT @NewYear = StuEnrollmentYear FROM inserted;

    IF @OldYear != @NewYear
    BEGIN
        PRINT 'Students are not allowed to update enrollment year.';

--		ROLLBACK = Undo everything in the current transaction and cancels the database change.

        ROLLBACK TRANSACTION;
    END
END;
GO


UPDATE STUDENT SET StuEnrollmentYear = 2026
WHERE StuName = 'Raj Patel';

SELECT * FROM STUDENT;

DROP TRIGGER TR_BLOCK_ENROLLMENT_YEAR_UPDATE;

--6. Create trigger for student age validation (Min 18).

GO
CREATE OR ALTER TRIGGER TR_VALIDATE_STUDENT_AGE
ON STUDENT
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @DOB DATE;

	SELECT @DOB = StuDateOfBirth FROM inserted;

	IF DATEDIFF(YEAR,@DOB,GETDATE()) < 18
	BEGIN
		PRINT 'Invalid Date of Birth! Student must be at least 18 years old.';
        RETURN;
	END;

--	 Allow insertion (If age >= 18)


	INSERT INTO STUDENT SELECT * FROM inserted

--				OR

--		 INSERT INTO STUDENT
--			SELECT StudentID, StuName, StuEmail, StuPhone,
--			StuDepartment, StuDateOfBirth,StuEnrollmentYear
--			FROM inserted;
	
END;
GO

INSERT INTO STUDENT(StudentID,StuName,StuEmail,StuPhone,StuDepartment,StuDateOfBirth,StuEnrollmentYear) VALUES
(45,'Jay Patel','jay@univ.edu','9879999084','CSE','2025-09-18',2024);

-- Try inserting a student record where the age is greater than 18.

INSERT INTO STUDENT(StudentID,StuName,StuEmail,StuPhone,StuDepartment,StuDateOfBirth,StuEnrollmentYear) VALUES
(45,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

SELECT * FROM STUDENT;

DROP TRIGGER TR_VALIDATE_STUDENT_AGE;

-- PART-B

--7. Create trigger for unique faculty’s email check.

GO
CREATE OR ALTER TRIGGER TR_UNIQUE_FACULTY_EMAIL
ON FACULTY
INSTEAD OF INSERT,UPDATE
AS
BEGIN
	DECLARE @EMAIL VARCHAR(100);

	SELECT @EMAIL = FacultyEmail FROM inserted;

	IF @EMAIL IN (SELECT FacultyEmail FROM FACULTY)
	BEGIN
		PRINT 'Duplicate faculty email is not allowed.';
		RETURN;
	END;

-- If email is unique then insert/update

-- Update existing faculty - Update old data using new data from inserted table.
	
-- For Example..

--	UPDATE Faculty
--		SET FacultyName = (SELECT FacultyName FROM inserted)
--	WHERE ID matches

	UPDATE F
	SET
		F.FacultyID = I.FacultyID,
		F.FacultyName = I.FacultyName,
		F.FacultyEmail = I.FacultyEmail,
		F.FacultyDepartment = I.FacultyDepartment,
		F.FacultyDesignation = I.FacultyDesignation,
		F.FacultyJoiningDate = I.FacultyJoiningDate
	FROM FACULTY F JOIN inserted I
	ON F.FacultyID = I.FacultyID

	-- Insert new faculty

	INSERT INTO FACULTY 
	SELECT * FROM inserted where FacultyID NOT IN (SELECT FacultyID FROM FACULTY);
END;
GO

SELECT * FROM FACULTY;

INSERT INTO FACULTY (FacultyID,FacultyName,FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate)
VALUES (109,'Arjun Bala','patel@univ.edu','CSE','Assistant Prof','2020-01-01')

-- Try to insert with unique email.

INSERT INTO FACULTY (FacultyID,FacultyName,FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate)
VALUES (109,'Arjun Bala','arjun@univ.edu','CSE','Assistant Prof','2020-01-01')

UPDATE FACULTY SET FacultyEmail = 'mehta@univ.edu' WHERE FacultyName = 'Dr. Sheth';

DROP TRIGGER TR_UNIQUE_FACULTY_EMAIL;


--8. Create trigger for preventing duplicate enrollment.

-- Prevent duplicate means - StudentID + CourseID must be unique

GO
CREATE OR ALTER TRIGGER TR_PREVENT_DUPLICATE_ENROLLMENT
ON ENROLLMENT
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @SID INT,@CID VARCHAR(10);

	SELECT @SID = StudentID,@CID = CourseID from inserted;

-- Check if student already exists in same course.

--  Count rows where student and course both match.
--	If count > 0 -> duplicate.

	IF 
	  (
		SELECT COUNT(*) FROM
		ENROLLMENT WHERE StudentID = @SID and CourseID = @CID
	  ) > 0
	BEGIN
		PRINT 'Duplicate enrollment not allowed.'
		RETURN;
	END;

--  Allow Insert if not duplicate...

	INSERT INTO ENROLLMENT (StudentID, CourseID, EnrollmentDate,Grade,EnrollmentStatus)
	SELECT StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus FROM inserted;

END;
GO

SELECT * FROM ENROLLMENT;

DROP TRIGGER TR_PREVENT_DUPLICATE_ENROLLMENT;

-- PART-C

--9. Create trigger to Allow enrolment in month from Jan to August, otherwise print message enrolment
-- closed.

GO
CREATE OR ALTER TRIGGER TR_ENROLLMENT_MONTH_CHECK
ON ENROLLMENT
INSTEAD OF INSERT
AS
BEGIN
	IF MONTH(GETDATE()) < 8
		INSERT INTO ENROLLMENT (StudentID, CourseID, EnrollmentDate,Grade,EnrollmentStatus)
		SELECT StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus FROM inserted;
	ELSE
		 PRINT 'Enrollment closed.';
END;
GO

DROP TRIGGER TR_ENROLLMENT_MONTH_CHECK;

--10. Create trigger to Allow only grade change in enrollment (block other updates).

-- If Grade column updated -> allow update
-- Else -> block update

GO
CREATE OR ALTER TRIGGER TR_ALLOW_ONLY_GRADE_UPDATE
ON ENROLLMENT
INSTEAD OF UPDATE
AS
BEGIN
	IF UPDATE(GRADE)
		UPDATE ENROLLMENT
		SET Grade = I.Grade
		FROM ENROLLMENT E JOIN inserted I
		ON E.EnrollmentID = I.EnrollmentID;

	ELSE 
		 PRINT 'Only grade change is allowed.';
END;
GO

DROP TRIGGER TR_ALLOW_ONLY_GRADE_UPDATE;