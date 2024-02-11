/* Update the customer street information in a new table called
CUSTOMER_COPY to 'NH17B' for the customers who have made
payments of more than 10000 for ALL of their loans. */

UPDATE CUSTOMER_COPY SET STREET='NH17B' WHERE NAME IN (SELECT
DISTINCT C.NAME FROM CUSTOMER C JOIN (SELECT SUM(P.AMOUNT) AS
SUM,B.CUST_ID AS C_ID FROM BORROWER B JOIN PAYMENT P ON P.L_NO =
B.LOAN_NO GROUP BY B.CUST_ID HAVING SUM >= 10000) R ON R.C_ID =
C.C_ID);
SELECT * FROM CUSTOMER_COPY;


/* Find the (payment number, loan number, amount) groups
corresponding to the payments made by those customers living in a
city offering “mobilebanking" OR "netbanking". */

select P_NO, L_NO, AMOUNT from PAYMENT left join (select distinct
LOAN_NO from BORROWER left join (select C_ID from CUSTOMER NATURAL
JOIN (select distinct CITY from (select * from BRANCH left join
ASSETS on FACILITIES in ('mobilebanking','netbanking') and
BRANCH.BRN_NAME = ASSETS.BR_NAME) as T1 where BR_NAME is not NULL) as
t2) as t3 on C_ID=CUST_ID where C_ID is NOT NULL) as t4 on
LOAN_NO=L_NO where LOAN_NO is not NULL ;


/* Print out name, loan number, and remaining amount for all house
loans taken by females for which atleast one payment has been made. */

SELECT T3.NAME, P.L_NO, (T3.AMOUNT-P.AMOUNT) AS REMAINING_AMOUNT FROM
(SELECT L_NO, SUM(AMOUNT) AS AMOUNT FROM PAYMENT GROUP BY L_NO) AS P
INNER JOIN (SELECT L.LN_NO, L.AMOUNT, T2.NAME FROM LOAN L INNER JOIN
(SELECT T1.C_ID, B.LOAN_NO, T1.NAME, T1.CITY FROM BORROWER B INNER
JOIN (select C_ID, NAME, CITY from CUSTOMER WHERE GENDER = 'F') AS T1
ON T1.C_ID = B.CUST_ID) as T2 ON L.LN_NO = T2.LOAN_NO WHERE L.LN_NO
LIKE "hou%") AS T3 ON T3.LN_NO = P.L_NO;
