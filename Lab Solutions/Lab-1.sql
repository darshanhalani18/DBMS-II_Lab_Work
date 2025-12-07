--Lab-1 : SQL Concepts Revision

--PART-A

--1. Retrieve all unique departments from the STUDENT table.

SELECT DISTINCT StuDepartment FROM STUDENT;

--2. Insert a new student record into the STUDENT table.
-- (9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)

INSERT INTO STUDENT(StudentID,StuName,StuEmail,StuPhone,StuDepartment,StuDateOfBirth,StuEnrollmentYear)
VALUES (9,'Neha Singh','neha.singh@univ.edu','9876543218','IT','2003-09-20',2021)

--3. Change the Email of student 'Raj Patel' to 'raj.p@univ.edu'. (STUDENT table)

UPDATE STUDENT SET StuEmail = 'raj.p@univ.edu' where StuName = 'Raj Patel';

--4. Add a new column 'CGPA' with datatype DECIMAL(3,2) to the STUDENT table.

ALTER TABLE STUDENT ADD CGPA DECIMAL(3,2);

--5. Retrieve all courses whose CourseName starts with 'Data'. (COURSE table)

SELECT * FROM COURSE WHERE CourseName LIKE 'Data%';

--6. Retrieve all students whose Name contains 'Shah'. (STUDENT table)

SELECT * FROM STUDENT WHERE StuName LIKE '%Shah%';

--7. Display all Faculty Names in UPPERCASE. (FACULTY table)

SELECT  UPPER(FacultyName) AS FACULTY FROM FACULTY;

--8. Find all faculty who joined after 2015. (FACULTY table)

SELECT * FROM FACULTY WHERE YEAR(FacultyJoiningDate) > 2015;
--OR
SELECT * FROM FACULTY WHERE DATENAME(YEAR,FacultyJoiningDate) > 2015;

--9. Find the SQUARE ROOT of Credits for the course 'Database Management Systems'. (COURSE table)

SELECT SQRT(CourseCredits) as [Square Root] FROM COURSE WHERE CourseName = 'Database Management Systems';

--10. Find the Current Date using SQL Server in-built function.

SELECT GETDATE() AS [CURRENT DATE];

--11. Find the top 3 students who enrolled earliest (by EnrollmentYear). (STUDENT table)

SELECT TOP 3 * FROM STUDENT ORDER BY StuEnrollmentYear;

--12. Find all enrollments that were made in the year 2022. (ENROLLMENT table)

SELECT * FROM ENROLLMENT WHERE YEAR(EnrollmentDate) = 2022;
--OR
SELECT * FROM ENROLLMENT WHERE DATENAME(YEAR,EnrollmentDate) = 2022;

--13. Find the number of courses offered by each department. (COURSE table)

SELECT CourseDepartment,count(*) AS COURSES FROM COURSE
GROUP BY CourseDepartment;

--14. Retrieve the CourseID which has more than 2 enrollments. (ENROLLMENT table)

SELECT CourseID FROM ENROLLMENT
GROUP BY CourseID
HAVING COUNT(CourseID) > 2;

--15. Retrieve all the student name with their enrollment status. (STUDENT & ENROLLMENT table)

SELECT S.StuName,E.EnrollmentStatus
FROM STUDENT S JOIN ENROLLMENT E
ON S.StudentID = E.StudentID;

--16. Select all student names with their enrolled course names. (STUDENT, COURSE, ENROLLMENT table)

SELECT S.StuName,C.CourseName
FROM STUDENT S JOIN ENROLLMENT E
ON S.StudentID = E.StudentID
JOIN COURSE C
ON E.CourseID = C.CourseID;

--17. Create a view called 'ActiveEnrollments' showing only active enrollments with student name and
-- course name. (STUDENT, COURSE, ENROLLMENT, table)

CREATE OR ALTER VIEW ActiveEnrollments
AS SELECT S.StuName,C.CourseName
FROM STUDENT S JOIN ENROLLMENT E
ON S.StudentID = E.StudentID
JOIN COURSE C
ON E.CourseID = C.CourseID
WHERE E.EnrollmentStatus = 'Active';

SELECT * FROM ActiveEnrollments;

--18. Retrieve the student’s name who is not enrol in any course using subquery. (STUDENT, ENROLLMENT TABLE)

SELECT StuName FROM STUDENT
WHERE StudentID NOT IN
			(SELECT StudentID FROM ENROLLMENT);

--19. Display course name having second highest credit. (COURSE table)

SELECT CourseName FROM COURSE
WHERE CourseCredits = 
			(SELECT MAX(CourseCredits) FROM COURSE
				WHERE CourseCredits < (SELECT MAX(CourseCredits) FROM COURSE)
			);

-- OR
SELECT TOP 1 CourseName,CourseCredits FROM COURSE
WHERE CourseCredits IN
	(SELECT DISTINCT TOP 2 CourseCredits FROM COURSE ORDER BY CourseCredits DESC)
	ORDER BY CourseCredits;

-- OR
SELECT CourseName
FROM COURSE
WHERE CourseCredits = (
  SELECT TOP 1 CourseCredits 
  FROM (SELECT DISTINCT TOP 2 CourseCredits 
        FROM COURSE ORDER BY CourseCredits DESC) AS T
  ORDER BY CourseCredits
);

--PART-B

--20. Retrieve all courses along with the total number of students enrolled. (COURSE, ENROLLMENT table)

SELECT C.CourseName,COUNT(E.StudentID) AS TOTAL_STUDENTS
FROM COURSE C LEFT JOIN ENROLLMENT E
ON C.CourseID = E.CourseID
GROUP BY C.CourseName;

--21. Retrieve the total number of enrollments for each status, showing only statuses that have more than 2 enrollments. (ENROLLMENT table)

SELECT EnrollmentStatus,COUNT(*) AS [TOTAL ENROLLMENTS] FROM ENROLLMENT
GROUP BY EnrollmentStatus
HAVING COUNT(*) > 2;

--22. Retrieve all courses taught by 'Dr. Sheth' and order them by Credits. (FACULTY, COURSE,COURSE_ASSIGNMENT table)

SELECT C.CourseName,C.CourseCredits
FROM FACULTY F JOIN COURSE_ASSIGNMENT CA
ON F.FacultyID = CA.FacultyID
JOIN COURSE C
ON CA.CourseID = C.CourseID
WHERE F.FacultyName = 'Dr. Sheth'
ORDER BY C.CourseCredits;


--PART-C

--23. List all students who are enrolled in more than 3 courses. (STUDENT, ENROLLMENT table)

SELECT S.StudentID,S.StuName
FROM STUDENT S JOIN ENROLLMENT E
ON S.StudentID = E.StudentID
GROUP BY S.StudentID,S.StuName
HAVING COUNT(E.CourseID) > 3;

--24. Find students who have enrolled in both 'CS101' and 'CS201' Using Sub Query. (STUDENT,ENROLLMENT table)

SELECT StuName
FROM STUDENT
WHERE StudentID IN (SELECT StudentID FROM ENROLLMENT WHERE CourseID = 'CS101')
AND   StudentID IN (SELECT StudentID FROM ENROLLMENT WHERE CourseID = 'CS201');

--25. Retrieve department-wise count of faculty members along with their average years of experience
--(calculate experience from JoiningDate). (Faculty table)

SELECT FacultyDepartment,
COUNT(*) AS [TOTAL FACULTY],
AVG(DATEDIFF(YEAR,FacultyJoiningDate,GETDATE())) AS [AVG EXPERIENCE]
FROM FACULTY
GROUP BY FacultyDepartment;