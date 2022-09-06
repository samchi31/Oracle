2022-0905-03) �ε���(INDEX) ��ü
 - �ڷ�˻��� ȿ�������� �����ϱ� ���� ��ü
 - DBMS�� ���ɰ����� ����
 - B-TREE ������ ����Ǿ� ���� �ð��ȿ� ��� �ڷ� �˻��� �㺸��
 - ������ �˻�, ����, ���� �� �ʿ��ڷ� ������ ȿ���� ����
 - ���İ� �׷�ȭ�� ���� ������ ����
 - �ε��� ������ �ڿ��� ���� �ҿ��
 - �������� ������ ������ �߻��Ǹ� �ε������� ���ſ� ���� �ð� �ҿ�
 - �ε����� ����
  . Unique/Non Unique Index -- Unique : Ű�� �ߺ� X(NULL����)
  . Single/Composite Index  -- Single : �� �÷� �������� Ű
  . Normal/Bitmap/Function-Based Normal Index   -- Normal : B-TREE COLUMN�� ��
                                                -- Bitmap : ���� ���� ������
                                                -- Function-Based : �Լ� ������� Ű ��
 (�������)
 CREATE [UNIQUE|BITMAP] INDEX �ε�����
 ON     ���̺��(�÷���[,�÷���,...])[ASC|DESC]
 
��� ��) ȸ�����̺��� �̸��÷����� �ε����� �����Ͻÿ�
    
    CREATE INDEX    IDX_NAME
    ON MEMBER(MEM_NAME);
    
    SELECT  *
    FROM    MEMBER
    WHERE   MEM_NAME = '������';
    
    DROP INDEX  IDX_NAME;

COMMIT;

    CREATE INDEX    IDX_REGNO
    ON  MEMBER(SUBSTR(MEM_REGNO2,2,4)); -- Function-Based Normal
    
    SELECT  *
    FROM    MEMBER
    WHERE   SUBSTR(MEM_REGNO2,2,4) = '4558';
    
1. �ε��� �籸��
 - �ε��� ������ �ٸ� ���̺� �����̽��� �̵� �� ��
 - ������Ʈ�� ���� ���� �۾��� ���� ����� ���� �ε����� �籸�� �ؾ� �ϴ� ���
 (�������)
 ALTER  INDEX   �ε�����    REBUILD;
 