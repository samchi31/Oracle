2022-0817-02)
 4) LTRIM(c1 [,c2]), RTRIM(c1 [,c2])
    - �־��� ���ڿ� c1�� ���ʺ���(LTRIM) �Ǵ� �����ʺ���(RTRIM) c2 ���ڿ��� ã��
      ã�� ���ڿ��� ������
    - �ݵ�� ù ���ں��� ��ġ�ؾ���  -- ���� �� ���ں��� ������ ����
    - c2�� �����Ǹ� ������ ã�� ����
    - c1 ���ڿ� ������ ������ ������ �� ����   --REPLACE�� ����
    
��� ��)
    SELECT LTRIM('APPLE PERSIMMON BANANA','PPLE'),      --���۱��� ����ġ �����Ұ�
           LTRIM(' APPLE PERSIMMON BANANA'),            --������ ������ ��������
           LTRIM('APPLE PERSIMMON BANANA','AP'),        --��ġ���ϸ� ���� ���ڰ� ���ӵǸ� ������ AP+P ����
           LTRIM('APPALE PERSIMMON BANANA','AP'),
           LTRIM('PAAP PERSIMMON BANANA','AP')
    FROM   DUAL;
    
    SELECT  * 
    FROM    MEMBER
    WHERE   MEM_NAME=RTRIM('�̻��� ');  
    
 5) TRIM(c1)
    - �־��� ���ڿ� c1�� �¿� ��ȿ ���� ����
    - �ܾ� ������ ���� ���� �Ұ�
    
��� ��) �������̺�(JOBS)���� ������(JOB_TITLE) 'Accounting Manager'�� ������ ��ȸ�Ͻÿ� 
        -- JOB_TITLE CHAR(20)�� ���� ��
    
    SELECT JOB_ID AS �����ڵ�, 
           JOB_TITLE AS ������,
           LENGTHB(JOB_TITLE) AS "�������� ����", 
           MIN_SALARY AS �����޿�, 
           MAX_SALARY AS �ְ�޿�
    FROM   HR.JOBS
    WHERE  JOB_TITLE = 'Accounting Manager';  --TRIM �����ص� �˾Ƽ� TRIM �� ����� ��
    
��� ��) JOBS ���̺��� �������� ������ Ÿ���� VARCHAR2(40)���� ����
        -- CHAR(��������)�� VARCHAR(��������)�� ��ȯ �� UPDATE�� �ʼ�
    UPDATE HR.JOBS 
    SET    JOB_TITLE = TRIM(JOB_TITLE);
    
    COMMIT;
    
 6) SUBSTR(c1,m[,n])
    - �־��� ���ڿ� c1���� m��°���� n���� ���ڸ� ����
    - m�� ������ġ�� ��Ÿ���� 1���� counting��
    - n�� ������ ������ ���� �����ϸ� m��° ���� ��� ���ڸ� ����
    - m�� �����̸� �����ʺ��� counting��
    
��� ��)
    SELECT  SUBSTR('ABCDEFGHIJK', 3, 5),
            SUBSTR('ABCDEFGHIJK', 3),
            SUBSTR('ABCDEFGHIJK', -3, 5),       --�ڿ������� m��°
            SUBSTR('ABCDEFGHIJK', 3, 15)        --�����ִ� ���̺��� �� ��� �ڷ� ��� ����
    FROM    DUAL;
    
��� ��) ȸ�����̺��� �ֹι�ȣ �ʵ�(MEM_REGNO1, MEM_REGNO2)�� �̿��Ͽ� 
        ȸ������ ���̸� ���ϰ�, ȸ����ȣ, ȸ����, �ֹι�ȣ, ���̸� ����Ͻÿ�
        
    SELECT  MEM_ID AS ȸ����ȣ,
            MEM_NAME AS ȸ����, 
            MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ, 
            CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1','2')       --CASE WHEN ���� THEN     ELSE    END (if-else)
            THEN 
                2022 - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) + 1900)
            ELSE 
                2022 - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) + 2000) 
            END AS ����              
    FROM    MEMBER;
    
��� ��) ������ 2020�� 4�� 1���̶�� �����Ͽ� 'c001'ȸ���� ��ǰ�� ������ ��
        �ʿ��� ��ٱ��Ϲ�ȣ�� �����Ͻÿ�. MAX(), TO_CHAR() �Լ� ���
        
    SELECT  '20200401'||TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO,9))) + 1,'00000'))
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,8) = '20200401';
    
    SELECT  MAX(CART_NO) + 1        --���ڷθ� ������ ���ڿ��� ��츸 ����
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,8) = '20200401';
    
��� ��) �̹� �� ������ ȸ������ ��ȸ�Ͻÿ�
        Alias�� ȸ����ȣ, ȸ����, �������, ����
        ��, ������ �ֹε�Ϲ�ȣ�� �̿��� ��
        
    SELECT  MEM_ID AS ȸ����ȣ, 
            MEM_NAME AS ȸ����, 
            MEM_REGNO1 AS �������, 
            SUBSTR(MEM_REGNO1,5) AS ����
    FROM    MEMBER
    WHERE   SUBSTR(MEM_REGNO1,3,2) = '09';
    
 7) REPLACE(c1, c2 [,c3])
    - �־��� ���ڿ� c1���� c2 ���ڿ��� ã�� c3 ���ڿ��� ġȯ
    - c3�� �����Ǹ� c2�� ������
    - �ܾ� ������ �������� ����

��� ��) 
    SELECT  REPLACE('APPLE  PERSIMMON   BANANA','A','����'),
            REPLACE('APPLE  PERSIMMON   BANANA','A'),
            REPLACE('APPLE  PERSIMMON   BANANA',' ','-'),
            REPLACE('APPLE  PERSIMMON   BANANA',' ')        --���ڿ� ���� ��� ���� �� ���
    FROM    DUAL;
    