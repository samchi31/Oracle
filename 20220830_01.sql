2022-0830-01)
5. SEMI Join
 - ���������� ���������� �̿��ϴ� �������� ���� ������ ��� ������ ��������� �����ϴ� ����
 - IN, EXISTS �����ڸ� ����ϴ� ����
 
��� ��) ������̺��� �޿��� 10000�̻��� ����� �����ϴ� �μ��� ��ȸ�Ͻÿ�
        Alias �μ��ڵ�, �μ���, ���������
    (IN ������)    
        SELECT  A.DEPARTMENT_ID AS �μ��ڵ�, 
                A.DEPARTMENT_NAME AS �μ���, 
                B.EMP_NAME AS ���������
        FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
        WHERE   A.DEPARTMENT_ID IN(��������)
        AND     A.MANAGER_ID = B.EMPLOYEE_ID
        ORDER   BY  1;
        (�������� : �޿��� 10000�̻��� ����� �����ϴ� �μ�)
        SELECT  DISTINCT DEPARTMENT_ID 
        FROM    HR.EMPLOYEES
        WHERE   SALARY >= 10000;        
    (����)
    SELECT  A.DEPARTMENT_ID AS �μ��ڵ�, 
            A.DEPARTMENT_NAME AS �μ���, 
            B.EMP_NAME AS ���������
    FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
    WHERE   A.DEPARTMENT_ID IN(SELECT  DISTINCT DEPARTMENT_ID -- �������� �񵿵�����(��������)
                                FROM    HR.EMPLOYEES
                                WHERE   SALARY >= 10000)
    AND     A.MANAGER_ID = B.EMPLOYEE_ID                    -- �������� ��������
    ORDER   BY  1;
    
    (EXISTS ������)   
    SELECT  A.DEPARTMENT_ID AS �μ��ڵ�, 
            A.DEPARTMENT_NAME AS �μ���, 
            B.EMP_NAME AS ���������
    FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
    WHERE   EXISTS(SELECT   1
                    FROM    HR.EMPLOYEES C
                    WHERE   C.SALARY >= 10000
                    AND     A.DEPARTMENT_ID = C.DEPARTMENT_ID)      -- ���� ����
    AND     A.MANAGER_ID = B.EMPLOYEE_ID
    ORDER   BY  1;
    
6. SELF Join
 - �ϳ��� ���̺� 2�� �̻��� ��Ī�� �ο��Ͽ� ���� �ٸ� ���̺�� ������ �� ������ �����ϴ� ���
 
��� ��) ȸ�����̺��� '��ö��' ȸ���� ���ϸ������� ���� ���ϸ����� ������ ȸ�������� ���
        Alias ȸ����ȣ, ȸ����, ����, ���ϸ���
    
    SELECT  B.MEM_ID AS ȸ����ȣ, 
            B.MEM_NAME AS ȸ����, 
            B.MEM_JOB AS ����, 
            B.MEM_MILEAGE AS ���ϸ���
    FROM    MEMBER A, MEMBER B          -- A ���̺� : ��ö���� ����, B ���̺� : ���ǰ� ���� �ٸ� �����
    WHERE   A.MEM_NAME = '��ö��'
    AND     A.MEM_MILEAGE < B.MEM_MILEAGE;
    
��� ��) ��ǰ�ڵ� 'P202000012'�� ���� �з��� ���� ��ǰ �� 'P202000012'���� ���Դܰ��� ū ��ǰ�� ��ȸ�Ͻÿ�
        Alias   ��ǰ�ڵ�, ��ǰ��, �з���, ���Դܰ�
        
    SELECT  B.PROD_ID AS ��ǰ�ڵ�, 
            B.PROD_NAME AS ��ǰ��, 
            C.LPROD_NM AS �з���, 
            B.PROD_COST AS ���Դܰ�
    FROM    PROD A, PROD B, LPROD C     -- ��ǰ�ڵ� ���� ���̺�, �з��ڵ� �� ���̺�,
    WHERE   A.PROD_ID = 'P202000012'
    AND     A.PROD_LGU = B.PROD_LGU     -- �������� Equi
    AND     A.PROD_COST < B.PROD_COST   -- �������� NON-Equi
    AND     A.PROD_LGU = C.LPROD_GU;    -- �������� Equi