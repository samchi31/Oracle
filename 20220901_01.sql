2022-0901-01)
** ���������̺� ����
  1) ���̺�� : REMAIN
  2) �÷���
  ----------------------------------------------------------------
    �÷���         ������Ÿ��           NULLABLE            PK, FK
  ----------------------------------------------------------------
  REMAIN_YEAR      CHAR(4)                                 PK           --�⵵
  PROD_ID          VARCHAR(10)                             PK & FK      --��ǰ�ڵ�
  REMAIN_J_00      NUMBER(5)        DEFAULT 0                           --�������
  REMAIN_I         NUMBER(5)                                            --�԰����
  REMAIN_O         NUMBER(5)                                            --������
  REMAIN_J_99      NUBMER(5)        DEFAULT 0                           --�⸻(��) ���
  REMAIN_DATE      DATE             DEFAULT SYSDATE                     --��������
  ----------------------------------------------------------------

CREATE TABLE REMAIN(
    REMAIN_YEAR      CHAR(4),
    PROD_ID          VARCHAR(10) DEFAULT 0, 
    REMAIN_J_00      NUMBER(5),
    REMAIN_I         NUMBER(5),
    REMAIN_O         NUMBER(5),
    REMAIN_J_99      NUMBER(5) DEFAULT 0,
    REMAIN_DATE      DATE DEFAULT SYSDATE,
    
    CONSTRAINT  pk_remain   PRIMARY KEY(REMAIN_YEAR,PROD_ID),
    CONSTRAINT  fk_remain_prod  FOREIGN KEY(PROD_ID)    REFERENCES PROD(PROD_ID));
    
** ���������̺�(REMAIN)�� ���� �ڷḦ �Է��ϼ���
 �⵵ : 2020��
 ��ǰ�ڵ� : PROD ���̺��� ��� ��ǰ�ڵ�
 ������� : PROD ���̺��� �������(PROD_PROPERSTOCK)
 �԰�/������ : 0
 �⸻��� : PROD ���̺��� �������(PROD_PROPERSTOCK)
 �������� : 2020�� 1�� 1��
 
 1) INSERT ���� SUBQUERY
  . '( )' ������� ����
  . VALUES �� �����ϰ� ���������� ���
  
    INSERT INTO   REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_I, REMAIN_O, REMAIN_J_99, REMAIN_DATE)
        SELECT  '2020', PROD_ID, PROD_PROPERSTOCK,0,0,PROD_PROPERSTOCK,TO_DATE('20200101')
        FROM    PROD;
        
    SELECT  *   FROM    REMAIN;
COMMIT;
 2) ���������� �̿��� UPDATE��
 (�������)
 UPDATE ���̺��
 SET    (�÷���1[,�÷���2,...])=(��������)
 [WHERE ����]
 . SET ������ �����ų �÷��� �ϳ��̻��� ��� ���� ( )�ȿ� �÷����� ����ϸ�
   ���������� SELECT ���� �÷����� ����� ������� 1��1 �����Ǿ� �Ҵ��
 . SET ������ ( )�� ������� ������ �����ų �÷����� ���������� ����ؾ� ��

