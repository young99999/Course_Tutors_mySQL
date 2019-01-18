USE Master;
GO
DROP DATABASE IF EXISTS schooldb;
GO
CREATE DATABASE schooldb;
GO
USE schooldb;
PRINT 'Part A Completed'
GO

-- Part B Start
CREATE PROCEDURE usp_dropTables
AS
BEGIN
DROP TABLE IF EXISTS StudentContacts
DROP TABLE IF EXISTS Student_Courses
DROP TABLE IF EXISTS StudentInformation
DROP TABLE IF EXISTS CourseList
DROP TABLE IF EXISTS ContactType
DROP TABLE IF EXISTS Employees
DROP TABLE IF EXISTS EmpJobPosition
END
GO
--EXEC usp_dropTables;
PRINT 'Part B Completed'
GO

-- Part C Start
CREATE TABLE EmpJobPosition
(
	EmpJobPositionID int IDENTITY(1,1) NOT NULL,
	EmployeePosition char(50) NOT NULL,
	PRIMARY KEY (EmpJobPositionID)
);

--select * from EmpJobPosition
GO
CREATE TABLE Employees
(
	EmployeeID int IDENTITY(1000,1) NOT NULL,
	EmployeeName char(50) NOT NULL, 
	EmployeePositionID int NOT NULL, 
	EmployeePassword char(25) NULL,
	Access char(10) NULL,
	PRIMARY KEY (EmployeeID),
	FOREIGN KEY (EmployeePositionID) REFERENCES EmpJobPosition(EmpJobPositionID)
);
GO
CREATE TABLE ContactType
(
	ContactTypeID int IDENTITY(1,1) NOT NULL,
	ContactType char(25) NOT NULL,
	PRIMARY KEY (ContactTypeID)
);
GO
CREATE TABLE CourseList
(
	CourseID int IDENTITY(10,1) NOT NULL,
	CourseDescription char(255) NOT NULL, 
	CourseCost money NULL, 
	CourseDurationYears datetime NULL,
	Notes varchar(1000) NULL,
	PRIMARY KEY (CourseID)
);
GO

CREATE TABLE StudentInformation
(
	StudentID int  NOT NULL IDENTITY(100,1) ----1->100
	PRIMARY KEY NONCLUSTERED,
	Title char(50) NULL,
	FirstName char(50) NOT NULL, 
	LastName char(50) NOT NULL,
	Address1 char(50) NULL,
	Address2 char(50) NULL,
	City char(50) NULL,
	County char(50) NULL,
	Zip char(10) NULL,
	Country char(50) NULL,
	Telephone char(50) NULL,
	Email varchar(255) NULL,
	Enrolled char(50) NULL,
	AltTelephone char(50) NULL,
	ContactDetails varchar(100) NULL,	 
);
GO

CREATE TABLE Student_Courses
(
	StudentCourseID int IDENTITY(1,1) NOT NULL,
	StudentID int NOT NULL, 
	CourseID int NOT NULL, 
	CourseStartDate datetime NOT NULL,
	CourseComplete char(25) NULL,
	PRIMARY KEY (StudentCourseID),
	FOREIGN KEY (CourseID) REFERENCES CourseList(CourseID),
	FOREIGN KEY (StudentID) REFERENCES StudentInformation(StudentID)
);
GO

