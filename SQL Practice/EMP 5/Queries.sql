/* For each department, display its department number, department name, total number of employees working
in that department, sum of salaries of all the employees working in that department, number of employees
working in that department as a ‘CLERK’, and ‘YES’ or ‘NO’ depending on whether the ‘PRESIDENT’ works in that
department or not. */
select D.deptno,D.name,sum(if(E.deptno=D.deptno,1,0)) total_employees, sum(if(E.deptno=D.deptno,E.salary,0))
total_salary,sum(if((E.deptno=D.deptno and E.job = 'CLERK'),1,0)) clerk, if(sum(if((E.deptno=D.deptno and E.job =
'PRESIDENT'),1,0))>0,'YES','NO') president from EMPLOYEE E join DEPARTMENT D group by D.deptno;

/* For every employee who has a boss and works in one or more projects, display his/her employee number,
employee name, name of boss, years of experience till date, YES if he/she is more experienced than his/her
boss else NO, location of work, project description (of only first project if multiple), his average salary. */

select E1.empno,E1.name,E2.name boss,floor(DATEDIFF(CURDATE(),E1.hiredate)/365)
experience,if(DATEDIFF(E2.hiredate,E1.hiredate)>0,'NO','YES') more_exp, D.location,P.description,E1.salary/P1.C1 from
EMPLOYEE E1 join EMPLOYEE E2 join DEPARTMENT D join (select P3.empno,P4.projectno,P3.C1 from (select
P2.empno,min(P2.start_date) A1,count(*) C1 from PROJECT_PARTICIPATION P2 group by P2.empno) P3 join
PROJECT_PARTICIPATION P4 where P3.A1 = P4.start_date and P3.empno = P4.empno) P1 JOIN PROJECT P where
E1.boss = E2.empno and E1.deptno = D.deptno and E1.empno = P1.empno and P1.projectno = P.projectno order by
E1.name;


/* For each employee who has worked on all the completed projects: Display employee number, employee name,
project number of the projects on which the employee has worked or is working on, role description of the
employee in the project, and the number of years from their hiring date after which the employee started
working on the project. */

select A1.empno,E1.name,A1.projectno,R.description,floor(DATEDIFF(A1.start_date,E1.hiredate)/365) wait_for_project
from (select * from PROJECT_PARTICIPATION PP1 where not exists (select * from (select projectno from PROJECT where
IFNULL(end_date,0)!=0) P1 where not exists (select * from PROJECT_PARTICIPATION PP2 where PP2.empno = PP1.empno
and PP2.projectno = P1.projectno))) A1 join ROLE R join EMPLOYEE E1 where A1.role_id = R.role_id and A1.empno =
E1.empno order by A1.projectno;