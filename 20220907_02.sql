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