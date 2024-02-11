SELECT DISTINCT
    e.name
FROM
    PROJECT_PARTICIPATION AS PP1,
    EMPLOYEE e
WHERE
    e.empno = PP1.empno
        AND NOT EXISTS( SELECT 
            *
        FROM
            PROJECT AS P
        WHERE
            NOT EXISTS( SELECT 
                    *
                FROM
                    PROJECT_PARTICIPATION AS PP2
                WHERE
                    PP2.projectno = P.projectno
                        AND PP1.empno = PP2.empno));

SELECT 
    E.empno, E.name, E.deptno, E.salary, COUNT(P.projectno)
FROM
    EMPLOYEE AS E,
    PROJECT_PARTICIPATION AS P
WHERE
    (E.deptno , E.salary) IN (SELECT 
            D.deptno, MAX(salary)
        FROM
            EMPLOYEE AS EE,
            DEPARTMENT AS D
        WHERE
            EE.deptno = D.deptno
        GROUP BY D.deptno)
        AND E.empno = P.empno
GROUP BY (E.empno);

SELECT 
    e1.empno, e1.name, e2.name AS Boss_name
FROM
    EMPLOYEE e1,
    EMPLOYEE e2
WHERE
    e2.empno = e1.boss
        AND e1.salary = (SELECT 
            MAX(e.salary)
        FROM
            EMPLOYEE e,
            DEPARTMENT d
        WHERE
            e.deptno = d.deptno AND d.name = 'SALES'
                AND e.empno IN (SELECT 
                    e.empno
                FROM
                    EMPLOYEE e,
                    DEPARTMENT d
                WHERE
                    e.deptno = d.deptno AND d.name = 'SALES'
                        AND e.salary < (SELECT 
                            MAX(e.salary)
                        FROM
                            EMPLOYEE e,
                            DEPARTMENT d
                        WHERE
                            e.deptno = d.deptno AND d.name = 'SALES'
                                AND e.empno IN (SELECT 
                                    e.empno
                                FROM
                                    EMPLOYEE e,
                                    DEPARTMENT d
                                WHERE
                                    e.deptno = d.deptno AND d.name = 'SALES'
                                        AND e.salary < (SELECT 
                                            MAX(e.salary)
                                        FROM
                                            EMPLOYEE e,
                                            DEPARTMENT d
                                        WHERE
                                            e.deptno = d.deptno AND d.name = 'SALES')))));

-- Max salary in the Sales department
SELECT 
    MAX(e.salary)
FROM
    EMPLOYEE e,
    DEPARTMENT d
WHERE
    e.deptno = d.deptno AND d.name = 'SALES';

-- list of empno of employee whose salary is less than the highest salary (i.e 2850).
SELECT 
    e.empno
FROM
    EMPLOYEE e,
    DEPARTMENT d
WHERE
    e.deptno = d.deptno AND d.name = 'SALES'
        AND e.salary < (SELECT 
            MAX(e.salary)
        FROM
            EMPLOYEE e,
            DEPARTMENT d
        WHERE
            e.deptno = d.deptno AND d.name = 'SALES');

/* max salary from the previously subquery */
SELECT 
    MAX(e.salary)
FROM
    EMPLOYEE e,
    DEPARTMENT d
WHERE
    e.deptno = d.deptno AND d.name = 'SALES'
        AND e.empno IN (SELECT 
            e.empno
        FROM
            EMPLOYEE e,
            DEPARTMENT d
        WHERE
            e.deptno = d.deptno AND d.name = 'SALES'
                AND e.salary < (SELECT 
                    MAX(e.salary)
                FROM
                    EMPLOYEE e,
                    DEPARTMENT d
                WHERE
                    e.deptno = d.deptno AND d.name = 'SALES'));

-- List of people earning less than second highest salary
SELECT 
    e.empno
FROM
    EMPLOYEE e,
    DEPARTMENT d
WHERE
    e.deptno = d.deptno AND d.name = 'SALES'
        AND e.salary < (SELECT 
            MAX(e.salary)
        FROM
            EMPLOYEE e,
            DEPARTMENT d
        WHERE
            e.deptno = d.deptno AND d.name = 'SALES'
                AND e.empno IN (SELECT 
                    e.empno
                FROM
                    EMPLOYEE e,
                    DEPARTMENT d
                WHERE
                    e.deptno = d.deptno AND d.name = 'SALES'
                        AND e.salary < (SELECT 
                            MAX(e.salary)
                        FROM
                            EMPLOYEE e,
                            DEPARTMENT d
                        WHERE
                            e.deptno = d.deptno AND d.name = 'SALES')));

