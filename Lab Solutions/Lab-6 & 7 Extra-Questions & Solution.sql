
-- Lab - 6 & 7 : Extra Questions & Solutions
------------------------------------------------------------

-- Lab-6 : After Trigger

-- For Query 3 : Monitoring specific events on course table

-- Solution

CREATE OR ALTER TRIGGER TR_AFTER_COURSE_MONITOR
ON COURSE
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
    DECLARE @InsertedCount INT,
            @DeletedCount INT;

    SELECT @InsertedCount = COUNT(*) FROM inserted;
    SELECT @DeletedCount = COUNT(*) FROM deleted;

    IF @InsertedCount > 0 AND @DeletedCount > 0
        PRINT 'Course record updated';

    ELSE IF @InsertedCount > 0
        PRINT 'Course record inserted';

    ELSE IF @DeletedCount > 0
        PRINT 'Course record deleted';
END;

-- OR using EXISTS

GO
CREATE OR ALTER TRIGGER TR_AFTER_COURSE_MONITOR
ON COURSE
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted) AND
        EXISTS(SELECT * FROM deleted)
        PRINT 'Course record updated';

    ELSE IF EXISTS(SELECT * FROM inserted)
         PRINT 'Course record inserted';

    ELSE IF EXISTS(SELECT * FROM deleted)
        PRINT 'Course record deleted';
END;
GO

INSERT INTO COURSE VALUES ('2301CS401','DBMS-II',4,'CSE',4);

UPDATE COURSE SET CourseCredits = 5 WHERE CourseName = 'DBMS-II';

DELETE FROM COURSE WHERE CourseName = 'DBMS-II';

SELECT * FROM COURSE;

DROP TRIGGER TR_AFTER_COURSE_MONITOR;


-- For Query 4

-- 1) Example Output in LOG Table

-- Expected Log Format:
-- Student with StudentID - 105, Name - Rahul, Department - IT added successfully!


-- 2) If rows are inserted one-by-one,
--    how many times will the trigger run?

-- Example: inserting rows individually

