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
    - �־��� ���ڿ� �¿� ���� ����
    - �ܾ� ������ ���� ���� �Ұ