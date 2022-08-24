2022-0824-02) ROLLUP과 CUBE
 - 다양한 집계결과를 얻기 위해 사용
 - 반드시 GROUP BY 절에 사용되어야 함
  
 1) ROLLUP
  . LEVEL별 집계 결과를 반환
  (사용형식)
  GROUP BY [컬럼,] ROLLUP(컬럼명1[,컬럼명2,...,컬렴명n])[,컬럼]
  - 컬럼명1부터 컬럼명n을 기준컬럼으로 합계 출력 후 오른쪽부터 컬럼을 하나씩 제거한 기준으로 집계
  - 제일 마지막은 전체집계(모든 컬럼명을 제거한 결과) 반환
  - ROLLUP 앞 또는 뒤에 컬럼이 올 수 있음 => 부분 ROLLUP 이라 함
  
사용 예) 2020년 4-7월 월별, 회원별, 상품별 구매수량합계를 조회
    (ROLLUP 사용 전)
    SELECT  SUBSTR(CART_NO,5,2) AS 월,
            CART_MEMBER AS 회원번호,
            CART_PROD AS 상품코드,
            SUM(CART_QTY) AS 구매수량합계
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007'
    GROUP   BY SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD
    ORDER   BY 1;
    
    (ROLLUP 사용)
    SELECT  SUBSTR(CART_NO,5,2) AS 월,
            CART_MEMBER AS 회원번호,
            CART_PROD AS 상품코드,
            SUM(CART_QTY) AS 구매수량합계
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007'
    GROUP   BY ROLLUP(SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD) -- 컬럼 개수 n개 -> 출력되는 집계 개수 n개
    ORDER   BY 1;