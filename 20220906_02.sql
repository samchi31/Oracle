2022-0906-02) Ŀ��(CURSOR)
 - Ŀ���� SQL �� DML �������� ������� ����� ����
 - SELECT ���� ��� ����
 - ������ Ŀ���� ������ Ŀ���� ����
 1) ������ Ŀ��          -- ��
  . �̸��� ���� Ŀ��
  . �׻� Ŀ���� CLOSE �Ǿ� ����
  . �����ڰ� Ŀ�� ���ο� ������ �� ����
  . Ŀ���Ӽ�
--------------------------------------------------
    �Ӽ�              �ǹ�
--------------------------------------------------
 SQL%ISOPEN     Ŀ���� OPEN �Ǿ����� ��(true) ��ȯ �׻� false ��
 SQL%FOUND      Ŀ���� ���ο� FETCH �� �ڷᰡ �����ϸ� ��(true)       -- �ݺ��� �������� ���
 SQL%NOTFOUND   Ŀ�� ���ο� FETCH �� �ڷᰡ ������ ��(true)          -- �ݺ��� �������� ���
 SQL%ROWCOUNT   Ŀ�� ������ ���� �� ��ȯ
 
 2) ������ Ŀ��
  . �̸��� �ο��� Ŀ��
  . ������ Ŀ�� �Ӽ����� 'SQL' ��� Ŀ������ ���
  . Ŀ���� �������
    Ŀ������(���𿵿�) => Ŀ�� OPEN => FETCH(�ݺ����� ����) => CLOSE
    ��, FOR ���� ���Ǵ� Ŀ���� OPEN, FETCH, CLOSE ������ ���ʿ�
  (1) Ŀ�� ����         -- Ŀ�� ������ �ݺ��� ���
   CURSOR Ŀ����[(������ ������Ÿ��[,...])] IS     -- BIND ���� -> ũ�� ���� X
    SELECT ��
    
��� ��) ������̺����� �μ���ȣ�� �Է¹޾� �� �μ��� ���� ��������� ����ϴ� Ŀ�� �ۼ�

DECLARE
    CURSOR  EMP_CUR(P_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS
        SELECT  EMPLOYEE_ID, EMP_NAME, HIRE_DATE, SALARY
        FROM    HR.EMPLOYEES
        WHERE   DEPARTMENT_ID = P_DID;
BEGIN
END;

  (2) Ŀ�� OPEN
   - Ŀ���� ����ϱ� ���� Ŀ���� OPEN �ؾ��ϸ� OPEN �� Ŀ����
     �ݵ�� CLOSE �Ǿ�� �� OPEN �� �� ����
     
   (�������)
   OPEN    Ŀ����[(�Ű�����list)];
    . �Ű�����list : Ŀ�� ���𹮿� ���� �Ű������� ���޵� ���� ���� ���
     
  (3) Ŀ�� FETCH
   - Ŀ���� �����ϴ� �����͸� ������� �о���� ����
   - ���� �ݺ����� ���ο� ����
   (�������)
   FETCH    Ŀ���� INTO ����list;
    . '���� list' : Ŀ���� �÷��� ���� ���޹��� ������ ���
   
   (4) Ŀ�� CLOSE
    - ����� �Ϸ�� Ŀ���� ����
    (�������)
    CLOSE   Ŀ����;
     . OPEN �� Ŀ���� �ݵ�� CLOSE �ؾ� ��
     . CLOSE ���� ���� Ŀ���� �ٽ� OPEN �� �� ����
     

     