2022-0824-01) 집계함수
사용 예) 장바구니 테이블에서 2020년 5월 제품별 판매집계를 조회하시오
        Alias 제품코드, 판매건수, 판매수량, 금액

    SELECT  A.CART_PROD AS 제품코드, -- 외래키라서 A.CART_PROD B.PROD_ID 둘 중 아무거나 사용 가능
            COUNT(*) AS 판매건수, 
            SUM(A.CART_QTY) AS 판매수량, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS 금액
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '202005%'
    AND     A.CART_PROD = B.PROD_ID             --조인 시 사용
    GROUP   BY A.CART_PROD
    ORDER   BY A.CART_PROD;
    
사용 예) 장바구니 테이블에서 2020년 5월 회원별 판매집계를 조회하시오
        Alias 회원번호, 구매수량, 구매금액
        
    SELECT  A.CART_MEMBER AS 회원번호, 
            SUM(A.CART_QTY) AS 구매수량, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS 구매금액
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '202005%'
    AND     A.CART_PROD = B.PROD_ID 
    GROUP   BY A.CART_MEMBER
    ORDER   BY 1;
        
사용 예) 장바구니 테이블에서 2020년 월별, 회원별 판매집계를 조회하시오
        Alias 월, 회원번호, 구매수량, 구매금액
        
    SELECT  SUBSTR(A.CART_NO,5,2) AS 월, 
            A.CART_MEMBER AS 회원번호, 
            SUM(A.CART_QTY) AS 구매수량, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS 구매금액
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '2020%'      -- SUBSTR(A.CART_NO,1,4) = '2020'
    AND     A.CART_PROD = B.PROD_ID 
    GROUP   BY SUBSTR(A.CART_NO,5,2), A.CART_MEMBER     -- GROUP 순서 중요
    ORDER   BY 1;
        
사용 예) 장바구니 테이블에서 2020년 5월 제품별 판매집계를 조회하되
        판매금액이 100만원 이상인 자료만 조회하시오
        Alias 제품코드, 판매수량, 금액
        
    SELECT  A.CART_PROD AS 제품코드, 
            SUM(A.CART_QTY) AS 판매수량, 
            SUM(A.CART_QTY * B.PROD_PRICE) AS 금액
    FROM    CART A, PROD B
    WHERE   A.CART_NO LIKE '202005%'
    --AND     A.CART_QTY * B.PROD_PRICE >= 1000000
    AND     A.CART_PROD = B.PROD_ID 
    GROUP   BY A.CART_PROD
    HAVING  SUM(A.CART_QTY * B.PROD_PRICE) >= 1000000   -- 집계함수가 조건에 있을 때, GROUP BY의 조건일 때 HAVING 사용
    ORDER   BY 1;
        
사용 예) 2020년 상반기(1-6월) 매입액 기준 가장 많이 매입된 상품 5개를 조회하시오
        Alias 상품코드, 매입수량, 매입금액
        
    SELECT  BUY_PROD AS 상품코드, 
            SUM(BUY_QTY) AS 매입수량, 
            SUM(BUY_COST * BUY_QTY) AS 매입금액
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    --AND     ROWNUM <= 5      --ROWNUM : 쿼리결과에서 오라클에서 자동으로 할당되는 PSEUDO COLUMN
    GROUP   BY BUY_PROD
    ORDER   BY 3 DESC;       --WHERE 절 실행 후 ORDER BY 실행되어서 원하는 결과를 얻을 수 없음
    
    --서브쿼리 사용
    SELECT  *
    FROM    (SELECT     BUY_PROD AS 상품코드, 
                        SUM(BUY_QTY) AS 매입수량, 
                        SUM(BUY_COST * BUY_QTY) AS 매입금액
             FROM    BUYPROD
             WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
             --AND     ROWNUM <= 5      --ROWNUM : 쿼리결과에서 오라클에서 자동으로 할당되는 PSEUDO COLUMN
             GROUP   BY BUY_PROD
             ORDER   BY 3 DESC)
    WHERE   ROWNUM <= 5 ;
    
사용 예) 2020년 상반기(1-6월) 매입액 기준 가장 많이 매입된 상품 1개를 조회하시오
        Alias 상품코드, 매입수량, 매입금액
        
    SELECT  BUY_PROD AS 상품코드, 
            SUM(BUY_QTY) AS 매입수량, 
            MAX(SUM(BUY_COST * BUY_QTY)) AS 매입금액    -- 집계함수 중복사용 불가
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    GROUP   BY BUY_PROD
    --HAVING  MAX(SUM(BUY_COST * BUY_QTY))
    ORDER   BY 3 DESC; 
    
문제] 사원테이블에서 부서별 평균급여를 조회

    SELECT  DEPARTMENT_ID AS 부서,
            ROUND(AVG(SALARY)) AS 평균급여
    FROM    HR.EMPLOYEES
    GROUP   BY DEPARTMENT_ID
    ORDER   BY 1;
    
문제] 사원테이블에서 부서별 가장 먼저 입사한 사원의 사원번호, 사원명, 부서번호, 입사일을 출력
    
    SELECT  B.EMPLOYEE_ID  AS 사원번호,
            B.EMP_NAME AS 사원명,
            A.DEPARTMENT_ID AS 부서번호,
            A.HDATE
    FROM   (SELECT DEPARTMENT_ID, 
                    MIN(HIRE_DATE) AS HDATE
            FROM    HR.EMPLOYEES
            GROUP   BY DEPARTMENT_ID) A,
            HR.EMPLOYEES B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID
    AND     A.HDATE = B.HIRE_DATE
    ORDER   BY 3;
    
    SELECT  EMPLOYEE_ID  AS 사원번호,
            EMP_NAME AS 사원명,
            DEPARTMENT_ID, 
            MIN(HIRE_DATE) AS HDATE
    FROM    HR.EMPLOYEES
    GROUP   BY EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID;    -- 집계함수가 사용 안된 속성은 전부 여기에

문제] 사원들의 평균급여보다 더 많이 받는 사원의 사원번호, 사원명, 부서번호, 급여를 출력
    
    SELECT  EMPLOYEE_ID AS 사원번호, 
            EMP_NAME AS 사원명, 
            DEPARTMENT_ID AS 부서번호, 
            SALARY AS 급여
    FROM    HR.EMPLOYEES
    WHERE   SALARY > (SELECT    AVG(SALARY)
                      FROM      HR.EMPLOYEES)
    ORDER   BY 4 DESC;    
    
문제] 회원테이블에서 남녀 회원별 마일리지 합계와 평균 마일리지를 조회하시오
     Alias 구분, 마일리지합계, 평균마일리지
     
    SELECT  CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1', '3')
                THEN    '남성회원'
                ELSE    '여성회원' 
                END     AS 구분, 
            COUNT(*)   AS 회원수,
            SUM(MEM_MILEAGE) AS 마일리지합계, 
            ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
    FROM    MEMBER
    GROUP   BY CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1', '3')
                THEN    '남성회원'
                ELSE    '여성회원' 
                END ;
    