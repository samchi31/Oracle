2020-0830-02) �ܺ�����(OUTER JOIN)
 - ���������� ���������� �����ϴ� ����� ��ȯ������, 
   �ܺ������� �ڷᰡ ������ ���̺� NULL���� �߰��Ͽ� ������ ����    (�ڷ� ���� ��, ���� �� �ƴ�)
 - �������� ��� �� �ڷᰡ ������ ���̺��� �÷� �ڿ� �ܺ����� ������ '(+)'�� �߰� �����
 - �ܺ����� ������ �������� �� ��� �ܺ����� ���ǿ� ��� '(+)'�����ڸ� ����ؾ� ��
 - �ѹ��� �� ���̺��� �ܺ������� �� �� ����
   ��, A, B, C ���̺��� �ܺ������� ��� A�� �������� B�� �ܺ������ϰ� ���ÿ�
   C�� �������� B�� �ܺ������� �� ����(A=B(+) AND C=B(+)�� ������ ����)
 - �Ϲ� �ܺ����ο��� �Ϲ������� �ο��Ǹ� ��Ȯ�� ����� ��ȯ���� ���� => ���������� ����� �ܺ�����
   �Ǵ� ANSI �ܺ� �������� �ذ��ؾ� ��
 - IN �����ڿ� �ܺ����ο�����('(+)')�� ���� ����� �� ����
   (�Ϲ� �ܺ����� �������)
   SELECT   �÷�list
   FROM     ���̺��1 [��Ī1], ���̺��2 [��Ī2],...
   WHERE    ��Ī1.�÷���1 (+)= ��Ī2.�÷���2 => ���̺��1�� �ڷᰡ ������ ���̺��� ���
   
   (ANSI �ܺ����� �������)
   SELECT   �÷�list
   FROM     ���̺��1 [��Ī1]
   RIGHT|LEFT|FULL  OUTER   JOIN    ���̺��2 [��Ī2] ON(��������1 [AND �Ϲ�����1])
            :
   [WHERE   �Ϲ�����]   -- �Ϲ����ǵ� ���� ON ���� ����
   
   - 'RIGHT|LEFT|FULL' : FROM ���� ����� ���̺�(���̺�1)�� �ڷᰡ 
                         OUTER JOIN ���̺��2 ���� ������ 'LEFT', ������ 'RIGHT', ���� ��� ������ 'FULL' ���
                         
** 1) SELECT �� ����ϴ� �÷� �� ���� ���̺� ��� �����ϴ� �÷��� ���� �� ���̺� ���� ����ؾ� ��
   2) �ܺ������� SELECT ���� COUNT �Լ��� ����ϴ� �ܿ�
      '*'�� NULL ���� ���� �൵ �ϳ��� ������ �ν��Ͽ� ����Ȯ�� ���� ��ȯ��
      ���� '*' ��� �ش� ���̺��� �⺻Ű�� ���
      
��� ��) ��� �з��� ���� ��ǰ�� ���� ����Ͻÿ�
    (�Ϲ� �ܺ� ����)
    SELECT  B.LPROD_GU AS �з��ڵ�, 
            B.LPROD_NM AS �з���, 
            COUNT(A.PROD_ID) AS "��ǰ�� ��"
    FROM    PROD A, LPROD B     -- PROD �ڷ� ���� �� 7��, LPROD 9��
    WHERE   A.PROD_LGU(+) = B.LPROD_GU
    GROUP   BY  B.LPROD_GU, B.LPROD_NM
    ORDER   BY 1;
    
    (ANSI �ܺ� ����)
    SELECT  B.LPROD_GU AS �з��ڵ�, 
            B.LPROD_NM AS �з���, 
            COUNT(A.PROD_ID) AS "��ǰ�� ��"
    FROM    PROD A              -- PROD �ڷ� ���� �� 7��, LPROD 9��
    RIGHT   OUTER   JOIN    LPROD B ON(A.PROD_LGU = B.LPROD_GU) -- ���ǿ� (+) ����
    GROUP   BY  B.LPROD_GU, B.LPROD_NM
    ORDER   BY 1;
    
