2022-0907-01) �б⹮�� �ݺ���
1. �б⹮
 - ���α׷��� ��� �����Ű�� ���
 - IF, CASE WHEN �� ����
 1) IF ��
  . ���߾���� IF �� ���� ��� �����ϸ� ������� ����
  (�������-1)
  IF ���ǽ� THEN
     ��ɹ�1;
  [ELSE 
     ��ɹ�2;]
  END IF;
  
  (�������-2)
  IF ���ǽ�1 THEN
     ��ɹ�1;
  ELSIF ���ǽ�2 THEN
     ��ɹ�2;
  ELSE 
     ��ɹ�3;  
  END IF;

  (�������-3)
  IF ���ǽ�1 THEN
    IF ���ǽ�2 THEN
        ��ɹ�1;
    ELSE 
        ��ɹ�2;
    END IF;
  ELSE 
     ��ɹ�3; 
  END IF;
  
 2) CASE ��
  . ���� �б� ��� ����
  . JAVA�� SWITCH ~ CASE �� ����
  (�������-1)
  CASE WHEN ���ǽ�1 THEN
            ��ɹ�1;
       WHEN ���ǽ�2 THEN
            ��ɹ�2;
              :
       ELSE
            ��ɹ�n;
  END CASE;
  
  (�������-2)
  CASE ���ǽ�1 
       WHEN ��1 THEN
            ��ɹ�1;
       WHEN ��1 THEN
            ��ɹ�2;
              :
       ELSE
            ��ɹ�n;
  END CASE;
  
��� ��) ������̺��� ������ �μ��� �����Ͽ� ù��° �˻��� ����� �޿��� ��ȸ�ϰ�
        �� �޿��� 
            1 ~ 5000  : '����� ���'
         5001 ~ 10000 : '��պ�� ���'
        10001 ~ 20000 : '���� ���'
                �� �̻� : '�ʰ���� ���'�� �����, �޿��� �Բ� ����Ͻÿ�
    
DECLARE
    V_RES VARCHAR2(100);
    V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;
    V_SAL NUMBER := 0;
    V_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;
BEGIN
    V_DID := TRUNC(DBMS_RANDOM.VALUE(10,119),-1);   -- ������ ���� �߻� 10,20...110
    SELECT  EMP_NAME, SALARY
    INTO    V_ENAME, V_SAL
    FROM    HR.EMPLOYEES
    WHERE   DEPARTMENT_ID = V_DID
    AND     ROWNUM = 1;
    
    CASE WHEN V_SAL <= 5000 THEN
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'����� ���';
         WHEN V_SAL <= 10000 THEN
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'��պ�� ���';
         WHEN V_SAL <= 20000 THEN
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'���� ���';
         ELSE 
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'�ʰ���� ���';
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE(V_RES);
END;

2. �ݺ���
 - ����Ŭ PL/SQL ���� Ư�� ��ɹ�(��)�� �ݺ� �����ϴ� ��� ���
 - ���� Ŀ���� �����ϱ����� ����
 - LOOP, WHILE, FOR ���� ������
 1) LOOP
  . �ݺ����� �⺻ ���� ����
  . ���� �ݺ� ��� ����
  (�������)
  LOOP
    �ݺ�ó����(��)
    [EXIT WHEN ����];
  END LOOP;
   - 'EXIT WHEN ����' : ������ ���̸� �ݺ��� ���
   
��� ��) �������� 5���� ����Ͻÿ�

DECLARE
    V_CNT NUMBER := 0;
BEGIN
    LOOP
        V_CNT := V_CNT + 1;
        EXIT WHEN V_CNT > 9;        
        DBMS_OUTPUT.PUT_LINE('5 * '||V_CNT||' = '||V_CNT*5);
    END LOOP;
END;

