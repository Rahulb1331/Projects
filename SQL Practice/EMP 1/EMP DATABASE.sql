CREATE TABLE if not exists Department 
	(DNO int PRIMARY KEY,
     `Name` varchar(50),
     Location varchar(70));
CREATE TABLE if not exists EMPLOYEE
	(SSN int PRIMARY KEY,
     `NAME` varchar(50),
     SALARY int(8),
     SEX char);
CREATE TABLE if not exists Project
	(PNO int PRIMARY KEY,
     `NAME` varchar(100),
     LOCATION varchar(100));
create table manages 
	(SSN int, 
     DNO int PRIMARY KEY, 
     Start_date date, 
     foreign key(SSN) references employee(SSN), 
     foreign key(DNO) references department(DNO));
create table works_for 
	(SSN int, 
     DNO int, 
     primary key(SSN,DNO), 
     foreign key(SSN) references employee(SSN), 
     foreign key(DNO) references department(DNO));
create table controls 
	(PNO int PRIMARY KEY, 
     DNO int, 
     foreign key(DNO) references department(DNO));
create table works_on 
	(SSN int, 
     PNO int, 
     Hours int, primary key(SSN,PNO));