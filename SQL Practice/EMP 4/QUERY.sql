/* employees whose salary is less than the salary of his
manager but more than the salary of any other manager. */
SELECT 
    *
FROM
    employees AS e,
    employees AS ee
WHERE
    e.manager_id = ee.emp_id
        AND e.salary < ee.salary
        AND e.salary > ANY (SELECT 
            salary
        FROM
            employees
        WHERE
            emp_id IN (SELECT 
                    manager_id
                FROM
                    employees));

/*employees of grade 3 and 4 working in the department of
FINANCE or AUDIT and whose salary is more than the salary of ADELYN and experience is more than
FRANK.*/

SELECT 
    *
FROM
    employees e
WHERE
    e.dep_id IN (SELECT 
            d.dep_id
        FROM
            department d
        WHERE
            d.dep_name IN ('FINANCE' , 'AUDIT'))
        AND e.salary > (SELECT 
            salary
        FROM
            employees
        WHERE
            emp_name = 'ADELYN')
        AND e.hiredate < (SELECT 
            hiredate
        FROM
            employees
        WHERE
            emp_name = 'FRANK')
        AND e.emp_id IN (SELECT 
            e.emp_id
        FROM
            employees e,
            salary_grade s
        WHERE
            e.salary BETWEEN s.min_sal AND s.max_sal
                AND s.grade IN (3 , 4))
ORDER BY e.hiredate DESC;

/*highest paid employees of PERTH who joined before the
most recently hired employee of grade 2.*/

SELECT 
    *
FROM
    employees
WHERE
    salary = (SELECT 
            MAX(salary)
        FROM
            employees e,
            department d
        WHERE
            e.dep_id = d.dep_id
                AND d.dep_location = 'PERTH'
                AND hiredate < (SELECT 
                    MAX(hiredate)
                FROM
                    employees e,
                    salary_grade s
                WHERE
                    e.salary BETWEEN s.min_sal AND s.max_sal
                        AND s.grade = 2));
