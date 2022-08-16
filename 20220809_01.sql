2022-0809-01)������
 1. ����(��)������
  - �ڷ��� ��Ұ��踦 ���ϴ� �����ڷ� ����� ��(true)�� ����(false)�� ��ȯ
  - >, <, >=, <=, +, != (<>:�����ʴ�)
  - ǥ����(CASE WHEN ~  THEN, DECODE) �̳� WHERE �������� ���
  
��� ��) ȸ�� ���̺�(MEMBER)���� ��� ȸ������ ȸ����ȣ, ȸ����, ����, ���ϸ����� ��ȸ�ϵ�
        ���ϸ����� ���� ȸ������ ��ȸ
        
  SELECT MEM_ID AS ȸ����ȣ,
         MEM_NAME AS ȸ����,
         MEM_JOB AS ����,
         MEM_MILEAGE AS ���ϸ���
    FROM MEMBER
   ORDER BY 4 DESC;     --ORDER BY MEM_MILEAGE DESC;  //COLUMN INDEX�� ���(����ϱ� ������ ��� ���)

(HR �������� ����) ***************************************************************  
  ** EMPLOYEES ���̺� ���ο� �÷�(EMP_NAME), ������Ÿ���� VARCHAR2(80)�� �÷��� �߰�
    ALTER TABLE ���̺�� ADD(�÷��� ������Ÿ��[(ũ��)][DEFAULT ��]);    
ALTER TABLE EMPLOYEES ADD(EMP_NAME VARCHAR2(80));

  ** �����ʹ� ���� �ڷ�(FIRST_NAME + LAST_NAME)�� �Է�
    UPDATE �� => �ڷ� ����,������ �� ���
    UPDATE ���̺��
       SET �÷��� = ��[,]
                :
           �÷��� = ��
    [WHERE ����];     --���� �� ��� ���� �Ȱ��� ������
    
UPDATE HR.EMPLOYEES     -- �������� ����ϸ� ���Ӱ����� ��ü ��� Ȯ�� ����
   SET salary = 1000; 
ROLLBACK; --�������

UPDATE EMPLOYEES
   SET EMP_NAME = FIRST_NAME||' '||LAST_NAME;     -- ||:���ڿ�����
SELECT EMPLOYEE_ID, 
       EMP_NAME
  FROM EMPLOYEES;
COMMIT; -- DB�ݿ�
***************************************************************
��� ��) ������̺�(HR.EMPLOYEES) �μ���ȣ�� 50���� ������� ��ȸ
        Alias�� �����ȣ,�����,�μ���ȣ,�޿��̴�.  --��Ī -> SELECT �Ӽ� ����
        
  SELECT EMPLOYEE_ID AS �����ȣ,
         EMP_NAME AS �����,
         DEPARTMENT_ID AS �μ���ȣ,
         SALARY AS �޿�
    FROM HR.EMPLOYEES
   WHERE DEPARTMENT_ID = 50;

��� ��) ȸ�� ���̺�(MEMBER)���� ������ �ֺ��̰� --���ϸ����� 3000�̻��� ȸ������ ��ȸ
        Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���
        
  SELECT MEM_ID AS ȸ����ȣ, 
         MEM_NAME AS ȸ����, 
         MEM_JOB AS ����, 
         MEM_MILEAGE AS ���ϸ���
    FROM MEMBER
   WHERE MEM_JOB = '�ֺ�'; --AND MEM_MILEAGE >= 3000;
   
 2. ���������
  - '+', '-', '*', '/' => 4Ģ������
  - ( ) : ���� �켱���� ����

