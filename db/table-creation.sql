DROP DATABASE School_System;
CREATE DATABASE School_System;
USE School_System; 


CREATE TABLE Schools (
	id INT PRIMARY KEY AUTO_INCREMENT, 
	name VARCHAR(200),
	address VARCHAR(200),  
	mission VARCHAR(500), 
	vision VARCHAR(500), 
	language VARCHAR(20), 
	general_info VARCHAR(2000), 
	fees INT, 
	type VARCHAR(20), 
	CHECK (type = 'national' OR type = 'National' OR type = 'international' OR type = 'International'),  
	email VARCHAR(50) UNIQUE 
);  


CREATE TABLE Phone_School (
	PRIMARY KEY (school_id, phone),
	phone VARCHAR(100) UNIQUE, 
	school_id INT,
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE 
	
); 

CREATE TABLE Level_School
(
	PRIMARY KEY (school_id, level),
	level VARCHAR(15),
	CHECK (level = 'elementary' or level = 'middle' or level = 'high'),
	school_id INT,
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE
);


CREATE TABLE Supplies (
	PRIMARY KEY (name, school_id, grade),
	name VARCHAR(100), 
	school_id INT, 
	grade INT,
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE
); 


CREATE TABLE Clubs (
	PRIMARY KEY (name, school_id), 
	name VARCHAR(100), 
	school_id INT,
	purpose VARCHAR(500) DEFAULT 'ERROR 404 PURPOSE NOT FOUND :"D',
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE
); 

CREATE TABLE Students (
	PRIMARY KEY (ssn), 
	ssn INT, 
	id INT DEFAULT NULL,
	username VARCHAR(100),
	password VARCHAR(20),
	school_id INT DEFAULT NULL,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL, 
	gender VARCHAR(10),
	birthdate DATE,
	age INT,
	grade INT,
	level VARCHAR(100), 
	CHECK (level = 'elementary' or level = 'middle' or level = 'high'),
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE SET NULL 
); 

CREATE TABLE Parents (
	PRIMARY KEY (id),
	id INT AUTO_INCREMENT, 
	username VARCHAR(100) UNIQUE, 
	password VARCHAR(20),
	first_name VARCHAR(100), 
	last_name VARCHAR(100), 
	email VARCHAR(100) UNIQUE,
	address VARCHAR(600), 
	home_phone VARCHAR(100)
); 

CREATE TABLE Mobile_Of_Parent (
	PRIMARY KEY (mobile, parent_id), 
	parent_id INT, 
	mobile VARCHAR(20), 
	FOREIGN KEY (parent_id) REFERENCES Parents(id) ON DELETE CASCADE
);  

CREATE TABLE Parent_Of_Student (
	PRIMARY KEY (parent_id, child_ssn), 
	parent_id INT, 
	child_ssn INT, 
	FOREIGN KEY (child_ssn) REFERENCES Students(ssn)ON DELETE CASCADE, 
	FOREIGN KEY (parent_id) REFERENCES Parents(id) ON DELETE CASCADE
); 

CREATE TABLE Club_Member_Student (
	PRIMARY KEY (student_ssn, school_id, club_name), 
	student_ssn INT, 
	school_id INT, 
	club_name VARCHAR(100), 
	FOREIGN KEY (club_name, school_id) REFERENCES Clubs(name, school_id) ON DELETE CASCADE, 
	FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE
);

CREATE TABLE Parent_Review_School (
	PRIMARY KEY (school_id, parent_id), 
	school_id INT, 
	parent_id INT, 
	review VARCHAR(200), 
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE, 
	FOREIGN KEY (parent_id) REFERENCES Parents(id) ON DELETE CASCADE 
); 
CREATE TABLE School_Apply_Student(
 	PRIMARY KEY (school_id, student_ssn), 
 	school_id INT,
 	student_ssn INT,
 	parent_id INT, 
 	status VARCHAR(100),
 	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE, 
 	FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE, 
 	FOREIGN KEY (parent_id) REFERENCES Parents(id) ON DELETE SET NULL 
); 


CREATE TABLE Employees (
	PRIMARY KEY(id), 
	id INT AUTO_INCREMENT, 
	school_id INT DEFAULT NULL, 
	first_name VARCHAR(100) NOT NULL, 
	middle_name VARCHAR(100), 
	last_name VARCHAR(100) NOT NULL, 
	username VARCHAR(100), 
	password VARCHAR(100), 
	email VARCHAR(100), 
	gender VARCHAR(10), 
	address VARCHAR(600), 
	birthdate DATE, 
	salary INT,  
	age INT,
	FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE SET NULL
); 

CREATE TABLE Administrators
	 (
		id int PRIMARY KEY, 
		FOREIGN KEY (id) REFERENCES Employees(id) ON DELETE CASCADE
	);

CREATE TABLE Teachers 
	(
		id int PRIMARY KEY,
		start_date DATE,
		exp_years INT,
		FOREIGN KEY (id) REFERENCES Employees(id) ON DELETE CASCADE
	);