��� ��) ������̺��� ������ �μ��� �����Ͽ� �ش�μ��� �Ҽӵ� ������� �޿��� ��ȸ�ϰ�  -- ���� ��� -> Ŀ�� ���
        �� �޿��� 
            1 ~ 5000  : '����� ���'
         5001 ~ 10000 : '��պ�� ���'
        10001 ~ 20000 : '���� ���'
                �� �̻� : '�ʰ���� ���'�� �����, �޿��� �Բ� ����Ͻÿ�
                
DECLARE
    V_RES VARCHAR2(100);        -- ���
    V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;     -- �����
    V_SAL NUMBER := 0;      -- �޿�
    V_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;    -- �μ���ȣ
    CURSOR EMP01_CUR(P_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS
        SELECT  EMP_NAME, SALARY
        FROM    HR.EMPLOYEES
        WHERE   DEPARTMENT_ID = P_DID;
BEGIN
    V_DID := TRUNC(DBMS_RANDOM.VALUE(10,119),-1);   -- ������ ���� �߻� 10,20...110
    OPEN    EMP01_CUR(V_DID);
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : '||V_DID);
    LOOP
        FETCH   EMP01_CUR INTO V_ENAME, V_SAL;
        EXIT WHEN   EMP01_CUR%NOTFOUND;     -- Ŀ�� �Ӽ��� FETCH �� ���õ�
        
        CASE WHEN V_SAL <= 5000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'����� ���';
            WHEN V_SAL <= 10000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'��պ�� ���';
            WHEN V_SAL <= 20000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'���� ���';
            ELSE 
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'�ʰ���� ���';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('��� �� : '||EMP01_CUR%ROWCOUNT);
    CLOSE   EMP01_CUR;
END;

 2) WHILE ��
  . �ݺ� ���� �� ������ ���Ͽ� ������ ���̸� �ݺ��� �����ϰ�, ������ �� ����� �����̸�
    �ݺ� ������ ������
  . ���߾���� WHILE ���� ���� ��� ����     -- LOOP���� �� ���� ���
  (�������)
  WHILE ���� LOOP
    �ݺ� ���� ���;
  END LOOP;
  
��� ��) ������ 5���� ����Ͻÿ�

DECLARE
    V_CNT NUMBER := 0;
BEGIN
    WHILE V_CNT <= 9 LOOP
        V_CNT := V_CNT + 1;     
        DBMS_OUTPUT.PUT_LINE('5 * '||V_CNT||' = '||V_CNT*5);
    END LOOP;
END;

��� ��) ������̺��� ������ �μ��� �����Ͽ� �ش�μ��� �Ҽӵ� ������� �޿��� ��ȸ�ϰ� 
        �� �޿��� 
            1 ~ 5000  : '����� ���'
         5001 ~ 10000 : '��պ�� ���'
        10001 ~ 20000 : '���� ���'
                �� �̻� : '�ʰ���� ���'�� �����, �޿��� �Բ� ����Ͻÿ�
                
DECLARE
    V_RES VARCHAR2(100);        -- ���
    V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;     -- �����
    V_SAL NUMBER := 0;      -- �޿�
    V_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;    -- �μ���ȣ
    CURSOR EMP01_CUR(P_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS
        SELECT  EMP_NAME, SALARY
        FROM    HR.EMPLOYEES
        WHERE   DEPARTMENT_ID = P_DID;
BEGIN
    V_DID := TRUNC(DBMS_RANDOM.VALUE(10,119),-1);   -- ������ ���� �߻� 10,20...110
    OPEN    EMP01_CUR(V_DID);
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : '||V_DID);
    FETCH   EMP01_CUR INTO V_ENAME, V_SAL;
    WHILE EMP01_CUR%FOUND LOOP  -- Ŀ�� �Ӽ��� FETCH �� ���õ�
    
        CASE WHEN V_SAL <= 5000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'����� ���';
            WHEN V_SAL <= 10000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'��պ�� ���';
            WHEN V_SAL <= 20000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'���� ���';
            ELSE 
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'�ʰ���� ���';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);        
        FETCH   EMP01_CUR INTO V_ENAME, V_SAL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('��� �� : '||EMP01_CUR%ROWCOUNT);
    CLOSE   EMP01_CUR;
