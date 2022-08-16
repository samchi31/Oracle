2022-0810-01)
4. ��Ÿ������
 - ����Ŭ���� �����ϴ� ��Ÿ �����ڴ� IN, ANY, SOME, ALL, EXISTS, BETWEEN, LIKE �����ڰ� ����
 - EXISTS �� SUBQUERY�� �ݵ�� �ڿ� �;��� ( IN , ANY, SOME, ALL �� ��ȣ �ȿ� ���� ��� ��)
 1) IN ������
  . IN �����ڿ��� '='(Equal to) ����� ����
  . IN ���� '( )'�ȿ� ����� �� �� ��� �ϳ��� ��ġ�ϸ� ��ü ����� ��(TRUE)�� ��ȯ
  . IN �����ڴ� '=ANY', '=SOME'���� ġȯ ����
  . IN �����ڴ� OR �����ڷ� ġȯ ����
  (��� ����)
   expr IN (��1,��2,..��n);
   => expr = ��1 OR expr = ��2 OR ... OR expr = ��n;
  . IN �����ڴ� �ҿ������� ���̳� �ұ�Ģ�� ���� ���� �� �ַ� ���
   => �������� ���� ���� BETWEEN ��� 

��� ��) ������̺��� �μ���ȣ�� 20, 50, 60, 100���� ���� ������� ��ȸ
        Alias�� �����ȣ, �����, �μ���ȣ, �Ի���
    (OR ���)
    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           DEPARTMENT_ID AS �μ���ȣ, 
           HIRE_DATE AS �Ի���
      FROM HR.EMPLOYEES
     WHERE DEPARTMENT_ID =20
        OR DEPARTMENT_ID =50
        OR DEPARTMENT_ID =60
        OR DEPARTMENT_ID =100
     ORDER BY 3;
     
    (IN ���)
    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           DEPARTMENT_ID AS �μ���ȣ, 
           HIRE_DATE AS �Ի���
      FROM HR.EMPLOYEES
     WHERE DEPARTMENT_ID IN (20, 50, 60, 100)
     ORDER BY 3;
     
    (ANY, SOME ���)
    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           DEPARTMENT_ID AS �μ���ȣ, 
           HIRE_DATE AS �Ի���
      FROM HR.EMPLOYEES
     --WHERE DEPARTMENT_ID = ANY(20, 50, 60, 100)
     WHERE DEPARTMENT_ID = SOME(20, 50, 60, 100)
     ORDER BY 3;
     
 2) ANY(SOME) ������
  . IN �����ڿ� ����� ��� ����
  . ANY �� SOME �� ���� ���
  (�������)
   expr ���迬���� ANY|SOME(��1,...,��n) -- ���迬���� �ʼ� (=,!=,>,<...)
    - expr�� ���� ( )���� �� �� ��� �ϳ��� ���õ� ���迬���ڸ� �����ϸ� ��ü�� ��(TRUE)�� ��ȯ ��
    
��� ��) ������̺��� �μ���ȣ 60�� �μ��� ���� ������� �޿� �� ���� ���� �޿����� �� ���� �޿��� �޴� ������� ��ȸ
        Alias�� �����ȣ, �����, �޿�, �μ���ȣ�̸� �޿��� ���� ������� ����Ͻÿ�

    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           SALARY AS �޿�,
           DEPARTMENT_ID AS �μ���ȣ
      FROM hr.EMPLOYEES
     WHERE SALARY > ANY(SELECT SALARY               -- SOME (~ �� ����
                          FROM HR.EMPLOYEES         -- WHERE SALARY > ANY(9000,6000,4800,4200)
                         WHERE DEPARTMENT_ID = 60) 
       AND DEPARTMENT_ID != 60
     ORDER BY 3; 
     --�˷��������� ���� ����� ���� �� => SUBQUERY
     
��� ��) 2020�� 4�� �Ǹŵ� ��ǰ �� ���Ե��� ���� ��ǰ�� ��ȸ�Ͻÿ�
        Alias�� ��ǰ�ڵ��̴�.
        
    SELECT DISTINCT CART_PROD AS ��ǰ�ڵ�
      FROM CART
     WHERE CART_NO LIKE '202004%'           
       AND NOT CART_PROD = ANY(SELECT DISTINCT BUY_PROD      --���� != ����;
                                 FROM BUYPROD
                                WHERE BUY_DATE >= '20200401' AND BUY_DATE <= '20200430');                            
  
 3) ALL ������
 (�������)
  expr ���迬���� ALL(��1,...,��n)
  - expr�� ���� �־��� '��1'~'��n'�� ��� ���� ���迬���� ������ ����� ���̸�
    WHERE ���� ����� TRUE�� ��ȯ
  - ANY(SOME)�� ���� ���� ���� �������� �ϰ�, ALL �� ���� ū ���� �������� ��
  - '='�� ���� ��� �Ұ� (�������� �ȵ�)
  
��� ��) ������̺��� �μ���ȣ 60�� �μ��� ���� ������� �޿� �� ���� ���� �޿����� �� ���� �޿��� �޴� ������� ��ȸ
        Alias�� �����ȣ, �����, �޿�, �μ���ȣ�̸� �޿��� ���� ������� ����Ͻÿ�

    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           SALARY AS �޿�,
           DEPARTMENT_ID AS �μ���ȣ
      FROM hr.EMPLOYEES
     WHERE SALARY > ALL(9000,6000,4800,4200)  -- 9000���� ū����� ã��
     ORDER BY 3; 
     
     