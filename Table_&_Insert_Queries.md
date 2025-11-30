## Table Creation Queries

### Table-1 : STUDENT
```sql
CREATE TABLE STUDENT (
  StudentID INT PRIMARY KEY,
  StuName VARCHAR(100) NOT NULL,
  StuEmail VARCHAR(100) NULL,
  StuPhone VARCHAR(15) NULL,
  StuDepartment VARCHAR(50) NOT NULL,
  StuDateOfBirth DATE NOT NULL,
  StuEnrollmentYear INT NOT NULL
);
```
### Table-2 : COURSE
```sql
CREATE TABLE COURSE (
  CourseID VARCHAR(10) PRIMARY KEY,
  CourseName VARCHAR(100) NOT NULL,
  CourseCredits INT NOT NULL,
  CourseDepartment VARCHAR(50) NOT NULL,
  CourseSemester INT NOT NULL
);
```
### Table-3 : FACULTY
```sql
CREATE TABLE FACULTY (
  FacultyID INT PRIMARY KEY,
  FacultyName VARCHAR(100) NOT NULL,
  FacultyEmail VARCHAR(100) NULL,
  FacultyDepartment VARCHAR(50) NOT NULL,
  FacultyDesignation VARCHAR(50) NOT NULL,
  FacultyJoiningDate DATE NOT NULL
);
```
### Table-4 : ENROLLMENT
```sql
CREATE TABLE ENROLLMENT (
  EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
  StudentID INT NOT NULL,
  CourseID VARCHAR(10) NOT NULL,
  EnrollmentDate DATE NULL,
  Grade VARCHAR(2) NULL,
  EnrollmentStatus VARCHAR(20) NOT NULL CHECK (EnrollmentStatus IN ('Active', 'Completed', 'Dropped')),
  FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
  FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID)
);
```
### Table-5 : COURSE_ASSIGNMENT
```sql
CREATE TABLE COURSE_ASSIGNMENT (
  AssignmentID INT PRIMARY KEY IDENTITY(1,1),
  CourseID VARCHAR(10) NOT NULL,
  FacultyID INT NOT NULL,
  Semester INT NOT NULL,
  Year INT NOT NULL,
  ClassRoom VARCHAR(20) NOT NULL,
  FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID),
  FOREIGN KEY (FacultyID) REFERENCES FACULTY(FacultyID)
);
```
## Insert Queries

### Table-1 : STUDENT

```sql
INSERT INTO STUDENT (StudentID,StuName,StuEmail,StuPhone, StuDepartment,StuDateOfBirth,StuEnrollmentYear)
VALUES
(1, 'Raj Patel', 'raj@univ.edu', '9876543210', 'CSE', '2003-05-15', 2021),
(2, 'Priya Shah', 'priya@univ.edu', '9876543211', 'IT', '2002-08-22', 2020),
(3, 'Amit Kumar', 'amit@univ.edu', '9876543212', 'CSE', '2003-11-10', 2021),
(4, 'Sneha Desai', 'sneha@univ.edu', '9876543213', 'ECE', '2004-02-18', 2022),
(5, 'Rohan Mehta', 'rohan@univ.edu', '9876543214', 'IT', '2003-07-25', 2021),
(6, 'Kavita Joshi', 'kavita@univ.edu', '9876543215', 'CSE', '2002-12-30', 2020),
(7, 'Arjun Verma', 'arjun@univ.edu', '9876543216', 'MECH', '2003-04-08', 2021),
(8, 'Pooja Rao', 'pooja@univ.edu', '9876543217', 'ECE', '2004-06-12', 2022);
```

### Table-2 : COURSE

```sql
INSERT INTO COURSE (CourseID,CourseName,CourseCredits,CourseDepartment,CourseSemester)
VALUES
('CS101','Programming Fundamentals',4,'CSE',1),
('CS201','Data Structures',4,'CSE',3),
('CS301','Database Management Systems',4,'CSE',5),
('IT101','Web Technologies',3,'IT',1),
('IT201','Software Engineering',4,'IT',3),
('EC101','Digital Electronics',3,'ECE',1),
('EC201','Microprocessors',4,'ECE',3),
('ME101','Engineering Mechanics',4,'MECH',1),
('CS202','Operating Systems',4,'CSE',4),
('CS302','Artificial Intelligence',3,'CSE',6);
```

### Table-3 FACULTY

```sql
INSERT INTO FACULTY (FacultyID,FacultyName,FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate)
VALUES
(101,'Dr. Sheth','Sheth@univ.edu','CSE','Professor','2010-07-15'),
(102,'Prof. Gupta','gupta@univ.edu','IT','Associate Prof','2012-08-20'),
(103,'Dr. Patel','patel@univ.edu','CSE','Assistant Prof','2015-06-10'),
(104,'Dr. Singh','singh@univ.edu','ECE','Professor','2008-03-25'),
(105,'Prof. Reddy','reddy@univ.edu','IT','Assistant Prof','2018-01-15'),
(106,'Dr. Iyer','iyer@univ.edu','MECH','Associate Prof','2013-09-05'),
(107,'Prof. Nair','nair@univ.edu','CSE','Assistant Prof','2019-07-20');
```
### Table-4 : ENROLLMENT

```sql
INSERT INTO ENROLLMENT (StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus)
VALUES
(1,'CS101','2021-07-01','A','Completed'),
(1,'CS201','2022-01-05','B+','Completed'),
(1,'CS301','2023-07-01',NULL,'Active'),
(2,'IT101','2020-07-01','A','Completed'),
(2,'IT201','2021-07-01','A-','Completed'),
(3,'CS101','2021-07-01','B','Completed'),
(3,'CS201','2022-01-05','A','Completed'),
(4,'EC101','2022-07-01','B+','Completed'),
(5,'IT101','2021-07-01','A','Completed'),
(6,'CS201','2021-01-05','A','Completed'),
(1,'CS302','2023-07-01',NULL,'Active'),
(2,'IT201','2022-01-05',NULL,'Dropped');
```

### Table-5 : COURSE_ASSIGNMENT

```sql
INSERT INTO COURSE_ASSIGNMENT (CourseID,FacultyID,Semester,Year,ClassRoom)
VALUES
('CS101',103,1,2024,'A-301'),
('CS201',101,3,2024,'B-205'),
('CS301',101,5,2024,'A-401'),
('IT101',102,1,2024,'C-102'),
('IT201',105,3,2024,'C-205'),
('EC101',104,1,2024,'D-101'),
('EC201',104,3,2024,'D-203'),
('ME101',106,1,2024,'E-101'),
('CS202',107,4,2024,'A-305'),
('CS302',101,6,2024,'B-401');
```
