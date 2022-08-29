2022-0829-01) ���̺� ����
 - ������ �����ͺ��̽����� ����(Relationship)�� �̿��Ͽ� �������� ���̺�κ���
   �ʿ��� �ڷḦ �����ϴ� ����
 - ���ο� �����ϴ� ���̺��� �ݵ�� ����(�ܷ�Ű ����) �ξ����
   (���谡 ���� ���̺� ���� ������ Cartessian(Cross) join �̶�� ��)
 - ������ ����
   . �������ΰ� �ܺ�����(Inner Join, Outer Join) -- �������� ���� : ��������, �������� �ʴ� ����� ���� : �ܺ�����
   . �Ϲ����ΰ� ANSI Join -- ȸ�縶�� �ٸ� �Ϲ����� ������ ANSI ���� �԰��� ���س�
   . Equi Join, Non-Equi Join, Self Join, Cartessian Product -- = ������ ����: Equi, �ٸ� ������ : Non-Equi

1. �Ϲ� ����
 - �� DB�������� �ڻ��� DBMS�� ����ȭ�� ���������� ����
 - ��� DB�� �ٲ�� ����� ������ ���� �����ؾ� ��
 (��� ����)
 SELECT    �÷�list
 FROM      ���̺��1 [��Ī1], ���̺��2 [��Ī2] [,...]            
 WHERE     [��Ī1|���̺��1].�÷��� = [��Ī2|���̺��2].�÷���
 [AND      ��������]
 [AND      �Ϲ�����]
              :
  . n���� ���̺��� ���Ǹ� �������� ��� n-1�� �̻� �Ǿ�� ��
  . �Ϲ����ǰ� ���������� ��� ������ �ٲ� ��� ����
   
2. ANSI ��������
 (��� ����)
 SELECT    �÷�list
 FROM      ���̺��1 [��Ī1]
 INNER|CROSS|NATURAL JOIN   ���̺��2 [��Ī2] ON(�������� [AND �Ϲ�����])
 INNER|CROSS|NATURAL JOIN   ���̺��3 [��Ī2] ON(�������� [AND �Ϲ�����])
                                :                                
 [WHERE     �Ϲ�����]
               :
  . ���̺��1�� ���̺��2�� �ݵ�� ���� JOIN �����ؾ���
  . ���̺��3�� ���̺��1�� ���̺��2�� ���ΰ���� ���� ����  -- ���̺�1�� ���̺�2�� ���������� ���谡 �־� ������ �Ǿ�� ��
  . 'CROSS JOIN'�� �Ϲ������� Cartessian Product�� ����
  . 'NATURAL JOIN'�� ���ο��꿡 ���� ���̺� ���� �÷����� �����ϸ� �ڵ����� ���� �߻�
  
3. Cartessian Product Join(Cross Join)
 . ���������� ������� �ʾҰų� �߸� ����� ��� �߻�
 . n�� m���� ���̺�� a�� b���� ���̺��� Cross Join�� ��� �־��� ���(���������� ������ ���)
   ����� n*a �� m+b ���� ��ȯ��
 . �ݵ�� �ʿ��� ��찡 �ƴϸ� ����� �����ؾ� ��
 
��� ��)
    SELECT  COUNT(*) AS "PROD ���̺� ���� ��"     FROM    PROD;
    SELECT  COUNT(*) AS "CART ���̺� ���� ��"     FROM    CART;
    SELECT  COUNT(*) AS "BUYPROD ���̺� ���� ��"     FROM    BUYPROD;
    
    SELECT  COUNT(*) AS "BUYPROD ���̺� ���� ��"     FROM    PROD, CART, BUYPROD;
    
    SELECT  *
    FROM    PROD
    CROSS   JOIN    CART
    CROSS   JOIN    BUYPROD;
    
    SELECT  *
    FROM    CART
    INNER   JOIN    BUYPROD ON �������� -- ���������� �Һи� �ϱ� ������ ����
    CROSS   JOIN    PROD;
    
4. Equi Join(ANSI�� INNER JOIN)
 - �������ǿ� '=' ������ ���
 (�Ϲ����� �������)
 SELECT     �÷�list
 FROM       ���̺��1 [��Ī1], ���̺��2 [��Ī2] [,���̺��3 [��Ī3],...]
 WHERE      [��Ī1.]�÷���1 = [��Ī2.]�÷���2         -- ��������
 [AND       [��Ī1.]�÷���1 = [��Ī2.]�÷���3]        -- ��������, �� ��Ī1.�÷���1 = 3 �ƴϿ��� �� (2 = 3 ����)
                :
 [AND       �Ϲ�����]
 
 (ANSI���� �������)
 SELECT     �÷�list
 FROM       ���̺��1 [��Ī1]
 INNER  JOIN    ���̺��2 [��Ī2] ON([��Ī1.]�÷���1=[��Ī2.]�÷���2 [AND �Ϲ�����1])
 INNER  JOIN    ���̺��3 [��Ī3] ON([��Ī1.]�÷���1=[��Ī3.]�÷���3 [AND �Ϲ�����2]) -- �� 1�� �ƴϿ��� �� 2 ����
                  :
 [WHERE      �Ϲ�����]
 
