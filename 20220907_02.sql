2022-0907-02) stored Procedure(Procedure)
 - Ư�� ������ ó���Ͽ� �� ��� ���� ��ȯ���� �ʴ� ���� ���α׷�
 - �̸� �����ϵǾ� ����(������ ȿ������ ����, ��Ʈ��ũ�� ���� ���޵Ǵ� �ڷ��� ���� �۴�)
 (�������)
 CREATE [OR REPLACE] PROCEDURE ���ν�����[(
    ������ [IN|OUT|INOUT] ������Ÿ��[:=����Ʈ��],   -- IN|OUT|INOUT ���� �� IN���� ���
                :
    ������ [IN|OUT|INOUT] ������Ÿ��[:=����Ʈ��])]
 IS|AS
    ���𿵿�        -- ��������
 BEGIN
    ���࿵��        -- SQL, �ݺ�, �б⹮
 END;
  . '������' : �Ű�������
  . 'IN|OUT|INOUT' : �Ű������� ���� ����(IN:�Է¿�, OUT:��¿�, INOUT:����� ����) --��ȯ�� �ƴ� SELECT ������ ���Ұ�
  . '������Ÿ��' : ũ�⸦ ����ϸ� ����                                           -- INOUT ���ϰ� ���ؼ� ��� ���� �ǰ�
  . '����Ʈ��' : ����ڰ� �Ű������� ����ϰ� ���� �������� �ʾ��� �� �ڵ����� �Ҵ�� ��   -- ������� �ǰ�
  
  (���๮)
  EXECUTE|EXEC ���ν�����[(�Ű�����list)];
  �Ǵ� ���ν����� �ٸ� ��Ͽ��� ������ ���
  ���ν�����[(�Ű�����list)];    -- OUT �Ű����� �϶� ..?
  
��� ��) �μ���ȣ�� �Է¹޾� �ش�μ��� �μ����� �̸�, ��å, �μ���, �޿��� ����ϴ� ���ν����� �ۼ��Ͻÿ�
    CREATE OR REPLACE PROCEDURE PROC_EMP01(
        P_DID IN HR.DEPARTMENTS.DEPARTMENT_ID%TYPE)
    IS
        V_NAME VARCHAR2(100);
        V_JOBID HR.JOBS.JOB_ID%TYPE;
        V_DNAME VARCHAR2(100);
        V_SAL NUMBER := 0;
    BEGIN
        SELECT  B.EMP_NAME, B.JOB_ID, A.DEPARTMENT_NAME, B.SALARY
        INTO    V_NAME, V_JOBID, V_DNAME, V_SAL
        FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
        WHERE   A.DEPARTMENT_ID = P_DID
        AND     A.MANAGER_ID = B.EMPLOYEE_ID;
        
        DBMS_OUTPUT.PUT_LINE('�μ��ڵ� : '||P_DID);
        DBMS_OUTPUT.PUT_LINE('�μ��� : '||V_NAME);
        DBMS_OUTPUT.PUT_LINE('���� : '||V_JOBID);
        DBMS_OUTPUT.PUT_LINE('�μ��� : '||V_DNAME);
        DBMS_OUTPUT.PUT_LINE('�޿� : '||V_SAL);
    END;
    
    (����)
    EXECUTE PROC_EMP01(60);
    
��� ��) �⵵�� ���� �Է¹޾� �ش� �Ⱓ�� ���帹�� ���ž��� ����� ȸ�������� ��ȸ 
        Alias ȸ����ȣ, ȸ����, ���űݾ�, �ּ�
    (���ν���)
        �Է� : �⵵�� ��
        ó�� : CART ���̺��� �ִ뱸�ž��� ����� ȸ����ȣ, ���ž� �հ� ���
        ��� : ȸ����ȣ, ���ž� �հ�
    (����)
        �Է� : ȸ����ȣ, ���ž� �հ�
        ó�� : MEMBER ���̺��� ȸ����ȣ, ȸ����, �ּҸ� �˻�
        ��� : ȸ����ȣ, ȸ����, �ּ�, ���ž� �հ�
        
CREATE OR REPLACE PROCEDURE PROC_CART01(
    P_PERIOD IN VARCHAR2,   --�⵵�� ��
    P_MID OUT MEMBER.MEM_ID%TYPE,   --ȸ����ȣ
    P_SUM OUT NUMBER)   --���ž� �հ�
IS
BEGIN
    SELECT  TA.CID, TA.CSUM
    INTO    P_MID, P_SUM
    FROM    (
            SELECT  A.CART_MEMBER AS CID,
                    SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM
            FROM    CART A, PROD B
            WHERE   A.CART_PROD = B.PROD_ID
            AND     SUBSTR(A.CART_NO,1,6) = P_PERIOD
            GROUP   BY  A.CART_MEMBER
            ORDER   BY  2 DESC) TA
    WHERE   ROWNUM = 1;    
