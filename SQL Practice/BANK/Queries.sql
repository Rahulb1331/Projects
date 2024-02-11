/* Update the customer street information in a new table called
CUSTOMER_COPY to 'NH17B' for the customers who have made
payments of more than 10000 for ALL of their loans. */

UPDATE CUSTOMER_COPY 
SET 
    STREET = 'NH17B'
WHERE
    NAME IN (SELECT DISTINCT
            C.NAME
        FROM
            CUSTOMER C
                JOIN
            (SELECT 
                SUM(P.AMOUNT) AS SUM, B.CUST_ID AS C_ID
            FROM
                BORROWER B
            JOIN PAYMENT P ON P.L_NO = B.LOAN_NO
            GROUP BY B.CUST_ID
            HAVING SUM >= 10000) R ON R.C_ID = C.C_ID);
SELECT 
    *
FROM
    CUSTOMER_COPY;


/* Find the (payment number, loan number, amount) groups
corresponding to the payments made by those customers living in a
city offering “mobilebanking" OR "netbanking". */

SELECT 
    P_NO, L_NO, AMOUNT
FROM
    PAYMENT
        LEFT JOIN
    (SELECT DISTINCT
        LOAN_NO
    FROM
        BORROWER
    LEFT JOIN (SELECT 
        C_ID
    FROM
        CUSTOMER
    NATURAL JOIN (SELECT DISTINCT
        CITY
    FROM
        (SELECT 
        *
    FROM
        BRANCH
    LEFT JOIN ASSETS ON FACILITIES IN ('mobilebanking' , 'netbanking')
        AND BRANCH.BRN_NAME = ASSETS.BR_NAME) AS T1
    WHERE
        BR_NAME IS NOT NULL) AS t2) AS t3 ON C_ID = CUST_ID
    WHERE
        C_ID IS NOT NULL) AS t4 ON LOAN_NO = L_NO
WHERE
    LOAN_NO IS NOT NULL;


/* Print out name, loan number, and remaining amount for all house
loans taken by females for which atleast one payment has been made. */

SELECT 
    T3.NAME, P.L_NO, (T3.AMOUNT - P.AMOUNT) AS REMAINING_AMOUNT
FROM
    (SELECT 
        L_NO, SUM(AMOUNT) AS AMOUNT
    FROM
        PAYMENT
    GROUP BY L_NO) AS P
        INNER JOIN
    (SELECT 
        L.LN_NO, L.AMOUNT, T2.NAME
    FROM
        LOAN L
    INNER JOIN (SELECT 
        T1.C_ID, B.LOAN_NO, T1.NAME, T1.CITY
    FROM
        BORROWER B
    INNER JOIN (SELECT 
        C_ID, NAME, CITY
    FROM
        CUSTOMER
    WHERE
        GENDER = 'F') AS T1 ON T1.C_ID = B.CUST_ID) AS T2 ON L.LN_NO = T2.LOAN_NO
    WHERE
        L.LN_NO LIKE 'hou%') AS T3 ON T3.LN_NO = P.L_NO;