��� ��) ������̺�(HR.EMPLOYEES)���� ���ʽ��� ����ϰ� ���޾��� �����Ͽ� ����ϼ���
        ���ʽ� = ���� * ���������� 30%
        ���޾�=����+���ʽ�
        Alias�� �����ȣ, �����, ����, ��������, ���ʽ�, ���޾�
        ��� ���� �����κи� ���
        
    SELECT EMPLOYEE_ID AS �����ȣ, 
           EMP_NAME AS �����,             --FIRST_NAME||' '||LAST_NAME
           SALARY AS ����, 
           COMMISSION_PCT AS ��������, 
           NVL(ROUND(SALARY * COMMISSION_PCT * 0.3),0) AS ���ʽ�,     --ROUND():�Ҽ�ù°�ڸ� �ݿø� (TRUNC)
                                                                     --NVL(,0):NULL���̸� 0������
           SALARY + NVL(ROUND(SALARY * COMMISSION_PCT * 0.3),0) AS ���޾�
      FROM HR.EMPLOYEES;     
     -- ǥ�� SQL ���� ��� �Ұ�
     -- NULL �� ���� �� ��� NULL
 
 3. ��������
  - �� ���̻��� ������� ����(AND, OR)�ϰų� ����(NOT)��� ��ȯ
  - NOT, AND, OR
  --------------------------
     �Է�          ���
    A   B       OR  AND
  --------------------------
    0   0       0   0
    0   1       1   0
    1   0       1   0
    1   1       1   1
 
��� ��) ��ǰ���̺�(PROD)���� �ǸŰ����� 30���� �̻��̰� ������� 5�� �̻���
        ��ǰ��ȣ, ��ǰ��, ���԰�, �ǸŰ�, ������� ��ȸ           -- �� ��ȸ:SELECT, �� ��ȸ ����:WHERE

    SELECT PROD_ID AS ��ǰ��ȣ,
           PROD_NAME AS ��ǰ��, 
           PROD_COST AS ���԰�,
           PROD_PRICE AS �ǸŰ�, 
           PROD_PROPERSTOCK AS �������
      FROM PROD
     WHERE PROD_PRICE >= 300000 
       AND PROD_PROPERSTOCK >= 5
     ORDER BY 4;

��� ��) �������̺�(BUYPROD)���� 2020�� 1���̰� ���Լ����� 10�� �̻��� ���������� ��ȸ
        Alias ������, ���Ի�ǰ, ���Լ���, ���Աݾ�
   
    SELECT BUY_DATE AS ������,
           BUY_PROD AS ���Ի�ǰ, 
           BUY_QTY AS ���Լ���,
           BUY_QTY * BUY_COST AS ���Աݾ�
      FROM BUYPROD
     WHERE BUY_DATE >= TO_DATE('20200101')  
       AND BUY_DATE <= TO_DATE('20200131')
       AND BUY_QTY >= 10; 
       
��� ��) ȸ�����̺�(MEMBER)���� ���ɴ밡 20���̰ų� ������ ȸ���� ��ȸ    --�ֹι�ȣ ���ڸ�+�ֹι�ȣ ���ڸ�,�Ǵ� ������� ���
        Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, ���ϸ���

    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����, 
           MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
           TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ�,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) = 20 -- TRUNC(,-1) : �����ڸ� ����
                                                                                -- EXTRACT : Ư�� �κи� ����
        OR SUBSTR(MEM_REGNO2,1,1) IN ('2','4');    
    
��� ��) ȸ�����̺�(MEMBER)���� ���ɴ밡 20���̰ų� �����̸鼭 ���ϸ����� 2000�̻��� ȸ���� ��ȸ
        Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, ���ϸ���
        
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����, 
           MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
           TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ�,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE (TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) = 20 
        OR SUBSTR(MEM_REGNO2,1,1) IN ('2','4'))
       AND MEM_MILEAGE >= 2000;  
       
��� ��) Ű����� �⵵�� �Է¹޾� ����� ����� �Ǵ��Ͻÿ�
        ���� : 4�ǹ���̸鼭 100�� ����� �ƴϰų� �Ǵ� 400�� ����� �Ǵ� �⵵
    ACCEPT P_YEAR PROMPT '�⵵�Է� : '      -- ��� �κ�, ACCEPT: ����� �Է� �� ����
    DECLARE                                -- ����κ�
        V_YEAR NUMBER:=TO_NUMBER('&P_YEAR');        -- P_YEAR ���ڿ��� ���ڷ�
        V_RES VARCHAR2(100);        
    BEGIN                                  -- ����κ�
        IF (MOD(V_YEAR, 4)=0 AND MOD(V_YEAR,100) != 0) OR (MOD(V_YEAR, 400)=0) THEN     -- MOD : %����������
            V_RES:=TO_CHAR(V_YEAR)||'�⵵�� �����Դϴ�';
        ELSE 
            V_RES:=TO_CHAR(V_YEAR)||'�⵵�� ����Դϴ�';
        END IF;            
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END;