2022-0902-01)
4) MINUS
  - �������� ����� ��ȯ
  - A MINUS B : A�� ������� B�� ����� ������ �� ��ȯ
  - B MINUS A : B�� ������� A�� ����� ������ �� ��ȯ
  
��� ��) 2020�� �������̺� CART���� 5���� 6�� ���� �� 5������ �Ǹŵ� ��ǰ�� ��ȸ

    SELECT  DISTINCT A.CART_PROD AS CID, B.PROD_NAME AS CNAME
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     SUBSTR(A.CART_NO,1,6) LIKE '202005%'
    
MINUS
    
    SELECT  DISTINCT A.CART_PROD AS CID, B.PROD_NAME AS CNAME
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     SUBSTR(A.CART_NO,1,6) LIKE '202006%';
    
    (WITH �� ���) -- WITH ���� JOIN �� �ѱ�����
    WITH T1 AS(
        SELECT  DISTINCT CART_PROD AS CID
        FROM    CART 
        WHERE   SUBSTR(CART_NO,1,6) LIKE '202005%'
        
    MINUS
        
        SELECT  DISTINCT CART_PROD
        FROM    CART
        WHERE   SUBSTR(CART_NO,1,6) LIKE '202006%'
    )
    SELECT  A.CID AS ��ǰ�ڵ�,
            B.PROD_NAME AS ��ǰ��
    FROM    T1 A, PROD B
    WHERE   A.CID = B.PROD_ID;