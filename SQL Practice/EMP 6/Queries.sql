/* Everytime an employee FINISHES his part on a project, he is awarded the
Commission alloted to him. For every employee, print the employee number,
department name he works in and the total commission he has got working on all
his projects so far, in increasing order of commission. */

SELECT 
    T2.EMPNO, T2.TOTALCOMMISSION, D.NAME
FROM
    (SELECT 
        E.EMPNO,
            IFNULL(T1.COUNT1, 0) * E.COMM TOTALCOMMISSION,
            E.DEPTNO
    FROM
        EMPLOYEE E
    LEFT JOIN (SELECT 
        PP.EMPNO, SUM(IF(IFNULL(PP.END_DATE, 0) > 0, 1, 0)) COUNT1
    FROM
        PROJECT_PARTICIPATION PP
    GROUP BY PP.EMPNO) T1 ON E.EMPNO = T1.EMPNO) T2
        JOIN
    DEPARTMENT D ON D.DEPTNO = T2.DEPTNO
ORDER BY T2.TOTALCOMMISSION;

/* For EVERY employee, print the employee name, employee number the
location of his office and the TOTAL time spent by him working on his projects, if
this total time he spent working on all his projects is less than 1 year, in
increasing order of total time. */

SELECT 
    T2.EMPNO, T2.NAME, T2.TIME, D.LOCATION
FROM
    DEPARTMENT D
        JOIN
    (SELECT 
        E.EMPNO, E.NAME, IFNULL(T1.TOTALTIME, 0) TIME, E.DEPTNO
    FROM
        EMPLOYEE E
    LEFT JOIN (SELECT 
        PP.EMPNO,
            SUM(DATEDIFF(IFNULL(PP.END_DATE, CURDATE()), PP.START_DATE)) TOTALTIME
    FROM
        PROJECT_PARTICIPATION PP
    GROUP BY PP.EMPNO) T1 ON E.EMPNO = T1.EMPNO
    WHERE
        IFNULL(T1.TOTALTIME, 0) < 365) T2 ON D.DEPTNO = T2.DEPTNO
ORDER BY T2.TIME;

/* For every office location, print the total time spent by all the employees
working in that office on completed projects. */

SELECT 
    D.LOCATION, SUM(IFNULL(T3.TIMEDIFF, 0)) TOTALTIME
FROM
    DEPARTMENT D
        LEFT JOIN
    (SELECT 
        E.EMPNO, T2.TIMEDIFF, E.DEPTNO
    FROM
        EMPLOYEE E
    JOIN (SELECT 
        PP.EMPNO,
            SUM(DATEDIFF(IFNULL(PP.END_DATE, CURDATE()), PP.START_DATE)) TIMEDIFF
    FROM
        PROJECT_PARTICIPATION PP
    JOIN (SELECT 
        P.PROJECTNO
    FROM
        PROJECT P
    WHERE
        P.END_DATE IS NOT NULL) T1 ON PP.PROJECTNO = T1.PROJECTNO
    GROUP BY PP.EMPNO) T2 ON E.EMPNO = T2.EMPNO) T3 ON D.DEPTNO = T3.DEPTNO
GROUP BY D.DEPTNO;

/*  */

CREATE VIEW CORRECT_PROJECT_PARTICIPATION AS
    SELECT 
        empno,
        pp.projectno,
        CASE
            WHEN DATEDIFF(pp.start_date, p.start_date) < 0 THEN p.start_date
            WHEN pp.start_date IS NULL THEN p.start_date
            ELSE pp.start_date
        END AS c_start_date,
        CASE
            WHEN DATEDIFF(pp.end_date, p.end_date) >= 0 THEN p.end_date
            WHEN
                p.end_date IS NOT NULL
                    AND pp.end_date IS NULL
            THEN
                p.end_date
            ELSE pp.end_date
        END AS c_end_date
    FROM
        (SELECT 
            empno,
                projectno,
                IF(DATEDIFF(end_date, start_date) < 0, end_date, start_date) AS start_date,
                IF(DATEDIFF(end_date, start_date) < 0, start_date, end_date) AS end_date
        FROM
            PROJECT_PARTICIPATION) AS pp
            JOIN
        PROJECT AS p ON pp.projectno = p.projectno
    WHERE
        p.end_date IS NULL
            OR pp.start_date < p.end_date;


INSERT INTO PROJECT_PARTICIPATION VALUES (1003, 7902, '2007-02-20', '2007-01-31', 101);
INSERT INTO PROJECT_PARTICIPATION VALUES (1003, 7782, '2007-02-24', '2018-07-31', 101);
INSERT INTO PROJECT_PARTICIPATION VALUES (1003, 7788, '2008-07-31', '2007-02-24', 101);

SELECT 
    *
FROM
    corrected_pp
WHERE
    projectno = 1003;