END;

 3) FOR ��
  . �ݺ�Ƚ���� �˰ų� �ݺ�Ƚ���� �߿��� ��� ���
  . ���߾���� FOR ���� ���� ��� ����
  (�Ϲ� FOR �� �������)
  FOR ���ڵ�� IN [REVERSE] �ʱⰪ..������ LOOP
    �ݺ�ó����ɹ�(��);
  END LOOP;
   - '�ε�����' : '�ʱⰪ' ���� '������'�� 1�� ��ȭ���� ������ ������ -- ���� �� ���� �Ұ�
                �ý��ۿ��� �ڵ����� Ȯ��(���� ���ʿ�)
   - 'REVERSE' : �������� ó���� �� ���('�ʱⰪ..������'�� �������� ����)
   
  (Ŀ����� FOR �� �������)
  FOR ���ڵ�� IN Ŀ����|Ŀ�� ���� in-line subquery LOOP
    �ݺ�ó����ɹ�(��);
  END LOOP;
   - '���ڵ��' : Ŀ������ �� ����� ������ ������
                �ý��ۿ��� �ڵ����� Ȯ��(���� ���ʿ�)
   - 'Ŀ�� ���� in-line subquery' : Ŀ������ SELECT ��
   - Ŀ���� �÷������� '���ڵ��.Ŀ���÷���'���� ����
   - Ŀ���� ���� ����ŭ �ݺ�����
   - Ŀ���� OPEN, FETCH, CLOSE �� ���ʿ�       -- ��κ��� Ŀ�� ����� FOR ������
   
��� ��) ������ 5���� ����Ͻÿ�

DECLARE
    V_CNT NUMBER := 0;
BEGIN
    FOR V_CNT IN 1..9 LOOP    
        DBMS_OUTPUT.PUT_LINE('5 * '||V_CNT||' = '||V_CNT*5);
    END LOOP;
END;

��� ��) ������̺��� ������ �μ��� �����Ͽ� �ش�μ��� �Ҽӵ� ������� �޿��� ��ȸ�ϰ� 
        �� �޿��� 
            1 ~ 5000  : '����� ���'
         5001 ~ 10000 : '��պ�� ���'
        10001 ~ 20000 : '���� ���'
                �� �̻� : '�ʰ���� ���'�� �����, �޿��� �Բ� ����Ͻÿ�
                
DECLARE
    V_CNT NUMBER := 0;
    V_RES VARCHAR2(100);        -- ���
    CURSOR EMP01_CUR IS
        SELECT  EMP_NAME, SALARY
        FROM    HR.EMPLOYEES
        WHERE   DEPARTMENT_ID = 80;
BEGIN
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : 80');
    FOR REC IN EMP01_CUR LOOP 
        V_CNT := V_CNT + 1;
        CASE WHEN REC.SALARY <= 5000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'����� ���';
            WHEN REC.SALARY <= 10000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'��պ�� ���';
            WHEN REC.SALARY <= 20000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'���� ���';
            ELSE 
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'�ʰ���� ���';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);      
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('��� �� : '||V_CNT); -- �ݺ��� �ܺο��� Ŀ�� ��� �Ұ�
END;

    (IN-LINE SUBQUERY ���)
DECLARE
    V_CNT NUMBER := 0;
    V_RES VARCHAR2(100);        -- ���
BEGIN
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : 80');
    FOR REC IN (SELECT  EMP_NAME, SALARY
                FROM    HR.EMPLOYEES
                WHERE   DEPARTMENT_ID = 80) LOOP 
        V_CNT := V_CNT + 1;
        CASE WHEN REC.SALARY <= 5000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'����� ���';
            WHEN REC.SALARY <= 10000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'��պ�� ���';
            WHEN REC.SALARY <= 20000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'���� ���';
            ELSE 
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'�ʰ���� ���';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);      
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('��� �� : '||V_CNT); -- �ݺ��� �ܺο��� Ŀ�� ��� �Ұ�
END;