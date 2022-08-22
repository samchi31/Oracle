2022-0819-01)
3. ��¥�Լ�
 1) SYSDATE 
  - �ý����� �����ϴ� ��¥ �� �ð����� ����
  - ������ ����, ROUND, TRUNC �Լ��� ���� ����� ��
  - �⺻ ��� Ÿ���� '��/��/��'�̰� '�ú���'�� ����ϱ� ���ؼ��� TO_CHAR �Լ� ���
  - ������ '��', '�ú���'�� �Ҽ���
  
 2) ADD_MONTHS(d, n)
  - �־��� ��¥ d �� n ��ŭ�� ���� ���� ��¥ ��ȯ
  - �Ⱓ�� ������ ��¥�� �ʿ��� ��� ���� ���

��� ��) ���� ��� ��ü�� 2���� ����ȸ������ ����� ��� ���� ������ڸ� ��ȸ�Ͻÿ�    
    SELECT ADD_MONTHS(SYSDATE, 2)-1 FROM DUAL;
    
 3) NEXT_MONTHS(d, c)
    - �־��� ��¥ d ���� c���Ͽ� �ش��ϴ� ��¥ ��ȯ
    - c�� '��', '������', 'ȭ', ...'�Ͽ���' ���
    
��� ��)
    SELECT  NEXT_DAY(SYSDATE, '��'),
            NEXT_DAY(SYSDATE, '�����')
            --NEXT_DAY(SYSDATE, 'FRIDAY')     -- �ѱ۸� ��� ����
    FROM    DUAL;
    
 4) LAST_DAY(d)
    - �־��� ��¥ �������� ���� ������ ���� ��ȯ
    - �ַ� 2���� ���������� ��ȯ �޴� ���� ����
    
��� ��) �������̺��� 2�� ��ǰ�� �������踦 ���Ͻÿ�
        Alias ��ǰ�ڵ�, ��ǰ��, �ż����հ�, ���Աݾ��հ�(����*�ܰ�)
        -- BUY_PROD, PROD �� ���̺� JOIN�ϱ� (����Ӽ��� ������ ����, ���� �÷� ������ �Ұ�)
    SELECT  A.BUY_PROD AS ��ǰ�ڵ�,
            B.PROD_NAME AS ��ǰ��, 
            COUNT(*) AS ����Ƚ��,
            SUM(A.BUY_QTY) AS �ż����հ�, 
            SUM(A.BUY_QTY * B.PROD_COST) AS ���Աݾ��հ�
    FROM    BUYPROD A, PROD B
    WHERE   A.BUY_PROD = B.PROD_ID  --���� ����
    AND     A.BUY_DATE BETWEEN TO_DATE('20200201') AND LAST_DAY(TO_DATE('20200201'))
    GROUP   BY A.BUY_PROD, B.PROD_NAME
    ORDER   BY 1;
    
 5) EXTRACT(fmt FROM d)
    - �־��� ��¥ ������ d���� 'fmt'�� ������ ��� ���� ��ȯ(����)
    - 'fmt'�� YEAR, MONTH, DAY, HOUR, MINUTE, SECOND �� �ϳ�
    - ��ȯ������ Ÿ���� ������
    
��� ��) ������̺��� 50���μ� ���� �� �ټӳ���� 7�� �̻��� ������ ��ȸ�Ͻÿ�
        Alias �����ȣ, �����, ��å, �Ի���, �ټӳ��
        �ټӳ���� ���� ������� ���
        
    -- ������̺��� �ڷ� �� �Ի����� 10���� ����� ���ڷ� ����
    UPDATE  HR.EMPLOYEES
    SET     HIRE_DATE = ADD_MONTHS(HIRE_DATE, 120);

    COMMIT;
    -- ��ȸ 
    SELECT  EMPLOYEE_ID AS �����ȣ, 
            EMP_NAME AS �����, 
            JOB_ID AS ��å, 
            HIRE_DATE AS �Ի���, 
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS �ټӳ��
    FROM    HR.EMPLOYEES
    WHERE   DEPARTMENT_ID = 50
    AND     EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >= 7
    ORDER   BY 4;  --EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) -- 5 DESC = 4
    
    