2022-0823-01) �����Լ� ����ϱ�

��� ��) 
    SELECT  AVG(DISTINCT PROD_COST),    -- �ߺ��� ���� ����
            AVG(ALL PROD_COST),         -- ��� �� ����
            AVG(PROD_COST)              -- ALL�� ������ �ſ� ����
    FROM    PROD
    ORDER   BY 1;
    
��� ��) ��ǰ���̺��� ��ǰ�з��� ���԰��� ��� ��

    SELECT  PROD_LGU AS ��ǰ�з��ڵ�,
            ROUND(AVG(PROD_COST),2) PROD_COST  -- AS ���� �Ҽ��� 2�ڸ����� �ݿø�
    FROM    PROD
    GROUP   BY PROD_LGU     -- ~���� ��� ����
    ORDER   BY 1;
    
��� ��) ��ǰ �з��� ���Ű��� ���

    SELECT  PROD_LGU AS ��ǰ�з�,
            ROUND(AVG(PROD_SALE),2) ���Ű������
    FROM    PROD
    GROUP   BY PROD_LGU
    ORDER   BY 1;
    
��� ��) 
    SELECT  PROD_LGU,
            PROD_BUYER,
            ROUND(AVG(PROD_COST),2) PROD_COST,
            SUM(PROD_COST),
            MAX(PROD_COST),
            MIN(PROD_COST),
            COUNT(PROD_COST)
    FROM    PROD
    GROUP   BY PROD_LGU, PROD_BUYER     -- ��з� PROD_LGU, �ߺз� PROD_BUYER
    ORDER   BY 1, 2;
    
��� ��) ��ǰ���̺��� �� �ǸŰ����� ��հ��� ���Ͻÿ�
        Alias�� ��ǰ���ǸŰ����     -- Alias�� ��� BYTES�� 30BYTES�̴�.
        
    SELECT  AVG(SUM(PROD_SALE)) AS ��ǰ���ǸŰ����
    FROM    PROD
    GROUP   BY PROD_LGU;
    
��� ��) ��ǰ���̺��� ��ǰ�з� �� �ǸŰ��� ��� ���� ���Ͻÿ�
        Alias ��ǰ�з�, ��ǰ�з����ǸŰ������ -- Alias�� ��� BYTES�� 30BYTES�̴� ������
        
    SELECT  PROD_LGU AS ��ǰ�з�,
            TO_CHAR(ROUND(AVG(PROD_SALE),2),'L9,999,999.00') AS ��ǰ���ǸŰ����  -- �Ҽ��� 2�ڸ� 0 ���� ���߱�
    FROM    PROD
    GROUP   BY PROD_LGU
    ORDER   BY 1;
    
��� ��) �ŷ�ó���̺��� ����ڸ� �÷����� �Ͽ� COUNT ���� �Ͻÿ�     -- COUNT�� NULL���� ������ ���� �ʴ´�.
        Alias�� �ڷ��(DISTINCT), �ڷ��, �ڷ��(*)            -- �ĺ�Ű : NOT NULL, NOT DUPLICATE
        
    SELECT  COUNT(*),           --74��   -- ���� �� : CARDINALITY , ���� ��: DEGREE
            COUNT(PROD_COLOR)   --41��
    FROM    PROD;       
        
    SELECT  COUNT(DISTINCT BUYER_CHARGER) "�ڷ��(DISTINCT)",
            COUNT(BUYER_CHARGER) �ڷ��,
            COUNT(*) "�ڷ��(*)"
    FROM    BUYER;
    
��� ��) ȸ�����̺��� ��̺� COUNT ����, ȸ���� ��� �� �ο� ���� ���غ���
        Alias�� ���, �ڷ��, �ڷ��(*)      -- #_$ : ���̺��, �÷���, Alias�� �� �� �ִ� (ù���ڴ� �Ұ�)
        
    SELECT  MEM_LIKE ���, 
            COUNT(MEM_LIKE) �ڷ��, 
            COUNT(*) "�ڷ��(*)"
    FROM    MEMBER
    GROUP   BY MEM_LIKE
    ORDER   BY 1;
    
��� ��) ��ٱ������̺��� ȸ���� �ִ뱸�ż����� �˻�
        Alias ȸ��ID, �ִ����, �ּҼ���
        
    SELECT  CART_MEMBER ȸ��ID, 
            MAX(CART_QTY) �ִ����, 
            MIN(CART_QTY) �ּҼ���
    FROM    CART
    GROUP   BY CART_MEMBER
    ORDER   BY 1;
    
��� ��) ������ 2020��7��11���̶� �����ϰ� ��ٱ������̺� �߻��� �߰��ֹ���ȣ�� �˻�
        Alias �ְ�ġ�ֹ���ȣ , �߰��ֹ���ȣ
        
    SELECT  MAX(CART_NO) AS �ְ�ġ�ֹ���ȣ , 
            MAX(CART_NO)+1 AS �߰��ֹ���ȣ
    FROM    CART
    WHERE   CART_NO BETWEEN '2020071100000' AND '2020071200000'; 
    -- WHERE SUBSTR(CART_NO, 1, 8) = '20200711'
    -- AND   CART_NO LIKE '20200711%'       -- LIKE�� �Բ� ���� %, _�� ���ϵ� ī���� �Ѵ�
    
��� ��) ��ǰ���̺��� ��ǰ�з�, �ŷ�ó���� �ְ��ǸŰ�, �ּ��ǸŰ�, �ڷ���� �˻�

    SELECT  MAX(PROD_SALE) �ְ��ǸŰ�, 
            MIN(PROD_SALE) �ּ��ǸŰ�, 
            COUNT(*) �ڷ��
    FROM    PROD
    GROUP   BY PROD_LGU, PROD_BUYER;
    
    