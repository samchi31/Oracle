2022-0822-02) �����Լ�
 - ��� �����͸� Ư�� �÷��� �������� �׷����� �����Ͽ� �� �׷쿡 ���Ͽ�
   �հ�(SUM), ���(AVG), �ڷ� ��(COUNT), �ִ밪(MAX), �ּҰ�(MIN)�� ��ȯ�ϴ� �Լ�
   
�������)
 SELECT [�÷���1 [,]
            :
        [�÷���n]
        SUM|AVG|COUNT|MAX|MIN
 FROM   ���̺���
 [WHERE] ����
 [GROUP BY �÷���1,...�÷���n]
 [HAVING ����]
 
 - SELECT ������ �����Լ��� ���� ��쿡�� GROUP BY ���� ����� �ʿ����
 - SELECT ���� �����Լ� �̿��� �÷��� ����� ��� (�Ϲ��Լ� ����) �ݵ�� GROUP BY ���� ����Ǿ�� �ϰ�
   GROUP BY ������ ��� �Ϲ��÷��� ','�� �����Ͽ� ����ؾ���
 - SELECT ���� ������ ���� �÷��� GROUP BY ���� ��� ����
 - �����Լ��� ������ �ο��� ������ �ݵ�� HAVING ���� ���� ó���� �����ؾ� ��
 
 1) SUM(column | expr)
  . ����� �÷��� ���̳� ������ ����� ��� ���� ��� ��ȯ
  . 