2022-0826-01) NULL ó�� �Լ�
 - ����Ʋ�� �÷��� ����ڰ� �����͸� �������� ������ NULL ���� �⺻������ ����
 - NULL ���� ����Ǹ� ����� ��� NULL �� ��ȯ��
 - NULL �� ���õ� ������ : IS NULL, IS NOT NULL
 - NULL ó�� �Լ� : NVL, NVL2, NULLIF ���� ����
 
 1) NULL ó�� ������
  . NULL ���� '='(Equal to)���� �� �Ұ���
  . �ݵ�� IS [NOT] NULL �� ���ؾ� ��
  
��� ��) ������̺��� ���������� NULL�� �ƴ� ����� ��ȸ�Ͻÿ�
        Alias �����ȣ, �����, ��������, �μ��ڵ�
        
    SELECT  EMPLOYEE_ID AS �����ȣ, 
            EMP_NAME AS �����, 
            COMMISSION_PCT AS ��������, 
            DEPARTMENT_ID AS �μ��ڵ�
    FROM    HR.EMPLOYEES
    --WHERE   COMMISSION_PCT <> NULL;
    WHERE   COMMISSION_PCT IS NOT NULL;
    
 2) NVL(expr, val)
  . 'expr'�� ���� NULL�̸� 'val'�� ��ȯ�ϰ�, NULL�� �ƴϸ� �ڽ�('expr')�� ��ȯ
  . 'expr'�� 'val'�� �ݵ�� ���� ������ Ÿ���̾�� ��
  
  ** ��ǰ���̺��� �з��ڵ尡 'P301'�� ������ ��� ��ǰ�� ���ϸ����� �ش� ��ǰ�� �ǸŰ��� 0.5%�� �����Ͻÿ�
    COMMIT;     -- ROLLBACK�� ���� Ŀ�� ���� ����
  
    UPDATE  PROD
    SET     PROD_MILEAGE=ROUND(PROD_PRICE*0.0005)
    WHERE   PROD_LGU <> 'P301';
    
��� ��) ��ǰ���̺��� ��ǰ�� ���ϸ����� NULL�� ��ǰ�� '���ϸ����� �������� �ʴ� ��ǰ'�̶�� �޽����� 
        ��ǰ���ϸ��� ����÷��� ����Ͻÿ�
        Alias ��ǰ��ȣ, ��ǰ��, ���ϸ���
        
    SELECT  PROD_ID AS ��ǰ��ȣ,
            PROD_NAME AS ��ǰ��,
            NVL(LPAD(TO_CHAR(PROD_MILEAGE ),5),'���ϸ����� �������� �ʴ� ��ǰ') AS ���ϸ���  --���ʰ��� ������ ����  
    FROM    PROD;
    
***NVL�� OUTER JOIN �� ���� ����
��� ��) 2020�� 6�� ��� ��ǰ�� �Ǹ����踦 ��ȸ�Ͻÿ�
        
    SELECT  A.PROD_ID AS ��ǰ�ڵ�, 
            A.PROD_NAME AS ��ǰ��,
            COUNT(B.CART_PROD) AS �Ǹ�Ƚ��, 
            NVL(SUM(B.CART_QTY),0) AS �Ǹż����հ�, 
            NVL(SUM(B.CART_QTY * A.PROD_PRICE),0) AS �Ǹűݾ��հ�
    FROM    PROD A
    LEFT OUTER JOIN     CART B ON(A.PROD_ID=B.CART_PROD AND
                                  B.CART_NO   LIKE    '202006%') -- PROD�� CART ���̺��� ������ ����
    GROUP   BY  A.PROD_ID, A.PROD_NAME  -- ���� ����� �Ӽ��̶� �����Լ��� �������� ���� �Ӽ��� �ۼ��ؾ���
    ORDER   BY  1;
    
** 2020�� 4�� �Ǹ��ڷḦ �̿��Ͽ� ��� ����ȸ������ ���ϸ����� �����Ͻÿ�
    (1. 2020�� 4�� �Ǹ��ڷḦ �̿��� ȸ���� ���ϸ��� �հ�)
    SELECT  A.CART_MEMBER,
            SUM(A.CART_QTY*B.PROD_MILEAGE)
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     A.CART_NO LIKE '202004%'
    GROUP   BY  A.CART_MEMBER;
    
COMMIT;
    (2. ȸ�����̺��� ���ϸ��� ����)
    UPDATE  MEMBER TA
    SET     TA.MEM_MILEAGE = TA.MEM_MILEAGE + NVL((SELECT    TB.MSUM        --NULL ���� 0����
                              FROM    (SELECT   A.CART_MEMBER AS MID,
                                                SUM(A.CART_QTY * B.PROD_MILEAGE) AS MSUM
                                        FROM    CART A, PROD B
                                        WHERE   A.CART_PROD = B.PROD_ID
                                        AND     A.CART_NO LIKE '202004%'
                                        GROUP   BY  A.CART_MEMBER) TB
                              WHERE     TB.MID = TA.MEM_ID), 0);
                              
    CREATE OR REPLACE VIEW V_MEM_MILEAGE
    AS
        SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
        FROM    MEMBER
        WITH    READ    ONLY;
    
    SELECT * FROM V_MEM_MILEAGE;
    
��� ��) 2020�� 4�� ����ȸ���鿡�� Ư�� ���ϸ��� 300����Ʈ�� �����Ͻÿ�
    UPDATE  MEMBER
    SET     MEM_MILEAGE = MEM_MILEAGE + 300
    WHERE   MEM_ID IN (SELECT   DISTINCT CART_MEMBER
                        FROM    CART
                        WHERE   CART_NO LIKE '202004%');
                        
 2)NVL2(expr, val1, val2)
  . 'expr' ���� NULL�̸� 'val2'�� ��ȯ�ϰ� NULL�� �ƴϸ� 'val1'�� ��ȯ
  . 'val1' �� 'val2'�� ������ Ÿ���� �����ؾ� ��
  . NVL�� Ȯ���� ����
  
��� ��) ��ǰ���̺��� ��ǰ�� ������ ����Ͻÿ�. 
        ��, ������ ������ '�������'�� ����Ͻÿ� (NVL, NVL2 ���� ����)
        Alias ��ǰ��ȣ, ��ǰ��, ����
    (NVL ���)
    SELECT  PROD_ID AS ��ǰ��ȣ, 
            PROD_NAME AS ��ǰ��, 
            NVL(PROD_COLOR,'�������') AS ����
    FROM    PROD;
    
    (NVL2 ���)
    SELECT  PROD_ID AS ��ǰ��ȣ, 
            PROD_NAME AS ��ǰ��, 
            NVL2(PROD_COLOR, PROD_COLOR,'�������') AS ����
    FROM    PROD;