END;

DECLARE
    V_MID MEMBER.MEM_ID%TYPE;
    V_SUM NUMBER := 0;
    V_ADDR  VARCHAR2(100);
    V_NAME  MEMBER.MEM_NAME%TYPE;
BEGIN
    PROC_CART01('202005',V_MID,V_SUM);
    SELECT  MEM_NAME, MEM_ADD1||' '||MEM_ADD2 
    INTO    V_NAME, V_ADDR
    FROM    MEMBER
    WHERE   MEM_ID=V_MID;
    DBMS_OUTPUT.PUT_LINE('ȸ����ȣ :'||V_MID);
    DBMS_OUTPUT.PUT_LINE('ȸ���� :'||V_NAME);
    DBMS_OUTPUT.PUT_LINE('�ּ� :'||V_ADDR);
    DBMS_OUTPUT.PUT_LINE('���ž� �հ� :'||V_SUM);
END;

��� ��) ������ '�ڿ���'�� ȸ����ȣ�� �Է� �޾� 2020�� ��ݱ�(1-6��) ������Ȳ�� ����ϴ� ���ν����� �ۼ�
        Alias ȸ����ȣ, ȸ����, ���űݾ� �հ�
        
CREATE OR REPLACE PROCEDURE PROC_MEM01(
    P_JOB IN VARCHAR2,   
    P_MID OUT MEMBER.MEM_ID%TYPE,   
    P_SUM OUT NUMBER)  
IS
    V_JOB MEMBER.MEM_JOB%TYPE;
BEGIN
    SELECT  
    FROM    (
            SELECT  A.MEM_ID AS MID
            FROM    MEMBER A, CART B
            WHERE   A.MEM_ID = B.CART_MEMBER
            AND     A.MEM_JOB = '�ڿ���') TA
    WHERE   
END;

��� ��) ���� �ڷḦ �Ǹ��� ��� ����ó���� ���ν����� �ۼ��Ͻÿ�
        �Ǹ��ڷ�
        -------------------------------------------------
         ����ȸ����ȣ        ��¥        ��ǰ�ڵ�        ����
        -------------------------------------------------
            n001       2020-07-28   P102000005       3

    -- 1.CART ���̺� ���    2.���    3.���ϸ���    
CREATE OR REPLACE PROCEDURE PROC_CART_INPUT(
    P_MID IN MEMBER.MEM_ID%TYPE,   
    P_DATE IN DATE,
    P_PID PROD.PROD_ID%TYPE,
    P_QTY NUMBER)  
IS
    V_CART_NO CART.CART_NO%TYPE;
    V_FLAG NUMBER := 0;
    V_DAY CHAR(9) := TO_CHAR(P_DATE,'YYYYMMDD')||'%';
BEGIN
    --CART�� ����
    SELECT  COUNT(*)            --�ڷᰡ �ִ��� Ȯ��(���� 0����)
    INTO    V_FLAG
    FROM    CART
    WHERE   CART_NO LIKE V_DAY;
    
    IF  V_FLAG = 0 THEN         --�ڷᰡ ������
        V_CART_NO := TO_CHAR(P_DATE,'YYYYMMDD')||TRIM('00001');
    ELSE
        SELECT  MAX(CART_NO) + 1 
        INTO    V_CART_NO
        FROM    CART
        WHERE   CART_NO LIKE V_DAY;
    END IF;
    
    INSERT INTO CART VALUES(P_MID, V_CART_NO, P_PID, P_QTY);
    COMMIT;    
    --�������
    UPDATE  REMAIN A
    SET     A.REMAIN_O = A.REMAIN_O+P_QTY, 
            A.REMAIN_J_99 = A.REMAIN_J_99 - P_QTY, 
            A.REMAIN_DATE = P_DATE
    WHERE   A.PROD_ID = P_PID
    AND     A.REMAIN_YEAR = '2020';
    
    COMMIT;   
    --���ϸ��� �ο�
    UPDATE  MEMBER A
    SET     A.MEM_MILEAGE = (
                            SELECT  A.MEM_MILEAGE + B.PROD_MILEAGE * P_QTY
                            FROM    PROD B
                            WHERE   B.PROD_ID = P_PID)
    WHERE   A.MEM_ID = P_MID;
    
    COMMIT;
END;
    
EXECUTE PROC_CART_INPUT('n001', TO_DATE('20200728'), 'P102000005', 3);