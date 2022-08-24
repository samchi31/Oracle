2022-0824-01) �����Լ�
��� ��) ��ٱ��� ���̺��� 2020�� 5�� ��ǰ�� �Ǹ����踦 ��ȸ�Ͻÿ�
        Alias ��ǰ�ڵ�, �ǸŰǼ�, �Ǹż���, �ݾ�

    SELECT  A.CART_PROD AS ��ǰ�ڵ�, -- �ܷ�Ű�� A.CART_PROD B.PROD_ID �� �� �ƹ��ų� ��� ����
            COUNT(*) AS �ǸŰǼ�, 
            SUM(A.CART_QTY) AS �Ǹż���, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS �ݾ�
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '202005%'
    AND     A.CART_PROD = B.PROD_ID             --���� �� ���
    GROUP   BY A.CART_PROD
    ORDER   BY A.CART_PROD;
    
��� ��) ��ٱ��� ���̺��� 2020�� 5�� ȸ���� �Ǹ����踦 ��ȸ�Ͻÿ�
        Alias ȸ����ȣ, ���ż���, ���űݾ�
        
    SELECT  A.CART_MEMBER AS ȸ����ȣ, 
            SUM(A.CART_QTY) AS ���ż���, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS ���űݾ�
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '202005%'
    AND     A.CART_PROD = B.PROD_ID 
    GROUP   BY A.CART_MEMBER
    ORDER   BY 1;
        
��� ��) ��ٱ��� ���̺��� 2020�� ����, ȸ���� �Ǹ����踦 ��ȸ�Ͻÿ�
        Alias ��, ȸ����ȣ, ���ż���, ���űݾ�
        
    SELECT  SUBSTR(A.CART_NO,5,2) AS ��, 
            A.CART_MEMBER AS ȸ����ȣ, 
            SUM(A.CART_QTY) AS ���ż���, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS ���űݾ�
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '2020%'      -- SUBSTR(A.CART_NO,1,4) = '2020'
    AND     A.CART_PROD = B.PROD_ID 
    GROUP   BY SUBSTR(A.CART_NO,5,2), A.CART_MEMBER     -- GROUP ���� �߿�
    ORDER   BY 1;
        
��� ��) ��ٱ��� ���̺��� 2020�� 5�� ��ǰ�� �Ǹ����踦 ��ȸ�ϵ�
        �Ǹűݾ��� 100���� �̻��� �ڷḸ ��ȸ�Ͻÿ�
        Alias ��ǰ�ڵ�, �Ǹż���, �ݾ�
        
    SELECT  A.CART_PROD AS ��ǰ�ڵ�, 
            SUM(A.CART_QTY) AS �Ǹż���, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS �ݾ�
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '202005%'
    --AND     A.CART_QTY * B.PROD_PRICE >= 1000000
    AND     A.CART_PROD = B.PROD_ID 
    GROUP   BY A.CART_PROD
    HAVING  SUM(A.CART_QTY * B.PROD_PRICE) >= 1000000   -- �����Լ��� ���ǿ� ���� ��, GROUP BY�� ������ �� HAVING ���
    ORDER   BY 1;
        
��� ��) 2020�� ��ݱ�(1-6��) ���Ծ� ���� ���� ���� ���Ե� ��ǰ 5���� ��ȸ�Ͻÿ�
        Alias ��ǰ�ڵ�, ���Լ���, ���Աݾ�
        
    SELECT  BUY_PROD AS ��ǰ�ڵ�, 
            SUM(BUY_QTY) AS ���Լ���, 
            SUM(BUY_COST * BUY_QTY) AS ���Աݾ�
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    --AND     ROWNUM <= 5      --ROWNUM : ����������� ����Ŭ���� �ڵ����� �Ҵ�Ǵ� PSEUDO COLUMN
    GROUP   BY BUY_PROD
    ORDER   BY 3 DESC;       --WHERE �� ���� �� ORDER BY ����Ǿ ���ϴ� ����� ���� �� ����
    
    --�������� ���
    SELECT  *
    FROM    (SELECT     BUY_PROD AS ��ǰ�ڵ�, 
                        SUM(BUY_QTY) AS ���Լ���, 
                        SUM(BUY_COST * BUY_QTY) AS ���Աݾ�
             FROM    BUYPROD
             WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
             --AND     ROWNUM <= 5      --ROWNUM : ����������� ����Ŭ���� �ڵ����� �Ҵ�Ǵ� PSEUDO COLUMN
             GROUP   BY BUY_PROD
             ORDER   BY 3 DESC)
    WHERE   ROWNUM <= 5 ;
    
