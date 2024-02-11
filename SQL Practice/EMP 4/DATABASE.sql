
create table if not exists employees(emp_id int, emp_name varchar (20), job varchar (10), manager_id int, hiredate
date, salary int, commission int, dep_id int);
create table if not exists department (dep_id int, dep_name varchar (10), dep_location varchar (10));
create table if not exists salary_grade (grade int, min_sal int, max_sal int);

insert into employees values (68319, 'David', 'President', NULL, '1991-11-18', 6000, 0, 1001);
insert into employees values (66928, 'Wang', 'Manager', 68319, '1991-05-01', 2750, 0, 3001);
insert into employees values (67832, 'Clarek', 'Manager', 68319, '1991-06-09', 2550, 0, 1001);
insert into employees values (65646, 'Jones', 'Manager', 68319, '1991-04-02', 2950, 0, 2001);
insert into employees values (67858, 'Scott', 'Analyst', 65646, '1997-04-19', 3100, 0, 2001);
insert into employees values (69062, 'Frank', 'Analyst', 65646, '1991-12-03', 3100, 0, 2001);
insert into employees values (63679, 'Sam', 'Clerk', 69062, '1990-12-18', 900, 0, 2001);
insert into employees values (64989, 'Adelyn', 'Salesman', 66928, '1991-02-20', 1700, 400, 3001);
insert into employees values (65271, 'Wade', 'Salesman', 66928, '1991-02-22', 1400, 600, 3001);
insert into employees values (66564, 'Gilly', 'Salesman', 66928, '1991-09-28', 1300, 1500, 3001);
insert into employees values (68454, 'Tucker', 'Salesman', 66928, '1991-09-08', 1600, 0, 3001);
insert into employees values (68736, 'Jon', 'Clerk', 67858, '1997-05-23', 1200, 0, 2001);
insert into employees values (69000, 'Ross', 'Clerk', 66928, '1991-12-03', 1100, 0, 3001);
insert into employees values (69324, 'Matthew', 'Clerk', 67832, '1992-01-23', 1400, 0, 1001);

insert into department values (1001, 'Finance', 'Sydney');
insert into department values (2001, 'Audit', 'Melbourne');
insert into department values (3001, 'Marketing', 'Perth');
insert into department values (4001, 'Production', 'Brisbane');

insert into salary_grade values (1, 800, 1300);
insert into salary_grade values (2, 1300, 1500);
insert into salary_grade values (3, 1500, 2100);
insert into salary_grade values (4, 2100, 3100);
insert into salary_grade values (5, 3200, 5700);
