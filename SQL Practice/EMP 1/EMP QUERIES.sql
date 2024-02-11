/*show tables;
desc controls;
desc department;
desc employee;
desc manages;
desc project;
desc works_for;
desc works_on;*/
SELECT e.SSN, e.NAME FROM employee as e, works_on as w
    WHERE e.SSN = w.SSN
    group by w.SSN
    HAVING sum(Hours) > 40;

SELECT d.DNO, count(SSN) FROM department as d, works_for as w 
	WHERE d.DNO = w.DNO
    GROUP BY(d.DNO);