��� ��) 2020�� ��ݱ�(1-6��) ���Ծ� ���� ���� ���� ���Ե� ��ǰ 1���� ��ȸ�Ͻÿ�
        Alias ��ǰ�ڵ�, ���Լ���, ���Աݾ�
        
    SELECT  BUY_PROD AS ��ǰ�ڵ�, 
            SUM(BUY_QTY) AS ���Լ���, 
            MAX(SUM(BUY_COST * BUY_QTY)) AS ���Աݾ�    -- �����Լ� �ߺ���� �Ұ�
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    GROUP   BY BUY_PROD
    --HAVING  MAX(SUM(BUY_COST * BUY_QTY))
    ORDER   BY 3 DESC; 
    
����] ������̺��� �μ��� ��ձ޿��� ��ȸ

    SELECT  DEPARTMENT_ID AS �μ�,
            ROUND(AVG(SALARY)) AS ��ձ޿�
    FROM    HR.EMPLOYEES
    GROUP   BY DEPARTMENT_ID
    ORDER   BY 1;
    
����] ������̺��� �μ��� ���� ���� �Ի��� ����� �����ȣ, �����, �μ���ȣ, �Ի����� ���
    
    SELECT  B.EMPLOYEE_ID  AS �����ȣ,
            B.EMP_NAME AS �����,
            A.DEPARTMENT_ID AS �μ���ȣ,
            A.HDATE
    FROM   (SELECT DEPARTMENT_ID, 
                    MIN(HIRE_DATE) AS HDATE
            FROM    HR.EMPLOYEES
            GROUP   BY DEPARTMENT_ID) A,
            HR.EMPLOYEES B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID
    AND     A.HDATE = B.HIRE_DATE
    ORDER   BY 3;
    
    SELECT  EMPLOYEE_ID  AS �����ȣ,
            EMP_NAME AS �����,
            DEPARTMENT_ID, 
            MIN(HIRE_DATE) AS HDATE
    FROM    HR.EMPLOYEES
    GROUP   BY EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID;    -- �����Լ��� ��� �ȵ� �Ӽ��� ���� ���⿡

����] ������� ��ձ޿����� �� ���� �޴� ����� �����ȣ, �����, �μ���ȣ, �޿��� ���
    
    SELECT  EMPLOYEE_ID AS �����ȣ, 
            EMP_NAME AS �����, 
            DEPARTMENT_ID AS �μ���ȣ, 
            SALARY AS �޿�
    FROM    HR.EMPLOYEES
    WHERE   SALARY > (SELECT    AVG(SALARY)
                      FROM      HR.EMPLOYEES)
    ORDER   BY 4 DESC;    
    
����] ȸ�����̺��� ���� ȸ���� ���ϸ��� �հ�� ��� ���ϸ����� ��ȸ�Ͻÿ�
     Alias ����, ���ϸ����հ�, ��ո��ϸ���
     
    SELECT  CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1', '3')
                THEN    '����ȸ��'
                ELSE    '����ȸ��' 
                END     AS ����, 
            COUNT(*)   AS ȸ����,
            SUM(MEM_MILEAGE) AS ���ϸ����հ�, 
            ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���
    FROM    MEMBER
    GROUP   BY CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1', '3')
                THEN    '����ȸ��'
                ELSE    '����ȸ��' 
                END ;
    