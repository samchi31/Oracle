2022-0901-02) ���տ�����
 - SELECT ���� ����� ������� ���տ��� ����
 - UNION ALL, UNION, INTERSECT, MINUS ������ ����    -- �ߺ� ���� ���ϸ� ALL
 - ���տ����ڷ� ����Ǵ� SELECT ���� �� SELECT ���� �÷��� ������ ������ Ÿ����
   ��ġ�ؾ� ��
 - ORDER BY ���� �� ������ SELECT ������ ��� ����
 - BLOB, CLOB, BFILE Ÿ���� �÷��� ���� �����ڸ� ����� �� ����
 - UNION, INTERSECT, MINUS �����ڴ� LONG Ÿ���� �÷��� ����� �� ����
 - GROUPING SETS(col1, col2,...) => UNION ALL ������ ���Ե� ����
   ex) GROUPING SETS(col1, col2, col3) 
       => ((GROUP BY col1) UNION ALL (GROUP BY col2) UNION ALL (GROUP BY col3))
       
1) UNION ALL
 - �ߺ��� ����� �������� ����� ��ȯ
 
��� ��) ȸ�����̺��� ������ �ֺ��� ȸ���� ���ϸ����� 3000 �̻��� ��� ȸ������
        ȸ����ȣ, ȸ����, ����, ���ϸ����� ��ȸ�Ͻÿ� -- �ֺ� U ���ϸ���>=3000
    
    SELECT  MEM_ID AS ȸ����ȣ, 
            MEM_NAME AS ȸ����, 
            MEM_JOB AS ����, 
            MEM_MILEAGE AS ���ϸ���
    FROM    MEMBER
    WHERE   MEM_JOB='�ֺ�'
UNION   ALL
    SELECT  MEM_ID,         -- �ι�° SELECT ���� ��Ī ��������
            MEM_NAME, 
            MEM_JOB, 
            MEM_MILEAGE     -- MEM_REGNO1  -- ������ Ÿ���� ���ƾ���, �÷� ������ ���߾���
    FROM    MEMBER
    WHERE   MEM_MILEAGE>=3000;
    
��� ��) 2020�� 4,5,6,7�� ���ž��� ���� ���� ȸ������ ȸ����ȣ, ȸ����, ���űݾ��հ踦 ��ȸ�Ͻÿ�
    (WITH ���� ����� ���)    -- MAX(SUM()) �� �Ұ��� �ϹǷ� UNION����
    WITH T1 AS              -- WITH : �̸� ��� ���̺� �̸��� ���°�  --T1�̶�� ���̺� ����
        (SELECT '4��' AS MON,        
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202004%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1      -- ORDER BY �� ROWNUM=1�� ���ؾ� �ϹǷ� �ٱ� WHERE ���� ���
         
         UNION  ALL        -- UNION �� �ᵵ �������
         
         SELECT '5��' AS MON,
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202005%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1
         
         UNION  ALL
         
         SELECT '6��' AS MON,
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202006%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1         
         
         UNION  ALL
         
         SELECT '7��' AS MON,
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202007%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1
         ) -- (SELECT ~ ) T1�� ����� �κ�
    SELECT  MON AS ��,
            CID AS ȸ����ȣ,
            CNAME AS ȸ����,
            CTOT1 AS ���űݾ�
    FROM    T1;
    
��� ��) 6���� 7���� �Ǹŵ� ��� ��ǰ�� �ߺ����� �ʰ� ����Ͻÿ�
        Alias ��ǰ�ڵ�, ��ǰ��
    
    SELECT  DISTINCT A.CART_PROD AS ��ǰ�ڵ�,
            B.PROD_NAME AS ��ǰ��
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     A.CART_NO LIKE '202006%'
UNION 
    SELECT  DISTINCT A.CART_PROD AS ��ǰ�ڵ�,
            B.PROD_NAME AS ��ǰ��
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     A.CART_NO LIKE '202007%'
    ORDER   BY  1;          -- ORDER BY�� �ѹ���
    
2) INTERSECT
 - ������(����κ�)�� ��� ��ȯ
 
��� ��) 2020�� ���Ի�ǰ �� 1���� 5���� ��� ���Ե� ��ǰ��
        ��ǰ�ڵ�, ��ǰ��, ����ó���� ��ȸ�Ͻÿ�
        
    SELECT  DISTINCT A.BUY_PROD AS ��ǰ�ڵ�, 
            C.PROD_NAME AS ��ǰ��, 
            B.BUYER_NAME AS ����ó��
    FROM    BUYPROD A, BUYER B, PROD C
    WHERE   A.BUY_PROD = C.PROD_ID
    AND     C.PROD_BUYER = B.BUYER_ID
    AND     A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
INTERSECT
    SELECT  DISTINCT A.BUY_PROD AS ��ǰ�ڵ�, 
            C.PROD_NAME AS ��ǰ��, 
            B.BUYER_NAME AS ����ó��
    FROM    BUYPROD A, BUYER B, PROD C
    WHERE   A.BUY_PROD = C.PROD_ID
    AND     C.PROD_BUYER = B.BUYER_ID
    AND     A.BUY_DATE BETWEEN TO_DATE('20200501') AND TO_DATE('20200531')
    ORDER   BY  1;
    
��� ��) 1�� ���Ի�ǰ �� 5�� �Ǹ� 5�� �ȿ� �����ϴ� ��ǰ������ ��ȸ    

    WITH T1 AS
        (--(1�� ���Ի�ǰ)
        SELECT  BUY_PROD
        FROM    BUYPROD 
        WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
        
    INTERSECT
        --(5�� �Ǹ� �������� 1-5�� ��ǰ)
        SELECT  A.CART_PROD
        FROM    (SELECT CART_PROD,
                        SUM(CART_QTY)
                 FROM   CART
                 WHERE  CART_NO LIKE '202005%'
                 GROUP  BY  CART_PROD
                 ORDER  BY  2 DESC) A
        WHERE   ROWNUM <= 5
        )    
    SELECT  BUY_PROD AS ��ǰ�ڵ�, 
            PROD_NAME AS ��ǰ��
    FROM    T1, PROD
    WHERE   T1.BUY_PROD = PROD_ID;