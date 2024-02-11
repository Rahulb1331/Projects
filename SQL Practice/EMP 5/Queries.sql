/* For each department, display its department number, department name, total number of employees working
in that department, sum of salaries of all the employees working in that department, number of employees
working in that department as a ‘CLERK’, and ‘YES’ or ‘NO’ depending on whether the ‘PRESIDENT’ works in that
department or not. */
SELECT 
    D.deptno,
    D.name,
    SUM(IF(E.deptno = D.deptno, 1, 0)) total_employees,
    SUM(IF(E.deptno = D.deptno, E.salary, 0)) total_salary,
    SUM(IF((E.deptno = D.deptno AND E.job = 'CLERK'),
        1,
        0)) clerk,
    IF(SUM(IF((E.deptno = D.deptno
                AND E.job = 'PRESIDENT'),
            1,
            0)) > 0,
        'YES',
        'NO') president
FROM
    EMPLOYEE E
        JOIN
    DEPARTMENT D
GROUP BY D.deptno;

/* For every employee who has a boss and works in one or more projects, display his/her employee number,
employee name, name of boss, years of experience till date, YES if he/she is more experienced than his/her
boss else NO, location of work, project description (of only first project if multiple), his average salary. */

SELECT 
    E1.empno,
    E1.name,
    E2.name boss,
    FLOOR(DATEDIFF(CURDATE(), E1.hiredate) / 365) experience,
    IF(DATEDIFF(E2.hiredate, E1.hiredate) > 0,
        'NO',
        'YES') more_exp,
    D.location,
    P.description,
    E1.salary / P1.C1
FROM
    EMPLOYEE E1
        JOIN
    EMPLOYEE E2
        JOIN
    DEPARTMENT D
        JOIN
    (SELECT 
        P3.empno, P4.projectno, P3.C1
    FROM
        (SELECT 
        P2.empno, MIN(P2.start_date) A1, COUNT(*) C1
    FROM
        PROJECT_PARTICIPATION P2
    GROUP BY P2.empno) P3
    JOIN PROJECT_PARTICIPATION P4
    WHERE
        P3.A1 = P4.start_date
            AND P3.empno = P4.empno) P1
        JOIN
    PROJECT P
WHERE
    E1.boss = E2.empno
        AND E1.deptno = D.deptno
        AND E1.empno = P1.empno
        AND P1.projectno = P.projectno
ORDER BY E1.name;


/* For each employee who has worked on all the completed projects: Display employee number, employee name,
project number of the projects on which the employee has worked or is working on, role description of the
employee in the project, and the number of years from their hiring date after which the employee started
working on the project. */

SELECT 
    A1.empno,
    E1.name,
    A1.projectno,
    R.description,
    FLOOR(DATEDIFF(A1.start_date, E1.hiredate) / 365) wait_for_project
FROM
    (SELECT 
        *
    FROM
        PROJECT_PARTICIPATION PP1
    WHERE
        NOT EXISTS( SELECT 
                *
            FROM
                (SELECT 
                projectno
            FROM
                PROJECT
            WHERE
                IFNULL(end_date, 0) != 0) P1
            WHERE
                NOT EXISTS( SELECT 
                        *
                    FROM
                        PROJECT_PARTICIPATION PP2
                    WHERE
                        PP2.empno = PP1.empno
                            AND PP2.projectno = P1.projectno))) A1
        JOIN
    ROLE R
        JOIN
    EMPLOYEE E1
WHERE
    A1.role_id = R.role_id
        AND A1.empno = E1.empno
ORDER BY A1.projectno;