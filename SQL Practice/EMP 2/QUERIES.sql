-- List the project no. and average salary of the employees whose job is of Analyst and is working as developer or researcher on that project.
SELECT p.projectno as `P No`, AVG(e.salary) as `Avg. Salary`
FROM employee as e, project_participation as p, role as r
WHERE e.empno = p.empno and e.job = "Analyst" and r.description in ("Researcher","Developer")
GROUP BY p.projectno;

-- Manager Details with the no of dependents
SELECT e1.empno, e1.name, count(*) as `No of dependents`
FROM employee as e1, employee as e2  
WHERE e1.empno = e2.boss
group by e1.empno;

-- No of employees under each role
SELECT r.description as`Role`, COUNT(*) as `Emp for each role`
FROM role as r, project_participation as p 
WHERE r.role_id = p.role_id
group by p.role_id;
