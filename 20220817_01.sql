2022-0817-01) �Լ�
 - ����Ŭ�翡�� �̸� �ۼ� �� �������Ͽ� ���� ������ ����
   ���α׷� ���
 - �Լ��� ��ȯ ���� ����
 - ����
    . �������Լ� : ���̺� ����� ���� ���� ������� �����Ͽ� �ϳ��� ����� ��ȯ
                 SELECT, WHERE, ORDER BY ���� ��� ����
                 ��ø��� ����
                 ���ڿ�, ����, ��¥, ����ȯ, NULLó�� �Լ� ������ �з�
    . �������Լ� : ���� ����� �׷�ȭ�Ͽ� �� �׷쿡 ���� ���� ����� ��ȯ
                 ��ø��� �Ұ�        -- ���� + ���� �� ��ø ����
                 GROUP BY ���� ����ؾ� ��
                 SUM, AVG, COUNT, MIN, MAX ���� ����    -- �׷��Լ� 5�� �� �ܿ��
                 
1. ���ڿ� �Լ�
 1) CONCAT(c1, c2)
    - �־��� �� ���ڿ� c1�� c2�� �����Ͽ� ���ο� ���ڿ��� ��ȯ
    - ���ڿ� ���տ����� '||'�� ���� ���
    
��� ��) ȸ�����̺��� ����ȸ���� ȸ����ȣ, ȸ����, �ֹι�ȣ, ������ ���
        ��, �ֹι�ȣ�� 'XXXXXX-XXXXXXX'�������� ���
    ('||' ���)
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����, 
           MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
           MEM_JOB AS ����
    FROM   MEMBER
    WHERE  SUBSTR(MEM_REGNO2,1,1) IN ('2','4');
    (CONCAT ���)     -- �����ؼ� ���� ��� ����
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����, 
           CONCAT(CONCAT(MEM_REGNO1, '-'),MEM_REGNO2) AS �ֹι�ȣ, 
           MEM_JOB AS ����
    FROM   MEMBER
    WHERE  SUBSTR(MEM_REGNO2,1,1) IN ('2','4');

 2) LOWER(c1), UPPER(c1), INITCAP(c1) 
    - �빮�ڸ� �ҹ��ڷ�(LOWER), �ҹ��ڸ� �빮�ڷ�(UPPER), �ܾ��� ù ���ڸ� �빮�ڷ�(INITCAP) �ٲپ� �ִ� �Լ�
    - �ַ� �ҹ���(�빮��)�� ���� ���� �������� ������ �÷� ���� ��ȸ�ϰų�(LOWER,UPPER),
      �̸� ���� ����(INITCAP)�� �� ���
      
��� ��) ��ǰ�� �з��ڵ尡 'p202'�� ���� �з���� ��ǰ�� ���� ���       --���̺� 2�� ���(LPROD:�з���, PROD:�з��ڵ�)
    -- JOIN ���(���赥���ͺ��̽����� ���) / �� ���� ���� �÷����� ���� �Ӽ����� ��
    SELECT B.LPROD_NM AS �з���, 
           COUNT(*) AS "��ǰ�� ��"        --��Ī�� ���� ���� �� �ֵ���ǥ
    FROM   PROD A, LPROD B              --���̺� ��Ī (AS ��� X)
    WHERE  A.PROD_LGU = B.LPROD_GU      --���̺� �� �� ��� �� WHERE �ʼ�
      AND  LOWER(A.PROD_LGU) = 'p202'
    GROUP  BY B.LPROD_NM;
    
��� ��)
    SELECT  EMPLOYEE_ID AS �����ȣ,
            EMP_NAME AS �����,
            LOWER(EMP_NAME),
            UPPER(EMP_NAME),
            INITCAP(LOWER(EMP_NAME))
    FROM    HR.EMPLOYEES;
    
    SELECT  LOWER(EMAIL)||'@gmail.com' AS �̸����ּ�
    FROM    HR.EMPLOYEES;
    
 3) LPAD(c1,n[,c2]), RPAD(c1,n[,c2])
    - LPAD : �־��� ���ڿ� c1�� ������ �������� n�� �����ʺ��� �����ϰ� ���� ������ c2 ���ڿ� ���ʿ� ����
             �� c2�� �����Ǹ� ������ ����
             ��ǥ��ȣ���ڷ� �ַ� ���
    - RPAD : �־��� ���ڿ� c1�� ������ �������� n�� ���ʺ��� �����ϰ� ���� ������ c2 ���ڿ� �����ʿ� ����
             �� c2�� �����Ǹ� ������ ����
             
��� ��) 
    SELECT  LPAD('������ �߱�', 20, '*'),
            LPAD('������ �߱�', 20),
            RPAD('������ �߱�', 20, '*'),
            RPAD('������ �߱�', 20)
    FROM    DUAL;

��� ��) ȸ�����̺��� ���ϸ����� ���� ȸ�� 3���� 2020�� 4-6�� ������ ������ ��ȸ�Ͻÿ�
        �÷��� ȸ����ȣ, ȸ����, ���ϸ���, ���űݾ��հ� �̴�.
    SELECT  A.MEM_ID AS ȸ����ȣ,
            A.MEM_NAME AS ȸ����,
            A.MEM_MILEAGE AS ���ϸ���,
            F.FSUM AS ���űݾ��հ�
    FROM    MEMBER A,
            (SELECT E.CART_MEMBER AS CMID,
                    SUM(E.CART_QTY*D.PROD_PRICE) AS FSUM
             FROM   (SELECT C.MEM_ID AS DMID
                     FROM   (SELECT MEM_ID, MEM_MILEAGE
                             FROM   MEMBER
                             ORDER  BY 2 DESC) C
                     WHERE ROWNUM <= 3) B,
                    PROD D,
                    CART E
             WHERE   B.DMID = E.CART_MEMBER
             AND     D.PROD_ID = E.CART_PROD
             AND     SUBSTR(E.CART_NO,1,6) BETWEEN '202004' AND '202006'
             GROUP   BY E.CART_MEMBER) F
    WHERE   F.CMID = A.MEM_ID;
    
 DECLARE
    CURSOR  CUR_MILE IS
    SELECT  C.MEM_ID AS DMID,
            C.MEM_MILEAGE AS DMILE,
            C.MEM_NAME AS DNAME
    FROM    (SELECT MEM_ID, MEM_MILEAGE, MEM_NAME
             FROM   MEMBER
             ORDER  BY 2 DESC) C
    WHERE   ROWNUM <= 3;
    V_SUM NUMBER:=0;
    V_RES   VARCHAR2(100);
 BEGIN
    FOR REC IN CUR_MILE LOOP
        SELECT  SUM(A.CART_QTY * B.PROD_PRICE) INTO V_SUM
        FROM    CART A, PROD B
        WHERE   A.CART_MEMBER = REC.DMID
        AND     SUBSTR(A.CART_NO,1,6) BETWEEN '202004' AND '202006'
        AND     A.CART_PROD = B.PROD_ID;    
        V_RES:=REC.DMID||' '||REC.DNAME||' '||REC.DMILE||LPAD(V_SUM,12);   --TO_CHAR(V_SUM,'99,999,999');
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END LOOP;
 END;