CREATE TABLE StudentContacts
(
	ContactID int IDENTITY(10000,1) NOT NULL, 
	StudentID int NOT NULL, 
	ContactTypeID int NOT NULL, 
	ContactDate datetime NOT NULL,
	EmployeeID int NOT NULL,
	ContactDetails varchar(100) NOT NULL,
	PRIMARY KEY (ContactID),
	FOREIGN KEY (ContactTypeID) REFERENCES ContactType(ContactTypeID),
	FOREIGN KEY (StudentID) REFERENCES StudentInformation(StudentID),
	FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO
PRINT 'Part C Completed'
GO

-- Part D Start
ALTER TABLE Student_Courses ADD UNIQUE (StudentID, CourseID)
GO
ALTER TABLE StudentInformation ADD CreatedDateTime datetime DEFAULT CURRENT_TIMESTAMP
GO
ALTER TABLE StudentInformation DROP COLUMN AltTelephone
GO
CREATE INDEX IX_LastName ON StudentInformation (LastName)
GO
--ALTER TABLE StudentInformation ADD INDEX IX_LastName (LastName)
PRINT 'Part D Completed'
GO

--Part E Start
CREATE TRIGGER trg_assignEmail 
ON StudentInformation
AFTER INSERT, UPDATE
AS 
BEGIN
UPDATE StudentInformation
SET Email = REPLACE(CONCAT(firstName, '.', LastName, '@disney.com'),' ', '')
WHERE StudentID IN (SELECT StudentID FROM INSERTED) and Email is null;
END
--INSERT INTO StudentInformation (FirstName,LastName,Email)
--Values('Porky','Pig','porky.pig@warnerbros.com')
--select * from StudentInformation
--INSERT INTO StudentInformation (FirstName,LastName)
--Values('Snow','White')
GO
PRINT 'Part E Completed'
GO



-- Part F Start
INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Mickey', 'Mouse');

INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Minnie', 'Mouse');

INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Donald', 'Duck');
SELECT * FROM StudentInformation;

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Advanced Math');

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Intermediate Math');

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Beginning Computer Science');

INSERT INTO CourseList
   (CourseDescription)
VALUES
   ('Advanced Computer Science');
select * from CourseList;

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (100, 10, '01/05/2018');

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (101, 11, '01/05/2018');

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (102, 11, '01/05/2018');
INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (100, 11, '01/05/2018');

INSERT INTO Student_Courses
   (StudentID,CourseID,CourseStartDate)
VALUES
   (102, 13, '01/05/2018');
select * from Student_Courses;

INSERT INTO EmpJobPosition
   (EmployeePosition)
VALUES
   ('Math Instructor');

INSERT INTO EmpJobPosition
   (EmployeePosition)
VALUES
   ('Computer Science');
select * from EmpJobPosition

INSERT INTO Employees
   (EmployeeName,EmployeePositionID)
VALUES
   ('Walt Disney', 1);

INSERT INTO Employees
   (EmployeeName,EmployeePositionID)
VALUES
   ('John Lasseter', 2);

INSERT INTO Employees
   (EmployeeName,EmployeePositionID)
VALUES
   ('Danny Hillis', 2);
select * from Employees;

INSERT INTO ContactType
   (ContactType)
VALUES
   ('Tutor');

INSERT INTO ContactType
   (ContactType)
VALUES
   ('Homework Support');

INSERT INTO ContactType
   (ContactType)
VALUES
   ('Conference');
SELECT * from ContactType;

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (100, 1, 1000, '11/15/2017', 'Micky and Walt Math Tutoring');

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (101, 2, 1001, '11/18/2017', 'Minnie and John Homework support');

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (100, 3, 1001, '11/18/2017', 'Micky and Walt Conference');

INSERT INTO StudentContacts
   (StudentID,ContactTypeID,EmployeeID,ContactDate,ContactDetails)
VALUES
   (102, 2, 1002, '11/20/2017', 'Donald and Danny Homework support');

SELECT * from StudentContacts;

-- Note for Part E, use these two inserts as examples to test the trigger
-- They will also be needed if you are using the examples for Part G
INSERT INTO StudentInformation
   (FirstName,LastName,Email)
VALUES
   ('Porky', 'Pig', 'porky.pig@warnerbros.com');
INSERT INTO StudentInformation
   (FirstName,LastName)
VALUES
   ('Snow', 'White');

--Remove comment when Part B and Part C are completed */
GO
PRINT 'Part F Completed'
GO

-- Part G Start
CREATE PROCEDURE usp_addQuickContacts 
@StudentEmail varchar(255),
@EmployeeName char(50),
@contactDetails varchar(100),
@contactType char(25)
AS
BEGIN
	IF not exists (SELECT * FROM ContactType WHERE ContactType=@contactType)
		BEGIN
			INSERT INTO ContactType(ContactType) VALUES (@contactType)
			INSERT INTO StudentContacts(StudentID, EmployeeID, ContactTypeID, ContactDetails, ContactDate)
			VALUES (
			(SELECT StudentID FROM StudentInformation WHERE Email=@StudentEmail),
			(SELECT EmployeeID FROM Employees WHERE EmployeeName=@EmployeeName),
			(SELECT ContactTypeID FROM ContactType WHERE ContactType=@contactType),
			@contactDetails,
			getdate()
			)
		END
	ELSE
		BEGIN
			INSERT INTO StudentContacts(StudentID, EmployeeID, ContactTypeID, ContactDetails, ContactDate)
			VALUES (
			(SELECT StudentID FROM StudentInformation WHERE Email=@StudentEmail),
			(SELECT EmployeeID FROM Employees WHERE EmployeeName=@EmployeeName),
			(SELECT ContactTypeID FROM ContactType WHERE ContactType=@contactType),
			@contactDetails,
			getdate()
			)
		END
END
--EXEC usp_addQuickContacts 'minnie.mouse@disney.com','John Lasseter','Minnie getting Homework Support from John','Homework Support' 
--EXEC usp_addQuickContacts 'porky.pig@warnerbros.com','John Lasseter','Porky studying with John for Test prep','Test Prep'
GO
PRINT 'Part G Completed'
GO

-- Part H Start
DROP PROCEDURE IF EXISTS usp_getCourseRosterByName
GO
CREATE PROCEDURE usp_getCourseRosterByName
@CourseDescription char(255)
AS
BEGIN
	SELECT distinct @CourseDescription AS Course, si.FirstName, si.LastName
	FROM Student_Courses AS sc
	INNER JOIN CourseList AS cl ON sc.CourseID=cl.CourseID 
	INNER JOIN StudentInformation AS si ON sc.StudentID=si.StudentID 	
END;
GO
EXEC usp_getCourseRosterByName 'Intermediate Math';
PRINT 'Part H Completed'
GO

-- Part I Start
CREATE VIEW vtutorContacts AS
SELECT EmployeeName, RTRIM(FirstName)+' '+RTRIM(LastName) StudentName, sc.ContactDetails
FROM Employees em
INNER JOIN StudentContacts sc ON em.EmployeeID = sc.EmployeeID
INNER JOIN ContactType ct ON ct.ContactTypeID = sc.ContactTypeID
INNER JOIN StudentInformation si ON si.StudentID = sc.StudentID;
GO
SELECT * FROM vtutorContacts
PRINT 'Part I Completed'
GO