CREATE TABLE Teachers_Supervising_Teachers
	(
		supervisor_id int,
		teacher_id int,
		PRIMARY KEY (supervisor_id, teacher_id),
		FOREIGN KEY (supervisor_id) REFERENCES Teachers(id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

CREATE TABLE Activities
	(	
		PRIMARY KEY (name, school_id),
		name VARCHAR(200),
		school_id INT,
		activity_datetime datetime,
		location varchar(200),
		equipment varchar(500),
		description varchar(1000),
		type varchar(100),
		admin_id int,
		teacher_id int,
		FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE,
		FOREIGN KEY (admin_id) REFERENCES Administrators(id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

CREATE TABLE Activities_JoinedBy_Students
	(	
		PRIMARY KEY (student_ssn, activity_name, school_id),
		student_ssn int,
		activity_name VARCHAR(200),
		school_id INT, 
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (activity_name, school_id) REFERENCES Activities(name, school_id) ON DELETE CASCADE
	);

CREATE TABLE Announcements
	(	
		PRIMARY KEY (title, announcement_date, school_id),
		title varchar(200),
		announcement_date date,
		school_id INT,
		type varchar(200),
		description varchar(1000),
		admin_id int,	 
		FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE,
		FOREIGN KEY (admin_id) REFERENCES Administrators(id) ON DELETE SET NULL

	);

CREATE TABLE Courses
	(
		PRIMARY KEY (code),
		code int,
		name varchar(100),
		description varchar(600),
		grade int, 
		level VARCHAR(50), 
		CHECK (level = 'elementary' or level = 'middle' or level = 'high')	
	);

CREATE TABLE Courses_Prerequisite_Courses
	(
		PRIMARY KEY (pre_code, code),
		pre_code int,
		code int,
		FOREIGN KEY (pre_code) REFERENCES Courses(code) ON DELETE CASCADE,
		FOREIGN KEY (code) REFERENCES Courses(code) ON DELETE CASCADE
	);

-- CREATE TABLE Courses_TaughtIn_Schools
-- 	(
-- 		PRIMARY KEY (course_code, school_id),
-- 		course_code int,
-- 		school_id int,
-- 		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE,
-- 		FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE
--	);

CREATE TABLE Parents_Rate_Teachers
	(
		PRIMARY KEY (parent_id, teacher_id),
		parent_id INT,
		teacher_id INT,
		rating INT,
		FOREIGN KEY (parent_id) REFERENCES Parents(id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

CREATE TABLE Questions
	(
		PRIMARY KEY (q_id, course_code),
		q_id int,
		course_code int,
		content varchar(1000) NOT NULL,
		student_ssn int,	
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE SET NULL,
		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE
	);

CREATE TABLE Answers
	(
		PRIMARY KEY (answer_sub_id, q_id, course_code),
		answer_sub_id int,
		q_id int,
		course_code int,
		answer varchar(2000) NOT NULL,
		teacher_id int,
		FOREIGN KEY (q_id, course_code) REFERENCES Questions(q_id, course_code) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE SET NULL
	);

CREATE TABLE Courses_TaughtTo_Students_By_Teachers
	(
		PRIMARY KEY (course_code, student_ssn),
		course_code int,
		student_ssn int,
		teacher_id int DEFAULT NULL,
		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE,
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

CREATE TABLE Assignments
	(
		PRIMARY KEY (assignment_number, course_code, school_id),
		assignment_number int,
		course_code int,
		school_id int,
		post_date date,
		due_date date,
		content varchar(2000) NOT NULL,
		teacher_id int  DEFAULT NULL,
		FOREIGN KEY (course_code) REFERENCES Courses(code) ON DELETE CASCADE,
		FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE SET NULL
	);

CREATE TABLE Solutions
	(
		PRIMARY KEY (student_ssn, assignment_number, course_code, school_id),
		student_ssn int,
		assignment_number int,
		course_code int,
		school_id int,
		solution varchar(2000),
        grade int default null,
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (assignment_number, course_code, school_id) REFERENCES Assignments(assignment_number, course_code, school_id) ON DELETE CASCADE
	);

-- call teacher_grade_solutions(6,1,1107,);
CREATE TABLE Teachers_Grade_Solutions
	(
		PRIMARY KEY (student_ssn, assignment_number, course_code, school_id),
		student_ssn int,
		assignment_number int,
		course_code int,
		school_id int,
		grade int,
		teacher_id int,
		FOREIGN KEY (student_ssn, assignment_number, course_code, school_id) REFERENCES Solutions (student_ssn, assignment_number, course_code, school_id) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE	
	);

CREATE TABLE Reports
	(
		PRIMARY KEY (report_date, student_ssn, teacher_id),
		report_date date,
		student_ssn int,
		teacher_id int,
		comment varchar(1000),
		FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
		FOREIGN KEY (teacher_id) REFERENCES Teachers(id) ON DELETE CASCADE
	);

-- CREATE TABLE Parents_View_Reports
-- 	(
-- 		parent_id INT,
-- 		report_date date,
-- 		student_ssn int,
-- 		teacher_id int,
-- 		PRIMARY KEY (parent_id, report_date, student_ssn, teacher_id),
-- 		FOREIGN KEY (parent_id) REFERENCES Parents(id) ON DELETE CASCADE,
-- 		FOREIGN KEY (report_date, student_ssn, teacher_id) REFERENCES Reports(report_date, student_ssn, teacher_id) ON DELETE CASCADE
-- 	);

CREATE TABLE Parents_Reply_Reports
	(
		parent_id INT,
		report_date date,
		student_ssn int,
		teacher_id int,
		content varchar(1000),
		PRIMARY KEY (parent_id, report_date, student_ssn, teacher_id),
		FOREIGN KEY (parent_id) REFERENCES Parents(id) ON DELETE CASCADE,
		FOREIGN KEY (report_date, student_ssn, teacher_id) REFERENCES Reports(report_date, student_ssn, teacher_id) ON DELETE CASCADE
	);
 DELIMITER  //

CREATE TRIGGER EmployeesAge BEFORE INSERT
	ON Employees
	FOR EACH ROW BEGIN
		SET New.age = YEAR(CURDATE()) - YEAR(New.birthdate);

END//

 CREATE TRIGGER StudentsAge BEFORE INSERT
	ON Students
	FOR EACH ROW BEGIN
		SET New.age = YEAR(CURDATE()) - YEAR(New.birthdate);
        SET New.grade = YEAR(CURDATE()) - YEAR(New.birthdate) - 5;
        IF(New.grade >= 1 AND NEW.grade <= 6)
		THEN SET New.level = 'elementary';
		ELSEIF (New.grade <= 9)
			THEN SET New.level = 'middle';
		ELSE
			SET New.level = 'high';
	END IF;
	IF(New.grade >= 1 AND NEW.grade <= 6)
		THEN SET New.level = 'elementary';
		ELSEIF (New.grade <= 9)
			THEN SET New.level = 'middle';
		ELSE
			SET New.level = 'high';
	END IF;

END//

-- CREATE TRIGGER StudentGrade BEFORE INSERT
-- 	ON Students
-- 	FOR EACH ROW
-- 		SET New.grade = YEAR(CURDATE()) - YEAR(New.birthdate) - 5;

CREATE TRIGGER TeachersExpYears BEFORE INSERT
	ON Teachers
	FOR EACH ROW BEGIN
	IF(New.start_date IS NOT NULL ) THEN
			SET New.exp_years = (YEAR(CURDATE()) - YEAR(New.start_date));
	END IF;
END //

CREATE TRIGGER TeachersExpYearsUpdate BEFORE UPDATE
	ON Teachers
	FOR EACH ROW BEGIN
	IF(New.start_date IS NOT NULL ) THEN
			SET New.exp_years = (YEAR(CURDATE()) - YEAR(New.start_date));
	END IF;
END //

-- CREATE TRIGGER StudentLevel BEFORE INSERT
-- 	ON Students
-- 	FOR EACH ROW BEGIN
-- 	IF(New.grade >= 1 AND NEW.grade <= 6)
-- 		THEN SET New.level = 'elementary';
-- 		ELSEIF (New.grade <= 9)
-- 			THEN SET New.level = 'middle';
-- 		ELSE
-- 			SET New.level = 'high';
-- 	END IF;
-- END //

DELIMITER ;

DELIMITER  //

CREATE TRIGGER EmployeesAge BEFORE INSERT
	ON Employees
	FOR EACH ROW BEGIN
		SET New.age = YEAR(CURDATE()) - YEAR(New.birthdate);

END//

CREATE TRIGGER StudentsAge BEFORE INSERT
	ON Students
	FOR EACH ROW BEGIN
		SET New.age = YEAR(CURDATE()) - YEAR(New.birthdate);

END//

CREATE TRIGGER StudentGrade BEFORE INSERT
	ON Students
	FOR EACH ROW
		SET New.grade = YEAR(CURDATE()) - YEAR(New.birthdate) - 5;

CREATE TRIGGER TeachersExpYears BEFORE INSERT
	ON Teachers
	FOR EACH ROW BEGIN
	IF(New.start_date IS NOT NULL ) THEN
			SET New.exp_years = (YEAR(CURDATE()) - YEAR(New.start_date));
	END IF;
END //

CREATE TRIGGER TeachersExpYearsUpdate BEFORE UPDATE
	ON Teachers
	FOR EACH ROW BEGIN
	IF(New.start_date IS NOT NULL ) THEN
			SET New.exp_years = (YEAR(CURDATE()) - YEAR(New.start_date));
	END IF;
END //

CREATE TRIGGER StudentLevel BEFORE INSERT
	ON Students
	FOR EACH ROW BEGIN
	IF(New.grade >= 1 AND NEW.grade <= 6)
		THEN SET New.level = 'elementary';
		ELSEIF (New.grade <= 9)
			THEN SET New.level = 'middle';
		ELSE
			SET New.level = 'high';
	END IF;
END //

DELIMITER ;