��� ��) 2020�� 6�� ��� �ŷ�ó�� �������踦 ��ȸ�Ͻÿ�
        Alias �ŷ�ó�ڵ�, �ŷ�ó��, ���Աݾ��հ�
    (�Ϲ� �ܺ� ����) -- ���ϴ� ��� ��� X
    SELECT  A.BUYER_ID AS �ŷ�ó�ڵ�, 
            A.BUYER_NAME AS �ŷ�ó��, 
            SUM(B.BUY_QTY * C.PROD_COST) AS ���Աݾ��հ�
    FROM    BUYER A, BUYPROD B, PROD C      -- �ڷ� ���� �� BUYER > PROD > BUYPROD
    WHERE   BUY_PROD(+) = C.PROD_ID
    AND     A.BUYER_ID = C.PROD_BUYER(+)
    AND     B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630') -- �ܺ��������ǰ� �Ϲ����� ���� ���� ���� ���� �߻�
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
    
    (ANSI �ܺ� ����)
    SELECT  A.BUYER_ID AS �ŷ�ó�ڵ�, 
            A.BUYER_NAME AS �ŷ�ó��, 
            NVL(SUM(B.BUY_QTY * C.PROD_COST),0) AS ���Աݾ��հ�
    FROM    BUYER A
    LEFT    OUTER   JOIN    PROD C ON(A.BUYER_ID = C.PROD_BUYER) 
    LEFT    OUTER   JOIN    BUYPROD B ON(B.BUY_PROD = C.PROD_ID
                    AND     B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630'))
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
        
    (��������)
    SELECT  A.BUYER_ID AS �ŷ�ó�ڵ�, 
            A.BUYER_NAME AS �ŷ�ó��, 
            NVL(TBL.BSUM,0) AS ���Աݾ��հ�
    FROM    BUYER A,
            (--�ŷ�ó�� 2020�� 6�� ���Աݾ��հ�
            SELECT  C.PROD_BUYER AS CID,
                    SUM(B.BUY_QTY * C.PROD_COST) AS BSUM
            FROM    BUYPROD B, PROD C
            WHERE   B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
            AND     B.BUY_PROD = C.PROD_ID
            GROUP   BY  C.PROD_BUYER) TBL
    WHERE   A.BUYER_ID = TBL.CID(+)
    ORDER   BY  1;
    
��� ��) 2020�� 1�� ��� ��ǰ�� ���Լ������踦 ��ȸ�Ͻÿ� -- ��� -> �ܺ�����
    (�Ϲ� �ܺ� ����) --�������� �߻�
    SELECT  B.PROD_ID AS ��ǰ�ڵ�,      -- �������� ���� ��� ���� ���� �Ӽ��� ����
            B.PROD_NAME AS ��ǰ��,
            SUM(A.BUY_QTY) AS ���Լ�������
    FROM    BUYPROD A, PROD B
    WHERE   A.BUY_PROD(+) = B.PROD_ID      -- PROD > BUYPROD
    AND     A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
    GROUP   BY  B.PROD_ID, B.PROD_NAME
    ORDER   BY  1;
    
    (ANSI �ܺ� ����)
    SELECT  B.PROD_ID AS ��ǰ�ڵ�,      -- �������� ���� ��� ���� ���� �Ӽ��� ����
            B.PROD_NAME AS ��ǰ��,
            SUM(A.BUY_QTY) AS ���Լ�������
    FROM    BUYPROD A
    RIGHT   OUTER   JOIN    PROD B ON(A.BUY_PROD = B.PROD_ID
                    AND     A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))    
    GROUP   BY  B.PROD_ID, B.PROD_NAME
    ORDER   BY  1;
    
    (SUB QUERY ���)
    SELECT  B.PROD_ID AS ��ǰ�ڵ�,      -- �������� ���� ��� ���� ���� �Ӽ��� ����
            B.PROD_NAME AS ��ǰ��,
            A.BSUM AS ���Լ�������
    FROM    PROD B,
            (--2020�� 1�� ��ǰ�� ���Լ��� ���� -- ��������
            SELECT  BUY_PROD,
                    SUM(BUY_QTY) AS BSUM
            FROM    BUYPROD 
            WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
            GROUP   BY BUY_PROD) A
    WHERE   B.PROD_ID = A.BUY_PROD(+)
    ORDER   BY  1;
��� ��) 2020�� 4�� ��� ��ǰ�� ����������踦 ��ȸ�Ͻÿ�
        Alias    ��ǰ�ڵ�, ��ǰ��, ��������հ�
    (ANSI FORMAT)
    SELECT  A.PROD_ID AS ��ǰ�ڵ�, 
            A.PROD_NAME AS ��ǰ��, 
            SUM(B.CART_QTY) AS ��������հ�
    FROM    PROD A 
    LEFT    OUTER   JOIN    CART B ON(B.CART_PROD = A.PROD_ID 
                    AND     B.CART_NO LIKE '202004%')
    GROUP   BY  A.PROD_ID, A.PROD_NAME
    ORDER   BY  1;
    
��� ��) 2020�� 6�� ��� ��ǰ�� ����/����������踦 ��ȸ�Ͻÿ�
        Alias   ��ǰ�ڵ�, ��ǰ��, ���Լ���, �������
    SELECT  A.PROD_ID AS ��ǰ�ڵ�, 
            A.PROD_NAME AS ��ǰ��, 
            SUM(B.BUY_QTY) AS ���Լ���, 
            SUM(C.CART_QTY) AS �������
    FROM    PROD A
    LEFT    OUTER   JOIN    BUYPROD B ON(A.PROD_ID = B.BUY_PROD
                    AND     B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630'))
    LEFT    OUTER   JOIN    CART C ON(C.CART_PROD = A.PROD_ID 
                    AND     C.CART_NO LIKE '202006%')
    GROUP   BY  A.PROD_ID, A.PROD_NAME
    ORDER   BY  1;