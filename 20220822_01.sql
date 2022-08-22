2022-0822-01) ����ȯ �Լ�
 - ����Ŭ�� ������ ����ȯ �Լ��� TO_CHAR, TO_DATE, TO_NUMBER, CAST �Լ��� ������
 - �ش� �Լ��� ���� ������ �Ͻ��� ��ȯ
 
 1) CAST(expr AS type)
  . expr�� �����Ǵ� ������(����, �Լ� ��)�� 'type' ���·� ��ȯ�Ͽ� ��ȯ��
  
��� ��)
    SELECT  BUYER_ID AS �ŷ�ó�ڵ�,
            BUYER_NAME AS �ŷ�ó��1,
            CAST(BUYER_NAME AS CHAR(30)) AS �ŷ�ó��2,
            BUYER_CHARGER AS �����
    FROM    BUYER;
    
    SELECT  --CAST(BUY_DATE AS NUMBER)    -- ���� �߻�
            CAST(TO_CHAR(BUY_DATE,'YYYYMMDD') AS NUMBER)
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131');
    
 2) TO_CHAR(d [, fmt])
  . ��ȯ�Լ� �� ���� �θ� ���
  . ����, ��¥, ���� Ÿ���� ���� Ÿ������ ��ȯ
  . ����Ÿ���� CHAR, CLOB �� VARCHAR2 �� ��ȯ�� ���� ���     --VARCHAR2 -> VARCHAR2 ��ȯ �� ����
  . 'fmt'�� ���Ĺ��ڿ��� ũ�� ��¥���� ���������� ���� ��
  
**��¥�� ���Ĺ���    
-------------------------------------------------------------------------------------
    FORMAT ����      �ǹ�               ��뿹
-------------------------------------------------------------------------------------
    CC              ����              SELECT TO_CHAR(SYSDATE,'CC')||'����' FROM DUAL;
    AD,BC           �����,�����       SELECT TO_CHAR(SYSDATE, 'CC BC')||EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
    YYYY,YYY,YY,Y   �⵵              SELECT TO_CHAR(SYSDATE, 'YYYY YEAR') FROM DUAL; 
    YEAR            �⵵�� ���ĺ�����    
    Q               �б�              SELECT TO_CHAR(SYSDATE,'Q') FROM DUAL;
    MM,RM           ��(�θ���)         SELECT TO_CHAR(SYSDATE,'MM RM') FROM DUAL;
    MONTH,MON       ��                SELECT TO_CHAR(SYSDATE,'MONTH MON') FROM DUAL; --������ ���� �ٸ� Ǯ����, ����̸�
    WW,W            ��                SELECT TO_CHAR(SYSDATE,'WW W') FROM DUAL;      --1��1�Ϻ��� ����, �Ѵ� �ȿ��� ����
    DDD,DD,D        ��                SELECT TO_CHAR(SYSDATE,'DDD DD D') FROM DUAL;  --��,��,��(��:1~��:7)
    DAY, DY         ����              SELECT TO_CHAR(SYSDATE,'DAY DY') FROM DUAL;    --Ǯ����, ����̸�
    AM,PM,A.M.,P.M. ����/����          SELECT TO_CHAR(SYSDATE,'AM PM A.M. P.M.') FROM DUAL; --�ð��� ���ĸ� AM �ᵵ ���� ���   
    HH,HH12,HH24    �ð�              SELECT TO_CHAR(SYSDATE,'HH HH24') FROM DUAL;    --HH=HH12
    MI              ��                SELECT TO_CHAR(SYSDATE,'HH:MI') FROM DUAL;
    SS,SSSSS        ��                SELECT TO_CHAR(SYSDATE,'SS SSSSS') FROM DUAL;   -- �� ��ü ��

**������ ���Ĺ���    
-------------------------------------------------------------------------------------
    FORMAT ����      �ǹ�                       ��뿹
-------------------------------------------------------------------------------------
    9, 0            �����ڷ����                SELECT   TO_CHAR(12345.56,'9,999,999.99'),               -- ��ȿ�� 0�� �������� (9,9 ���� 3ĭ)
                                                       TO_CHAR(12345.56,'0,000,000.00') FROM DUAL;     -- ��ȿ�� 0�� 0����
    ,(COMMA),       3�ڸ����� �ڸ���(,)
    .(DOT)          �Ҽ���
    $,L             ȭ���ȣ                   SELECT  TO_CHAR(PROD_PRICE,'L9,999,999') FROM PROD;
                                             SELECT TO_CHAR(SALARY , '$999,999') AS �޿�1, TO_CHAR(SALARY) AS �޿�2 FROM HR.EMPLOYEES
    PR              �����ڷḦ '<>'�ȿ� ���     SELECT TO_CHAR(-2500,'99,999PR') FROM DUAL;
    MI              �����ڷ� ��� ��            SELECT TO_CHAR(-2500,'99,999MI') FROM DUAL;
                    �����ʿ� '-'���
    
    " "             ����ڰ� ���� �����ϴ� ���ڿ�  SELECT TO_CHAR(SYSDATE, 'YYYY"��" MM"��" DD"��"') FROM DUAL;
    
 3) TO_DATE(c [,fmt])
  . �־��� ���ڿ� �ڷ� c�� ��¥ Ÿ���� �ڷ�� ����ȯ ��Ŵ.
  . c�� ���Ե� ���ڿ� �� ��¥ �ڷ�� ��ȯ�� �� ���� ���ڿ��� ���Ե� ���
    'fmt'�� ����Ͽ� �⺻ �������� ��ȯ�� �� ����
  . 'fmt'�� TO_CHAR �Լ��� '��¥�� ���Ĺ���'�� ����
  
��� ��)
    SELECT  TO_DATE('20200504'),        --�⺻Ÿ������ ���� -- ���� �ڷ����� �ٲܼ� ���� ���ڸ� ����
            TO_DATE('20200504','YYYY-MM-DD'),     --�⺻ ������ Ÿ�� ������ '-'�� '/' �� '/'�� �켱������ ����
            TO_DATE('2020�� 08�� 22��','YYYY"��" MM"��" DD"��"')
    FROM    DUAL;
    
 4) TO_NUMBER(c [,fmt])
  . �־��� ���ڿ� �ڷ� c�� ���� Ÿ���� �ڷ�� ����ȯ ��Ŵ.
  . c�� ���Ե� ���ڿ� �� ���� �ڷ�� ��ȯ�� �� ���� ���ڿ��� ���Ե� ���
    'fmt'�� ����Ͽ� �⺻ �������� ��ȯ�� �� ����
  . 'fmt'�� TO_CHAR �Լ��� '������ ���Ĺ���'�� ����
  
��� ��)
    SELECT  TO_NUMBER('2345') / 7,
            TO_NUMBER('2345.56'),
            TO_NUMBER('2,345', '9,999'),   --0,000 ����
            TO_NUMBER('$2345', '$9999'),
            TO_NUMBER('002,345', '000,000'),
            TO_NUMBER('<2,345>', '9,999PR')
    FROM    DUAL;