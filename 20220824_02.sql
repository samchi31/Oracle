2022-0824-02) ROLLUP�� CUBE
 - �پ��� �������� ��� ���� ���
 - �ݵ�� GROUP BY ���� ���Ǿ�� ��
  
 1) ROLLUP
  . LEVEL�� ���� ����� ��ȯ
  (�������)
  GROUP BY [�÷�,] ROLLUP(�÷���1[,�÷���2,...,�÷Ÿ�n])[,�÷�]
  - �÷���1���� �÷���n�� �����÷����� �հ� ��� �� �����ʺ��� �÷��� �ϳ��� ������ �������� ����
  - ���� �������� ��ü����(��� �÷����� ������ ���) ��ȯ
  - ROLLUP �� �Ǵ� �ڿ� �÷��� �� �� ���� => �κ� ROLLUP �̶� ��
  
��� ��) 2020�� 4-7�� ����, ȸ����, ��ǰ�� ���ż����հ踦 ��ȸ
    (ROLLUP ��� ��)
    SELECT  SUBSTR(CART_NO,5,2) AS ��,
            CART_MEMBER AS ȸ����ȣ,
            CART_PROD AS ��ǰ�ڵ�,
            SUM(CART_QTY) AS ���ż����հ�
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007'
    GROUP   BY SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD
    ORDER   BY 1;
    
    (ROLLUP ���)
    SELECT  SUBSTR(CART_NO,5,2) AS ��,
            CART_MEMBER AS ȸ����ȣ,
            CART_PROD AS ��ǰ�ڵ�,
            SUM(CART_QTY) AS ���ż����հ�
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007'
    GROUP   BY ROLLUP(SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD) -- �÷� ���� n�� -> ��µǴ� ���� ���� n��
    ORDER   BY 1;