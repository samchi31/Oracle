2022-0818-01) 
2. �����Լ�
 - �����Ǵ� �����Լ��δ� ������ �Լ�(ABS, SIGN, SQRT ��), GREATEST, ROUND, MOD, FLOOR, WIDTH_BUCKET ���� ����
 
 1) ������ �Լ�
  (1) ABS(n), SIGN(n), POWER(e, n), SQRT(n)
   - ABS : n�� ���밪 ��ȯ
   - SIGN : n�� ����̸� 1, �����̸� -1, 0�̸� 0�� ��ȯ
   - POWER : e�� n���� ��(e�� n�� ���� ��) ��ȯ
   - SQRT : n�� ������ ��ȯ
   
��� ��)
    SELECT  ABS(10), ABS(-100), ABS(0),
            SIGN(-20000), SIGN(-0.0099), SIGN(0.000005), SIGN(500000), SIGN(0),
            POWER(2,10),
            SQRT(3.3)
    FROM    DUAL;
    
 2) GREATEST(n1, n2[,...n]), LEAST(n1, n2[,...n])
    - �־��� �� n1 ~ n ������ �� �� ���� ū ��(GREATEST), ���� ���� ��(LEAST) ��ȯ
    - �� ������ �� ���� ū �� -> MAX, �� �� �� ���� ū �� GREATEST
    
��� ��)
    SELECT  GREATEST('KOREA', 1000, 'ȫ�浿'),     -- ���ڿ� ù ������ ASCII �ڵ尪���� ����, �ѱ��� ���� ŭ
            LEAST('200', 'B', '������')
    FROM    DUAL;     
    SELECT  ASCII('ȫ') FROM DUAL;
    
��� ��) ȸ�����̺��� ���ϸ����� 1000�̸��� ȸ���� ã�� 1000���� �����Ͽ� ���
        Alias�� ȸ����ȣ, ȸ����, �������ϸ���, ����ȸ��ϸ���
        
    SELECT  MEM_ID AS ȸ����ȣ, 
            MEM_NAME AS ȸ����, 
            MEM_MILEAGE AS �������ϸ���, 
            GREATEST(MEM_MILEAGE, 1000) AS ����ȸ��ϸ���
    FROM    MEMBER;