��� ��) 2020�� 1�� ��ǰ���� �������踦 �̿��Ͽ� ���������̺��� �����Ͻÿ�
        �۾����ڴ� 2020�� 1�� 31��      
        -- ���������̺� ���� : ��������    -- 2020�� 1�� ��ǰ�� ���Լ������� : ��������
    UPDATE  REMAIN A
    SET     (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_I + B.BSUM, 
                    A.REMAIN_J_99 + B.BSUM, 
                    TO_DATE('20200131')
             FROM   (SELECT BUY_PROD,               -- ��ǰ�ڵ尡 ���� ������ �ʿ����� ����
                            SUM(BUY_QTY) AS BSUM
                     FROM   BUYPROD 
                     WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
                     GROUP  BY  BUY_PROD
                     ORDER  BY  1) B
             WHERE   A.PROD_ID = B.BUY_PROD
             )
    WHERE   A.PROD_ID IN (SELECT    BUY_PROD    -- 2020�� 1�� ���Ե� ��ǰ�� �ڵ�
                            FROM    BUYPROD
                           WHERE    BUY_DATE    BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'));
                           
��� ��) 2020�� 2-3�� ��ǰ���� �������踦 �̿��Ͽ� ���������̺��� �����Ͻÿ�
        �۾����ڴ� 2020�� 3�� 31��               
        
    UPDATE  REMAIN A
    SET     (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_I + B.BSUM, 
                    A.REMAIN_J_99 + B.BSUM, 
                    TO_DATE('20200331')
             FROM   (SELECT BUY_PROD,
                            SUM(BUY_QTY) AS BSUM
                     FROM   BUYPROD 
                     WHERE  BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200331')
                     GROUP  BY  BUY_PROD) B
             WHERE   A.PROD_ID = B.BUY_PROD)
    WHERE   A.PROD_ID IN (SELECT    BUY_PROD        
                            FROM    BUYPROD
                           WHERE    BUY_DATE    BETWEEN TO_DATE('20200201') AND TO_DATE('20200331'));
                           
��� ��) 2020�� 4-7�� ��ǰ���� ���Ը������踦 �̿��Ͽ� ���������̺��� �����Ͻÿ�
        �۾����ڴ� 2020�� 8�� 1��    
    --A.PROD_ID = B.BUY_PROD AND A.PROD_ID = C.CART_PROD �� �������� �ʴ� ���� �ϳ� �־ ���ÿ� �Ұ�
    (����)
    UPDATE  REMAIN A
    SET     (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_I + B.BSUM,
                    A.REMAIN_J_99 + B.BSUM, 
                    TO_DATE('20200801')
             FROM   (SELECT BUY_PROD,
                            SUM(BUY_QTY) AS BSUM
                     FROM   BUYPROD 
                     WHERE  BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200731')
                     GROUP  BY  BUY_PROD) B
             WHERE   A.PROD_ID = B.BUY_PROD)
    WHERE   A.PROD_ID IN (SELECT    BUY_PROD
                            FROM    BUYPROD
                           WHERE    BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200731'));
    
    (����)
    UPDATE  REMAIN A
    SET     (A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_O + C.CSUM,
                    A.REMAIN_J_99 - C.CSUM, 
                    TO_DATE('20200801')
             FROM   (SELECT CART_PROD,
                            SUM(CART_QTY) AS CSUM
                     FROM   CART 
                     WHERE  SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007'
                     GROUP  BY  CART_PROD) C
             WHERE   A.PROD_ID = C.CART_PROD)
    WHERE   A.PROD_ID IN (SELECT   CART_PROD
                             FROM   CART 
                            WHERE   SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007');
                            
3) ���������� �̿��� DELETE ��
 (�������)
 DELETE FROM    ���̺��
 WHERE  ����
 . '����'�� IN�̳� EXISTS �����ڸ� ����Ͽ� ���������� ����
 
��� ��) ��ٱ��� ���̺��� 2020�� 4�� 'm001'ȸ���� �����ڷ� �� 'P202000005' ��ǰ�� ���ų����� �����Ͻÿ�
   
    DELETE  FROM CART A
    WHERE   A.CART_MEMBER = 'm001'
    AND     A.CART_NO   LIKE    '202004%'
    AND     A.CART_PROD = 'P202000005';
    
    (�������� ���)
    DELETE  FROM CART A
    WHERE   EXISTS(SELECT   1
                    FROM    MEMBER B
                    WHERE   B.MEM_ID = 'm001'
                    AND     B.MEM_ID = A.CART_MEMBER)
    AND     A.CART_NO   LIKE    '202004%'
    AND     A.CART_PROD = 'P202000005';
                    
ROLLBACK;
COMMIT;