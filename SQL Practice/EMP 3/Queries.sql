Select distinct e.name 
  From PROJECT_PARTICIPATION as PP1, EMPLOYEE e 
    Where e.empno=PP1.empno and NOT EXISTS 
      (Select * From PROJECT as P Where NOT EXISTS (Select * from PROJECT_PARTICIPATION
       as PP2 Where PP2.projectno=P.projectno and PP1.empno=PP2.empno));

Select E.empno,E.name,E.deptno,E.salary,count(P.projectno) 
  From EMPLOYEE as E,PROJECT_PARTICIPATION as P 
    Where (E.deptno,E.salary) IN(Select D.deptno,max(salary) From
      EMPLOYEE as EE,DEPARTMENT as D Where EE.deptno=D.deptno Group by D.deptno) and
      E.empno=P.empno Group by(E.empno);

select e1.empno,e1.name,e2.name as Boss_name from EMPLOYEE e1,EMPLOYEE e2 where
e2.empno=e1.boss
and e1.salary=( select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.empno in (select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.salary < (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.empno in (select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.salary < (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES') ) ) )) ;

-- Max salary in the Sales department
select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES';

-- list of empno of employee whose salary is less than the highest salary (i.e 2850).
select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and d.name='SALES' and e.salary
< (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and d.name='SALES') ;

/* max salary from the previously subquery */
select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and d.name='SALES'
and e.empno in (select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.salary < (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES') );

-- List of people earning less than second highest salary
select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and d.name='SALES'
and e.salary < (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.empno in (select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.salary < (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES') ) );

-- 3rd largest salary -- 
select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and d.name='SALES'
and e.empno in (select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.salary < (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.empno in (select e.empno from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES'
and e.salary < (select max(e.salary) from EMPLOYEE e,DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES') ) ) );

--
select e.empno,e.name,e.salary,d.name from EMPLOYEE e, DEPARTMENT d where e.deptno=d.deptno and
d.name='SALES' order by e.salary desc;

/* List the department name and no. of its employee eligible for promotion. An employee is
eligible for promotion if he/she meets the following criteria: 10 Marks
a. Grade =1 and commission>=100 (lowest)
b. Grade =2 and commission>=200
c. Grade =3 and commission>=300
d. Grade =4 and commission>=400
e. Grade =5 and commission>=500 (highest) */
select d.name , count(d.name) as no_of_eligible_employees from EMPLOYEE e,DEPARTMENT d where
d.deptno =e.deptno and e.name in (select T.name from (select e.name as name ,e.comm as comm,
sg.grade as grade from EMPLOYEE e, SALARYGRADE sg where e.salary between sg.losal and sg.hisal) as
T where T.grade =1 and T.comm>=100 or T.grade =2 and T.comm>=200 or T.grade =3 and T.comm>=300
or T.grade =4 and T.comm>=400 or T.grade =5 and T.comm>=500) group by d.name;

/* employees whose salary is more
than 3000 rupees and working as project manager or developer on any project. At the same point, you
should display the department number and its respective employees’ number if and only if that
department has more than four employees. */
Select D.deptno,count(distinct(E.empno)) From EMPLOYEE as E,DEPARTMENT as
D,PROJECT_PARTICIPATION as P,ROLE as R Where E.empno=P.empno and E.deptno=D.deptno and
R.role_id =P.role_id and E.salary > 3000 and R.description IN("Project manager","developer")and
D.deptno IN (Select deptno from EMPLOYEE group by deptno having count(*)>4)group by D.deptno;

/* project with least no. of employee working on it. Print the project manager details
(empno, empname, department name, project name) of that project.*/
select e.empno ,e.name,d.name as dept_name,p.description as project_name from
PROJECT_PARTICIPATION pp,DEPARTMENT d,PROJECT p, EMPLOYEE e where e.empno=pp.empno and
e.deptno=d.deptno and pp.projectno=p.projectno and e.job='MANAGER' and pp.projectno in (select
T.projectno from ( select p.projectno , count(pp.empno) as emp_count from PROJECT p ,
PROJECT_PARTICIPATION pp where pp.projectno=p.projectno group by p.projectno) as T where
T.emp_count= (select min(T1.emp_count) from (select p.projectno , count(pp.empno) as emp_count
from PROJECT p , PROJECT_PARTICIPATION pp where pp.projectno=p.projectno group by p.projectno)
as T1));