-- 3rd largest salary -- 
SELECT 
    MAX(e.salary)
FROM
    EMPLOYEE e,
    DEPARTMENT d
WHERE
    e.deptno = d.deptno AND d.name = 'SALES'
        AND e.empno IN (SELECT 
            e.empno
        FROM
            EMPLOYEE e,
            DEPARTMENT d
        WHERE
            e.deptno = d.deptno AND d.name = 'SALES'
                AND e.salary < (SELECT 
                    MAX(e.salary)
                FROM
                    EMPLOYEE e,
                    DEPARTMENT d
                WHERE
                    e.deptno = d.deptno AND d.name = 'SALES'
                        AND e.empno IN (SELECT 
                            e.empno
                        FROM
                            EMPLOYEE e,
                            DEPARTMENT d
                        WHERE
                            e.deptno = d.deptno AND d.name = 'SALES'
                                AND e.salary < (SELECT 
                                    MAX(e.salary)
                                FROM
                                    EMPLOYEE e,
                                    DEPARTMENT d
                                WHERE
                                    e.deptno = d.deptno AND d.name = 'SALES'))));

SELECT 
    e.empno, e.name, e.salary, d.name
FROM
    EMPLOYEE e,
    DEPARTMENT d
WHERE
    e.deptno = d.deptno AND d.name = 'SALES'
ORDER BY e.salary DESC;

/* List the department name and no. of its employee eligible for promotion. An employee is
eligible for promotion if he/she meets the following criteria: 10 Marks
a. Grade =1 and commission>=100 (lowest)
b. Grade =2 and commission>=200
c. Grade =3 and commission>=300
d. Grade =4 and commission>=400
e. Grade =5 and commission>=500 (highest) */
SELECT 
    d.name, COUNT(d.name) AS no_of_eligible_employees
FROM
    EMPLOYEE e,
    DEPARTMENT d
WHERE
    d.deptno = e.deptno
        AND e.name IN (SELECT 
            T.name
        FROM
            (SELECT 
                e.name AS name, e.comm AS comm, sg.grade AS grade
            FROM
                EMPLOYEE e, SALARYGRADE sg
            WHERE
                e.salary BETWEEN sg.losal AND sg.hisal) AS T
        WHERE
            T.grade = 1 AND T.comm >= 100
                OR T.grade = 2 AND T.comm >= 200
                OR T.grade = 3 AND T.comm >= 300
                OR T.grade = 4 AND T.comm >= 400
                OR T.grade = 5 AND T.comm >= 500)
GROUP BY d.name;

/* employees whose salary is more
than 3000 rupees and working as project manager or developer on any project. At the same point, you
should display the department number and its respective employees’ number if and only if that
department has more than four employees. */
SELECT 
    D.deptno, COUNT(DISTINCT (E.empno))
FROM
    EMPLOYEE AS E,
    DEPARTMENT AS D,
    PROJECT_PARTICIPATION AS P,
    ROLE AS R
WHERE
    E.empno = P.empno
        AND E.deptno = D.deptno
        AND R.role_id = P.role_id
        AND E.salary > 3000
        AND R.description IN ('Project manager' , 'developer')
        AND D.deptno IN (SELECT 
            deptno
        FROM
            EMPLOYEE
        GROUP BY deptno
        HAVING COUNT(*) > 4)
GROUP BY D.deptno;

/* project with least no. of employee working on it. Print the project manager details
(empno, empname, department name, project name) of that project.*/
SELECT 
    e.empno,
    e.name,
    d.name AS dept_name,
    p.description AS project_name
FROM
    PROJECT_PARTICIPATION pp,
    DEPARTMENT d,
    PROJECT p,
    EMPLOYEE e
WHERE
    e.empno = pp.empno
        AND e.deptno = d.deptno
        AND pp.projectno = p.projectno
        AND e.job = 'MANAGER'
        AND pp.projectno IN (SELECT 
            T.projectno
        FROM
            (SELECT 
                p.projectno, COUNT(pp.empno) AS emp_count
            FROM
                PROJECT p, PROJECT_PARTICIPATION pp
            WHERE
                pp.projectno = p.projectno
            GROUP BY p.projectno) AS T
        WHERE
            T.emp_count = (SELECT 
                    MIN(T1.emp_count)
                FROM
                    (SELECT 
                        p.projectno, COUNT(pp.empno) AS emp_count
                    FROM
                        PROJECT p, PROJECT_PARTICIPATION pp
                    WHERE
                        pp.projectno = p.projectno
                    GROUP BY p.projectno) AS T1));