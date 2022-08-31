2022-0831-01) ��������
 - SQL ���� �ȿ� �� �ٸ� SQL ������ �����ϴ� ���� �ǹ�
 - �˷����� ���� ���ǿ� �ٰ��Ͽ� ������ �˻��� �� ����    -- ���� ��� ��ȸ : ��������
 - SELECT, DML, CREATE TABLE, VIEW �� ���     -- CREATE �� �⺻Ű �ܷ�Ű�� ������ �ȵ� -- SELECT ����� VIEW
 - ���������� '( )'�ȿ� ��� (��, INSERT INTO �� ���Ǵ� ���������� ����)
 - �з�
  . �Ϲݼ�������, IN LINE ��������, ��ø��������    -- ��ġ:SELECT ��, FROM ��(ȥ�� ���డ���ؾ���), WHERE ��
  . ���û� �ִ� ��������, ������ ���� ��������    -- ���� �����, ���� ����ȵ�
  . ������(������) / ���Ͽ�(���߿�) ��������        -- �����ڰ� IN, OR, SOME, ANY, EXISTS ��� : ������(����� ����)
  
1) ������ ���� ��������
 - ���������� ���� ���̺�� ���������� ���� ���̺� ���̿� ������ ������� �ʴ� ��������
 
��� ��) ������̺��� ������� ��ձ޿����� ���� �޿��� �޴� ����� ��ȸ
        Alias �����ȣ, �����, ��å�ڵ�, �޿�
    (��ø��������)
    SELECT  EMPLOYEE_ID AS �����ȣ, 
            EMP_NAME AS �����, 
            JOB_ID AS ��å�ڵ�, 
            SALARY AS �޿�
    FROM    HR.EMPLOYEES
    WHERE   SALARY > (--��ձ޿�
                        SELECT  AVG(SALARY)
                        FROM    HR.EMPLOYEES)  -- ��ø���������� ���迬���� �����ʿ��� ��� ����, �������� ���� �����
    ORDER   BY  4 DESC;
    
    (IN-LINE ��������)                
    SELECT  A.EMPLOYEE_ID AS �����ȣ, 
            A.EMP_NAME AS �����, 
            A.JOB_ID AS ��å�ڵ�, 
            A.SALARY AS �޿�
    FROM    HR.EMPLOYEES A, (--��ձ޿�
                            SELECT  AVG(SALARY) AS SAL  -- �������� �ѹ� ����� -> VIEW
                            FROM    HR.EMPLOYEES) B     -- ���̺� A, B ������ ����.
    WHERE   SALARY > B.SAL
    ORDER   BY  4 DESC;    
    
��� ��) 2017�� ���Ŀ� �Ի��� ����� �����ϴ� �μ��� ��ȸ�Ͻÿ�
        Alias �μ���ȣ, �μ���, ���������ȣ
    (��������)
    SELECT  DISTINCT A.DEPARTMENT_ID AS �μ���ȣ, 
            B.DEPARTMENT_NAME AS �μ���, 
            A.MANAGER_ID AS ���������ȣ
    FROM    HR.EMPLOYEES A, HR.DEPARTMENTS B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID
    AND     A.DEPARTMENT_ID IN (-- 2017�� ���Ŀ� �Ի��� ����� �����ϴ� �μ���ȣ
                                SELECT  DISTINCT DEPARTMENT_ID
                                FROM    HR.EMPLOYEES
                                WHERE   HIRE_DATE > TO_DATE('20161231'))
    ORDER   BY 1;
                                
    SELECT  DISTINCT A.DEPARTMENT_ID AS �μ���ȣ, 
            B.DEPARTMENT_NAME AS �μ���, 
            A.MANAGER_ID AS ���������ȣ
    FROM    HR.EMPLOYEES A, HR.DEPARTMENTS B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID
    AND     EXISTS (-- 2017�� ���Ŀ� �Ի��� ����� �����ϴ� �μ���ȣ
                                SELECT  1
                                FROM    HR.EMPLOYEES C
                                WHERE   HIRE_DATE > TO_DATE('20161231')
                                AND     C.EMPLOYEE_ID = A.EMPLOYEE_ID)     -- ���ü� �ִ� ����
    ORDER   BY  1;
                                
                                
    
��� ��) ��ǰ���̺��� ��ǰ�� ����ǸŰ����� �ǸŰ��� �� ���� ��ǰ�� 
        ��ǰ��ȣ, ��ǰ��, �з���, �ǸŰ��� ��ȸ�Ͻÿ�
    
    SELECT  A.PROD_ID AS ��ǰ��ȣ, 
            A.PROD_NAME AS ��ǰ��, 
            C.LPROD_NM AS �з���, 
            A.PROD_PRICE AS �ǸŰ�
    FROM    PROD A, (SELECT AVG(PROD_PRICE) AS BAVG
                    FROM    PROD) B,
                    LPROD C
    WHERE   A.PROD_PRICE > B.BAVG
    AND     C.LPROD_GU = A.PROD_LGU
    ORDER   BY  4;    
        
��� ��) ȸ�����̺��� 2000�� ���� ����� ȸ���� ���ϸ������� �� ���� ���ϸ����� ������ ȸ����
        ȸ����ȣ, ȸ����, �ֹι�ȣ, ���ϸ����� ��ȸ   -- FROM ���������� �ȵ�
    
    SELECT  A.MEM_ID AS ȸ����ȣ, 
            A.MEM_NAME AS ȸ����, 
            A.MEM_REGNO1||'-'||A.MEM_REGNO2 AS �ֹι�ȣ, 
            A.MEM_MILEAGE AS ���ϸ���
    FROM    MEMBER A
    WHERE   A.MEM_MILEAGE > ALL(SELECT  MEM_MILEAGE AS MI
                                FROM    MEMBER
                                WHERE   MEM_BIR < TO_DATE('20000101'))
    ORDER   BY  4;
        
��� ��) ��ٱ������̺��� 2020�� 5�� ȸ���� �ְ� ���űݾ��� ����� ȸ���� ��ȸ�Ͻÿ�
        Alias ȸ����ȣ, ȸ����, ���űݾ��հ�     -- (��¥�� ȸ���� ���űݾ� �� ��������) -> �ְ� ���űݾ� ȸ��
        
    SELECT  TA.CID AS ȸ����ȣ, 
            M.MEM_NAME AS ȸ����, 
            TA.CSUM AS ���űݾ��հ�
    FROM    MEMBER M,
            (SELECT  A.CART_MEMBER AS CID,          --ȸ����ȣ
                     SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM     --���űݾ��հ�
            FROM    CART A, PROD B
            WHERE   A.CART_PROD = B.PROD_ID
            AND     A.CART_NO   LIKE    '202005%'
            GROUP   BY  A.CART_MEMBER
            ORDER   BY  2 DESC) TA
    WHERE   M.MEM_ID = TA.CID
    AND     ROWNUM = 1;     --�� 1��
    
    (WITH �� ���)
    WITH    A1 AS (SELECT   A.CART_MEMBER AS CID,          --ȸ����ȣ
                            SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM     --���űݾ��հ�
                    FROM    CART A, PROD B
                    WHERE   A.CART_PROD = B.PROD_ID
                    AND     A.CART_NO   LIKE    '202005%'
                    GROUP   BY  A.CART_MEMBER
                    ORDER   BY  2 DESC)
    SELECT  B.MEM_ID, B.MEM_NAME, A1.CSUM
    FROM    MEMBER B, A1
    WHERE   B.MEM_ID = A1.CID
    AND     ROWNUM = 1;