��� ��) �������̺��� 2020�� 6�� ���Ի�ǰ������ ��ȸ�Ͻÿ�
        Alias ����, ��ǰ��ȣ, ��ǰ��, ����, �ݾ�    -- �θ����̺�BUY �ڽ����̺�PROD ���� �÷��� ��� �÷����� �����ϰ��ؾ��Ѵ�.
    (�Ϲ�����)                                   -- (�߸��� �� :BUY_PROD �� PROD_ID) (���� : BUY_ID �� PROD_ID) 
    SELECT  A.BUY_DATE AS ����, 
            B.PROD_ID AS ��ǰ��ȣ,      -- A.BUY_PROD ��� ����
            B.PROD_NAME AS ��ǰ��, 
            A.BUY_QTY AS ����, 
            A.BUY_QTY * B.PROD_COST AS �ݾ�
    FROM    BUYPROD A, PROD B               -- ���̺� ���
    WHERE   A.BUY_PROD = B.PROD_ID          -- ��������
    AND     A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')      -- �Ϲ�����
    ORDER   BY  1;

    (ANSI ����)
    SELECT  A.BUY_DATE AS ����, 
            B.PROD_ID AS ��ǰ��ȣ,     
            B.PROD_NAME AS ��ǰ��, 
            A.BUY_QTY AS ����, 
            A.BUY_QTY * B.PROD_COST AS �ݾ�
    FROM    BUYPROD A       -- ���̺� �ϳ���
    --INNER   JOIN    PROD B ON(A.BUY_PROD = B.PROD_ID AND        --��������
    --                        A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')) --�Ϲ�����
    INNER   JOIN    PROD B ON(A.BUY_PROD = B.PROD_ID)        --��������
    WHERE   A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630') --�Ϲ�����(�������̺��� 2�� �϶��� ����)
    ORDER   BY  1;
    
��� ��) ��ǰ���̺��� 'P10202' �ŷ�ó���� ��ǰ�ϴ� ��ǰ������ ��ȸ�Ͻÿ�
        Alias ��ǰ�ڵ�, ��ǰ��, �ŷ�ó��, ���Դܰ�
    (�Ϲ�����)
    SELECT  A.PROD_ID AS ��ǰ�ڵ�, 
            A.PROD_NAME AS ��ǰ��, 
            B.BUYER_NAME AS �ŷ�ó��, 
            A.PROD_COST AS ���Դܰ�
    FROM    PROD A, BUYER B
    WHERE   A.PROD_BUYER = B.BUYER_ID
    AND     A.PROD_BUYER = 'P10202';
    
    (ANSI����)
    SELECT  A.PROD_ID AS ��ǰ�ڵ�, 
            A.PROD_NAME AS ��ǰ��, 
            B.BUYER_NAME AS �ŷ�ó��, 
            A.PROD_COST AS ���Դܰ�
    FROM    PROD A
    INNER   JOIN    BUYER B ON(A.PROD_BUYER = B.BUYER_ID)
    WHERE   A.PROD_BUYER = 'P10202';
        
��� ��) ��ǰ���̺��� ���� ������ ��ȸ�Ͻÿ�
        Alias ��ǰ�ڵ�, ��ǰ��, �з���, �ǸŴܰ�
    (�Ϲ�����)
    SELECT  A.PROD_ID AS ��ǰ�ڵ�, 
            A.PROD_NAME AS ��ǰ��, 
            B.LPROD_NM AS �з���, 
            A.PROD_PRICE AS �ǸŴܰ�
    FROM    PROD A, LPROD B
    WHERE   A.PROD_LGU = B.LPROD_GU;
    
    (ANSI����)
    SELECT  A.PROD_ID AS ��ǰ�ڵ�, 
            A.PROD_NAME AS ��ǰ��, 
            B.LPROD_NM AS �з���, 
            A.PROD_PRICE AS �ǸŴܰ�
    FROM    PROD A
    INNER   JOIN    LPROD B ON(A.PROD_LGU = B.LPROD_GU);
    
��� ��) ������̺��� �����ȣ, �����, �μ���, �Ի����� ���
    (�Ϲ�����)
    SELECT  A.EMPLOYEE_ID AS �����ȣ, 
            A.EMP_NAME AS �����, 
            B.DEPARTMENT_NAME AS �μ���,
            A.HIRE_DATE AS �Ի���
    FROM    HR.EMPLOYEES A, HR.DEPARTMENTS B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID; --���� ������ ���������� ������ ����� ���
    
    (ANSI����)
    SELECT  A.EMPLOYEE_ID AS �����ȣ, 
            A.EMP_NAME AS �����, 
            B.DEPARTMENT_NAME AS �μ���,
            A.HIRE_DATE AS �Ի���
    FROM    HR.EMPLOYEES A
    INNER   JOIN    HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID);