INSERT INTO STUDENT VALUES
(23,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

INSERT INTO STUDENT VALUES
(24,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

INSERT INTO STUDENT VALUES
(25,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);


-- 3) If multiple students are inserted in a single INSERT statement,
--    how many times does the trigger run?

-- Example: Insert multiple students at once (insert many)

INSERT INTO STUDENT VALUES
(29,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
(30,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
(31,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

----------------------------------------------------------------------------------------------------------------

-- Solution

GO
CREATE OR ALTER TRIGGER TR_AFTER_STUDENT_INSERT
ON STUDENT
FOR INSERT
AS
BEGIN
    -- Using variables (handles only one row)
    
    DECLARE @SID INT,
            @NAME VARCHAR(100),
            @DEPT VARCHAR(50);

    SELECT 
        @SID = StudentID,
        @NAME = StuName,
        @DEPT = StuDepartment
    FROM inserted;

    INSERT INTO LOG (LogMessage, logDate)
    VALUES (
        'Student with StudentID - ' + CAST(@SID AS VARCHAR) +
        ', Name - ' + @NAME +
        ', Department - ' + @DEPT +
        ' added successfully!',
        GETDATE()
    );
END;
GO

DROP TRIGGER TR_AFTER_STUDENT_INSERT;
------------------------------------------------------------
-- Case 1: Rows inserted one-by-one
-- Trigger runs once per INSERT statement
-- Therefore, trigger runs 3 times here.
------------------------------------------------------------

INSERT INTO STUDENT VALUES
(47,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

INSERT INTO STUDENT VALUES
(48,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

INSERT INTO STUDENT VALUES
(49,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

SELECT * FROM LOG;
SELECT * FROM STUDENT;

------------------------------------------------------------
-- Case 2: Multiple rows inserted at once
-- Trigger runs only once.
-- But variables store only one row,
-- so only one log entry is inserted.
------------------------------------------------------------

INSERT INTO STUDENT VALUES
(50,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
(51,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
(52,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

SELECT * FROM LOG;
SELECT * FROM STUDENT;

------------------------------------------------------------
-- Correct Method: Handle multiple rows properly
-- Use SELECT FROM inserted instead of variables.
------------------------------------------------------------

GO
CREATE OR ALTER TRIGGER TR_AFTER_STUDENT_INSERT
ON STUDENT
FOR INSERT
AS
BEGIN
    INSERT INTO LOG (LogMessage, logDate)
    SELECT
        'Student with StudentID - ' + CAST(StudentID AS VARCHAR) +
        ', Name - ' + StuName +
        ', Department - ' + StuDepartment +
        ' added successfully!',
        GETDATE()
    FROM inserted;
END;
GO

DROP TRIGGER TR_AFTER_STUDENT_INSERT;

------------------------------------------------------------
-- Insert multiple rows again
-- Trigger runs once, but all rows are logged.
------------------------------------------------------------

INSERT INTO STUDENT VALUES
(42,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
(43,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
(44,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

SELECT * FROM LOG;


----------------------------------------------------------------------------------------------------------------

-- Lab-7: INSTEAD OF Trigger

-- For Query-4

-- Detect which operation is attempted on COURSE table and log it in LOG table.


-- Solution

GO
CREATE OR ALTER TRIGGER TR_LOG_COURSE_OPERATIONS
ON COURSE
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @InsertedCount INT,
            @DeletedCount INT;

    SELECT @InsertedCount = COUNT(*) FROM inserted;
    SELECT @DeletedCount = COUNT(*) FROM deleted;

    IF @InsertedCount > 0 AND @DeletedCount > 0
        INSERT INTO LOG(LogMessage, logDate)
        VALUES ('UPDATE attempted on COURSE', GETDATE());

    ELSE IF @InsertedCount > 0
        INSERT INTO LOG(LogMessage, logDate)
        VALUES ('INSERT attempted on COURSE', GETDATE());

    ELSE IF @DeletedCount > 0
        INSERT INTO LOG(LogMessage, logDate)
        VALUES ('DELETE attempted on COURSE', GETDATE());

    PRINT 'You can only read course table, you cannot modify course table.';
END;
GO

INSERT INTO COURSE(CourseID,CourseName,CourseCredits,CourseDepartment,CourseSemester) VALUES
('2301CS401','DBMS-II',4,'CSE',4);

UPDATE COURSE SET CourseCredits = 5 WHERE CourseName = 'Database Management Systems';

DELETE FROM COURSE WHERE CourseName = 'Database Management Systems';

SELECT * FROM LOG;
SELECT * FROM COURSE;

DROP TRIGGER TR_LOG_COURSE_OPERATIONS;


-- For Query-5

-- Students are NOT allowed to update EnrollmentYear.
-- However, updates to other columns should work.
--
-- Example:
-- Update department → Allowed
-- Update enrollment year → Blocked

-- Solution

GO
CREATE OR ALTER TRIGGER TR_STUDENT_UPDATE
ON STUDENT
INSTEAD OF UPDATE
AS
BEGIN
    IF UPDATE(StuEnrollmentYear)
    BEGIN
        PRINT 'Students are not allowed to update their enrollment year.';
        RETURN;
    END;

    UPDATE STUDENT
    SET 
        StuName = I.StuName,
        StuEmail = I.StuEmail,
        StuPhone = I.StuPhone,
        StuDepartment = I.StuDepartment,
        StuDateOfBirth = I.StuDateOfBirth
    FROM STUDENT S JOIN inserted I
    ON S.StudentID = I.StudentID;
END;
GO

UPDATE STUDENT SET StuEnrollmentYear = 2026
WHERE StuName = 'Raj Patel';

UPDATE STUDENT
SET StuDepartment = 'CSE'
WHERE StuName = 'Raj Patel';

SELECT * FROM STUDENT;

DROP TRIGGER TR_STUDENT_UPDATE;

----------------------------------------------------------------------------------------------------------------

-- Conceptual Questions:

-- 1. What is the difference between an AFTER trigger and an INSTEAD OF trigger?
-- 2. Can triggers return values?
-- 3. Does a trigger run per row or per statement?
-- 4. What data is stored in the inserted and deleted tables?
-- 5. Can multiple AFTER triggers be created on the same table for the same operation?
-- 6. Can multiple INSTEAD OF triggers be created on a single table for the same operation?
-- 7. In an INSTEAD OF trigger, are values present in the inserted and deleted tables while inserting and deleting records?
-- 8. Can a trigger be created on a view? If yes, which type of trigger can be created on a view: AFTER trigger,INSTEAD OF trigger,or both?