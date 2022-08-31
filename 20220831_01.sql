2022-0831-01) 서브쿼리
 - SQL 구문 안에 또 다른 SQL 구문이 존재하는 것을 의미
 - 알려지지 않은 조건에 근거하여 값들을 검색할 때 유용    -- 최종 결과 조회 : 메인쿼리
 - SELECT, DML, CREATE TABLE, VIEW 에 사용     -- CREATE 시 기본키 외래키는 복제가 안됨 -- SELECT 결과가 VIEW
 - 서브쿼리는 '( )'안에 기술 (단, INSERT INTO 에 사용되는 서브쿼리는 예외)
 - 분류
  . 일반서브쿼리, IN LINE 서브쿼리, 중첩서브쿼리    -- 위치:SELECT 절, FROM 절(혼자 실행가능해야함), WHERE 절
  . 관련상 있는 서브쿼리, 연관성 없는 서브쿼리    -- 조인 연결됨, 조인 연결안됨
  . 단일행(다중행) / 단일열(다중열) 서브쿼리        -- 연산자가 IN, OR, SOME, ANY, EXISTS 사용 : 다중행(결과가 복수)
  
1) 연관성 없는 서브쿼리
 - 메인쿼리에 사용된 테이블과 서브쿼리에 사용된 테이블 사이에 조인을 사용하지 않는 서브쿼리
 
사용 예) 사원테이블에서 사원들의 평균급여보다 많은 급여를 받는 사원을 조회
        Alias 사원번호, 사원명, 직책코드, 급여
    (중첩서브쿼리)
    SELECT  EMPLOYEE_ID AS 사원번호, 
            EMP_NAME AS 사원명, 
            JOB_ID AS 직책코드, 
            SALARY AS 급여
    FROM    HR.EMPLOYEES
    WHERE   SALARY > (--평균급여
                        SELECT  AVG(SALARY)
                        FROM    HR.EMPLOYEES)  -- 중첩서브쿼리는 관계연산자 오른쪽에만 기술 가능, 서브쿼리 많이 실행됨
    ORDER   BY  4 DESC;
    
    (IN-LINE 서브쿼리)                
    SELECT  A.EMPLOYEE_ID AS 사원번호, 
            A.EMP_NAME AS 사원명, 
            A.JOB_ID AS 직책코드, 
            A.SALARY AS 급여
    FROM    HR.EMPLOYEES A, (--평균급여
                            SELECT  AVG(SALARY) AS SAL  -- 서브쿼리 한번 실행됨 -> VIEW
                            FROM    HR.EMPLOYEES) B     -- 테이블 A, B 연관이 없다.
    WHERE   SALARY > B.SAL
    ORDER   BY  4 DESC;    
    
사용 예) 2017년 이후에 입사한 사원이 존재하는 부서를 조회하시오
        Alias 부서번호, 부서명, 관리사원번호
    (메인쿼리)
    SELECT  DISTINCT A.DEPARTMENT_ID AS 부서번호, 
            B.DEPARTMENT_NAME AS 부서명, 
            A.MANAGER_ID AS 관리사원번호
    FROM    HR.EMPLOYEES A, HR.DEPARTMENTS B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID
    AND     A.DEPARTMENT_ID IN (-- 2017년 이후에 입사한 사원이 존재하는 부서번호
                                SELECT  DISTINCT DEPARTMENT_ID
                                FROM    HR.EMPLOYEES
                                WHERE   HIRE_DATE > TO_DATE('20161231'))
    ORDER   BY 1;
                                
    SELECT  DISTINCT A.DEPARTMENT_ID AS 부서번호, 
            B.DEPARTMENT_NAME AS 부서명, 
            A.MANAGER_ID AS 관리사원번호
    FROM    HR.EMPLOYEES A, HR.DEPARTMENTS B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID
    AND     EXISTS (-- 2017년 이후에 입사한 사원이 존재하는 부서번호
                                SELECT  1
                                FROM    HR.EMPLOYEES C
                                WHERE   HIRE_DATE > TO_DATE('20161231')
                                AND     C.EMPLOYEE_ID = A.EMPLOYEE_ID)     -- 관련성 있는 쿼리
    ORDER   BY  1;
                                
                                
    
사용 예) 상품테이블에서 상품의 평균판매가보다 판매가가 더 높은 상품의 
        상품번호, 상품명, 분류명, 판매가를 조회하시오
    
    SELECT  A.PROD_ID AS 상품번호, 
            A.PROD_NAME AS 상품명, 
            C.LPROD_NM AS 분류명, 
            A.PROD_PRICE AS 판매가
    FROM    PROD A, (SELECT AVG(PROD_PRICE) AS BAVG
                    FROM    PROD) B,
                    LPROD C
    WHERE   A.PROD_PRICE > B.BAVG
    AND     C.LPROD_GU = A.PROD_LGU
    ORDER   BY  4;    
        
사용 예) 회원테이블에서 2000년 이전 출생한 회원의 마일리지보다 더 많은 마일리지를 보유한 회원의
        회원번호, 회원명, 주민번호, 마일리지를 조회   -- FROM 서브쿼리는 안됨
    
    SELECT  A.MEM_ID AS 회원번호, 
            A.MEM_NAME AS 회원명, 
            A.MEM_REGNO1||'-'||A.MEM_REGNO2 AS 주민번호, 
            A.MEM_MILEAGE AS 마일리지
    FROM    MEMBER A
    WHERE   A.MEM_MILEAGE > ALL(SELECT  MEM_MILEAGE AS MI
                                FROM    MEMBER
                                WHERE   MEM_BIR < TO_DATE('20000101'))
    ORDER   BY  4;
        
사용 예) 장바구니테이블에서 2020년 5월 회원별 최고 구매금액을 기록한 회원을 조회하시오
        Alias 회원번호, 회원명, 구매금액합계     -- (날짜에 회원별 구매금액 합 내림차순) -> 최고 구매금액 회원
        
    SELECT  TA.CID AS 회원번호, 
            M.MEM_NAME AS 회원명, 
            TA.CSUM AS 구매금액합계
    FROM    MEMBER M,
            (SELECT  A.CART_MEMBER AS CID,          --회원번호
                     SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM     --구매금액합계
            FROM    CART A, PROD B
            WHERE   A.CART_PROD = B.PROD_ID
            AND     A.CART_NO   LIKE    '202005%'
            GROUP   BY  A.CART_MEMBER
            ORDER   BY  2 DESC) TA
    WHERE   M.MEM_ID = TA.CID
    AND     ROWNUM = 1;     --행 1번
    
    (WITH 절 사용)
    WITH    A1 AS (SELECT   A.CART_MEMBER AS CID,          --회원번호
                            SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM     --구매금액합계
                    FROM    CART A, PROD B
                    WHERE   A.CART_PROD = B.PROD_ID
                    AND     A.CART_NO   LIKE    '202005%'
                    GROUP   BY  A.CART_MEMBER
                    ORDER   BY  2 DESC)
    SELECT  B.MEM_ID, B.MEM_NAME, A1.CSUM
    FROM    MEMBER B, A1
    WHERE   B.MEM_ID = A1.CID
    AND     ROWNUM = 1;