��� ��) 2020�� 4�� ȸ����, ��ǰ�� �Ǹ����踦 ��ȸ�Ͻÿ�
        Alias ȸ����ȣ, ȸ����, ��ǰ��, ���ż����հ�, ���űݾ��հ�
    (�Ϲ�����)
    SELECT  A.CART_MEMBER AS ȸ����ȣ, 
            B.MEM_NAME AS ȸ����, 
            C.PROD_NAME AS ��ǰ��, 
            SUM(A.CART_QTY) AS ���ż����հ�, 
            SUM(A.CART_QTY * C.PROD_PRICE) AS ���űݾ��հ�
    FROM    CART A, MEMBER B, PROD C
    WHERE   A.CART_MEMBER = B.MEM_ID        -- ��������
    AND     A.CART_PROD = C.PROD_ID         -- �������� 
    AND     A.CART_NO LIKE '202004%'   -- �Ϲ�����
    GROUP   BY  A.CART_MEMBER, B.MEM_NAME, C.PROD_NAME
    ORDER   BY  1;
    
    (ANSI����)
    SELECT  A.CART_MEMBER AS ȸ����ȣ, 
            B.MEM_NAME AS ȸ����, 
            C.PROD_NAME AS ��ǰ��, 
            SUM(A.CART_QTY) AS ���ż����հ�, 
            SUM(A.CART_QTY * C.PROD_PRICE) AS ���űݾ��հ�
    FROM    CART A
    INNER   JOIN    MEMBER B ON(A.CART_MEMBER = B.MEM_ID)
    --INNER   JOIN    PROD C ON(A.CART_PROD = C.PROD_ID   
    --        AND     A.CART_NO LIKE '202004%')   -- �Ϲ����� (��¥�� ���õ� ������ ������ ���ż������� �˱� �����̹Ƿ� ���⿡ ���)
    INNER   JOIN    PROD C ON(A.CART_PROD = C.PROD_ID)
    WHERE   A.CART_NO LIKE '202004%'        -- INNER ���ο����� WHERE������ ���� �ᵵ ���� ���� (�ܺ������� X)
    GROUP   BY  A.CART_MEMBER, B.MEM_NAME, C.PROD_NAME
    ORDER   BY  1;
    
��� ��) 2020�� 5�� �ŷ�ó�� �������踦 ��ȸ�Ͻÿ�
        Alias �ŷ�ó�ڵ�, �ŷ�ó��, ����ݾ��հ�
    (�Ϲ�����)
    SELECT  A.BUYER_ID AS �ŷ�ó�ڵ�, 
            A.BUYER_NAME AS �ŷ�ó��, 
            SUM(B.CART_QTY * C.PROD_PRICE) AS ����ݾ��հ�
    FROM    BUYER A, CART B, PROD C
    WHERE   A.BUYER_ID = C.PROD_BUYER
    AND     C.PROD_ID = B.CART_PROD
    AND     B.CART_NO LIKE '202005%'
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
    
    (ANSI����)
    SELECT  A.BUYER_ID AS �ŷ�ó�ڵ�, 
            A.BUYER_NAME AS �ŷ�ó��, 
            SUM(B.CART_QTY * C.PROD_PRICE) AS ����ݾ��հ�
    FROM    BUYER A
    INNER   JOIN    PROD C ON(A.BUYER_ID = C.PROD_BUYER)
    INNER   JOIN    CART B ON(C.PROD_ID = B.CART_PROD)
    WHERE   B.CART_NO LIKE '202005%'
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
        
��� ��) HR �������� �̱��̿��� ������ ��ġ�� �μ��� �ٹ��ϴ� ���������� ��ȸ�Ͻÿ�
        Alias �μ���ȣ, �μ���, �ּ�, ������
    (�Ϲ�����)
    SELECT  A.DEPARTMENT_ID AS �μ���ȣ, 
            A.DEPARTMENT_NAME AS �μ���, 
            B.STREET_ADDRESS||' '||B.CITY||' '||B.STATE_PROVINCE AS �ּ�, 
            C.COUNTRY_NAME AS ������
    FROM    HR.DEPARTMENTS A, HR.LOCATIONS B, HR.COUNTRIES C
    WHERE   A.LOCATION_ID = B.LOCATION_ID
    AND     B.COUNTRY_ID = C.COUNTRY_ID
    AND     C.COUNTRY_NAME != 'United States of America';
    
    (ANSI����)
    SELECT  A.DEPARTMENT_ID AS �μ���ȣ, 
            A.DEPARTMENT_NAME AS �μ���, 
            B.STREET_ADDRESS||' '||B.CITY||' '||B.STATE_PROVINCE AS �ּ�, 
            C.COUNTRY_NAME AS ������
    FROM    HR.DEPARTMENTS A
    INNER   JOIN    HR.LOCATIONS B ON(A.LOCATION_ID = B.LOCATION_ID)
    INNER   JOIN    HR.COUNTRIES C ON(B.COUNTRY_ID = C.COUNTRY_ID)
    WHERE   C.COUNTRY_NAME != 'United States of America';