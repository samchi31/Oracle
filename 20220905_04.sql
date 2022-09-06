2022-0905) ���� ����
CENOS
1. CARTESIAN PRODUCT : ��� ���� ��� ����
2. EQUI JOIN : CARTESIAN PRODUCT �� ���� ������ ���� ��
3. NON-EQUI JOIN :
4. OUTER JOIN
5. SELF JOIN

1) ����� ã�� -> ERD �� ���� -> �⺻Ű+�ܷ�Ű ã�� -> ������������ ���
    --CARTESIAN PRODUCT
    SELECT  *
    FROM    LPROD, PROD; -- 12 X 74 �� = 888��
    
    -- ���� ���� Equi JOIN (�ܷ�Ű)
    SELECT  *
    FROM    LPROD, PROD
    WHERE   LPROD_GU = PROD_LGU;
    
    SELECT  *
    FROM    CART, MEMBER
    WHERE   CART_MEMBER = MEM_ID;
    
    SELECT  *
    FROM    CART, MEMBER, PROD
    WHERE   CART_MEMBER = MEM_ID
    AND     CART_PROD = PROD_ID;
    
    -- PROD : � ��ǰ�� �ִµ�
    -- BUYER : �� ��ǰ�� ��ǰ�� ��ü��?
    -- CART : �� ��ǰ�� ���� ��ٱ��Ͽ� ��Ҵ°�?
    -- MEMBER : ������ �����ΰ�?
    SELECT  A.BUYER_ID, A.BUYER_NAME,
            B.PROD_ID, B.PROD_NAME, B.PROD_BUYER,
            C.CART_PROD, C.CART_MEMBER, C.CART_QTY,
            D.MEM_ID, D.MEM_NAME
    FROM    BUYER A, PROD B, CART C, MEMBER D
    WHERE   A.BUYER_ID = B.PROD_BUYER       -- �������� ������ ���̺���-1
    AND     B.PROD_ID = C.CART_PROD
    AND     C.CART_MEMBER = D.MEM_ID;
    
    (ANSI)
    SELECT  A.BUYER_ID, A.BUYER_NAME,
            B.PROD_ID, B.PROD_NAME, B.PROD_BUYER,
            C.CART_PROD, C.CART_MEMBER, C.CART_QTY,
            D.MEM_ID, D.MEM_NAME
    FROM    BUYER A 
    INNER JOIN PROD B ON (A.BUYER_ID = B.PROD_BUYER)
    INNER JOIN CART C ON (B.PROD_ID = C.CART_PROD)
    INNER JOIN MEMBER D ON (C.CART_MEMBER = D.MEM_ID)
    WHERE   B.PROD_NAME LIKE '%����%';
    
    