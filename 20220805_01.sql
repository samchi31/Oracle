2022-0805-01) ������ Ÿ��
    - ����Ŭ���� ���ڿ�, ����, ��¥, ������ �ڷ�Ÿ���� ����
    1. ���� ������ Ÿ��
     . ����Ŭ�� �����ڷ�� ''�ȿ� ����� �ڷ�
     . ��ҹ��� ����
     . CHAR, VARCHAR, VARCHAR2, NVARCHAR2, LONG, CLOB, NCLOB ���� ������
     1) CHAR(n[BYTE|CHAR])
      - �������� ���ڿ� ���� (�������̴� ����ڰ� ���̸� ����, ũ�⸸ŭ �� ����(������) ����, ũ�⺸�� ũ�� ����)
      - �ִ� 2000BYTE���� ���尡�� (������ ����)
      - 'n[BYTE|CHAR]' : '[BYTE|CHAR]'�� �����Ǹ� BYTE�� ���
        'CHAR'�� n���ڼ� ���� ����
      - �ѱ� �� ���ڴ� 3BYTE�� ���� (char�� 1����)
      - �⺻Ű�� ���̰� ������ �ڷ�(�ֹι�ȣ, �����ȣ)�� ���缺�� Ȯ���ϱ� ���� ���
      - VARCHAR �� ��������, VARCHAR2 �� ����Ŭ������ ����ϴ� VARCHAR,
        NVARCHAR2 �� ���� ��� ��ȯ(national), LONG 2�Ⱑ����Ʈ ���ڿ�, 
        CLOB 4�Ⱑ����Ʈ ���ڿ�
��� ��)
CREATE TABLE TEMP01(
    COL1 CHAR(10),
    COL2 CHAR(10 BYTE),
    COL3 CHAR(10 CHAR));
- �����ϱ�
INSERT INTO TEMP01 VALUES('����', '���ѹ�', '���ѹα�');
- ũ�� Ȯ���ϱ� (LENGTHB:����Ʈ����)
SELECT LENGTHB(COL1) AS COL1,
       LENGTHB(COL2) AS COL2,
       LENGTHB(COL3) AS COL3 
  FROM TEMP01;
    '���ѹα�':18BYTE => (10char - 4char) + 4char * 3
    
     2) VARCHAR2(n[BYTE|CHAR])
      - �������� ���ڿ� �ڷ� ����
      - �ִ� 4000BYTE ���� ���� ����
      - VARCHAR, NVARCHAR2(UTF8,UTF16 �������� ����) �� �������� ����      
��� ��)
CREATE TABLE TEMP02(
    COL1 CHAR(20), 
    COL2 VARCHAR2(2000 BYTE),
    COL3 VARCHAR2(4000 CHAR));
    
INSERT INTO TEMP02 VALUES('ILPOSTINO', 'BOYHOOD', '����ȭ ���� �Ǿ����ϴ�-������');
SELECT * FROM TEMP02;
SELECT LENGTHB(COL1) AS COL1, --����Ʈ��
       LENGTHB(COL2) AS COL2,
       LENGTHB(COL3) AS COL3,
       LENGTH(COL1) AS COL1, --���ڼ�
       LENGTH(COL2) AS COL2,
       LENGTH(COL3) AS COL3 
  FROM TEMP02;

     3) LONG
      - �������� ���ڿ� �ڷ� ����
      - �ִ� 2GB ���� ���� ����
      - �� ���̺� �� �÷��� LONG Ÿ�� ��� ����
      - ���� ��� �������� ����(����Ŭ 8i) => CLOB�� UPGRADE      
      (�������)
      �÷��� LONG
       . LONG Ÿ������ ����� �ڷḦ �����ϱ� ���� �ּ� 31bit�� �ʿ�
        => �Ϻ� ���(LENGTHB, SUBSTR ���� �Լ�)�� ����
       . SELECT ���� SELECT ��, UPDATE �� SET ��, INSERT ���� VALUES ������ ��� ����
  
��� ��)
CREATE TABLE TEMP03(
    COL1 VARCHAR2(2000),
    COL2 LONG); --LONG ����� ����
    
INSERT INTO TEMP03 VALUES('������ �߰� ���� 846','������ �߰� ���� 846');
SELECT * FROM TEMP03;
SELECT SUBSTR(COL1,8,3)    -- COL1���� 8��°���� 3����
       --SUBSTR(COL2,8,3)     -- LONG Ÿ���� ��� X
       --LENGTHB(COL2)
  FROM TEMP03;
  
     4) CLOB(Character Large Objects)
      - ��뷮�� �������� ���ڿ� ����
      - �ִ� 4GB���� ó�� ����
      - �� ���̺� �������� CLOB Ÿ�� ���� ����
      - �Ϻ� ����� DBMS_LOB API(Application Programming Interface)���� �����ϴ� �Լ� ���
      (��� ����)
      �÷��� CLOB
      
��� ��)
CREATE TABLE TEMP04(
    COL1 VARCHAR2(255),
    COL2 CLOB,
    COL3 CLOB);
    
INSERT INTO TEMP04 VALUES('APPLE BANANA PERSIMMON','APPLE BANANA PERSIMMON','APPLE BANANA PERSIMMON');
SELECT * FROM TEMP04;
SELECT SUBSTR(COL1,7,6) AS COL1,
       SUBSTR(COL3,7,6) AS COL3,        -- CLOB �� ó�� ������ ������ �� SUBSTR ����
       --LENGTHB(COL2) AS COL4,
       DBMS_LOB.GETLENGTH(COL2) AS COL4,    -- ���� �� ��ȯ
       DBMS_LOB.SUBSTR(COL2,7,6) AS COL2  -- COL2���� 6��°���� 7����   
  FROM TEMP04;
  