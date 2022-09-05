2022-0905-02) ���Ǿ� ��ü(SYNONYM)
 - ����Ŭ ��ü�� ��Ī�� �ο��� �� ���
 - �ٸ� �������� ��ü�� �����ϴ� ��� "��Ű����.��ü��" �������� �����ؾ� �� 
   => �̸� ����ϱ� ���� ����� ������ �ܾ�� ����� �� �ִ� ��� ����

 (�������)
 CREATE [OR REPLACE]    SYNONYM ����
 FOR    ������ü��
 
��� ��) HR ������ EMPLOYEES ���̺�� DEPARTMENTS ���̺��� EMP �� DEPT�� ��Ī�� �ο��Ͻÿ�

    CREATE OR REPLACE   SYNONYM EMP FOR HR.EMPLOYEES;
    
    SELECT * FROM EMP;
    
    CREATE OR REPLACE   SYNONYM DEPT FOR HR.DEPARTMENTS;
    
    SELECT * FROM DEPT;
    
    SELECT  A.EMPLOYEE_ID, A.EMP_NAME, B.DEPARTMENT_NAME
    FROM    EMP A, DEPT B
    WHERE   B.DEPARTMENT_ID IN (20,30,50,60)
    AND     A.DEPARTMENT_ID = B.DEPARTMENT_ID;