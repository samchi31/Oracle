2022-0901-02) 집합연산자
 - SELECT 문의 결과를 대상으로 집합연산 수행
 - UNION ALL, UNION, INTERSECT, MINUS 연산자 제공    -- 중복 배제 안하면 ALL
 - 집합연산자로 연결되는 SELECT 문의 각 SELECT 절의 컬럼의 갯수와 데이터 타입을
   일치해야 함
 - ORDER BY 절은 맨 마지막 SELECT 문에만 사용 가능
 - BLOB, CLOB, BFILE 타입의 컬럼은 집합 연산자를 사용할 수 없음
 - UNION, INTERSECT, MINUS 연산자는 LONG 타입형 컬럼에 사용할 수 없음
 - GROUPING SETS(col1, col2,...) => UNION ALL 개념이 포함된 형태
   ex) GROUPING SETS(col1, col2, col3) 
       => ((GROUP BY col1) UNION ALL (GROUP BY col2) UNION ALL (GROUP BY col3))
       
1) UNION ALL
 - 중복을 허용한 합집합의 결과를 반환
 
사용 예) 회원테이블에서 직업이 주부인 회원과 마일리지가 3000 이상인 모든 회원들의
        회원번호, 회원명, 직업, 마일리지를 조회하시오 -- 주부 U 마일리지>=3000
    
    SELECT  MEM_ID AS 회원번호, 
            MEM_NAME AS 회원명, 
            MEM_JOB AS 직업, 
            MEM_MILEAGE AS 마일리지
    FROM    MEMBER
    WHERE   MEM_JOB='주부'
UNION   ALL
    SELECT  MEM_ID,         -- 두번째 SELECT 문은 별칭 생략가능
            MEM_NAME, 
            MEM_JOB, 
            MEM_MILEAGE     -- MEM_REGNO1  -- 데이터 타입이 같아야함, 컬럼 갯수도 같야아함
    FROM    MEMBER
    WHERE   MEM_MILEAGE>=3000;
    
사용 예) 2020년 4,5,6,7월 구매액이 가장 많은 회원들의 회원번호, 회원명, 구매금액합계를 조회하시오
    (WITH 절을 사용한 경우)    -- MAX(SUM()) 가 불가능 하므로 UNION으로
    WITH T1 AS              -- WITH : 미리 결과 테이블에 이름을 짓는것  --T1이라는 테이블 생성
        (SELECT '4월' AS MON,        
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202004%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1      -- ORDER BY 후 ROWNUM=1을 구해야 하므로 바깥 WHERE 절에 기술
         
         UNION  ALL        -- UNION 을 써도 상관없다
         
         SELECT '5월' AS MON,
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202005%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1
         
         UNION  ALL
         
         SELECT '6월' AS MON,
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202006%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1         
         
         UNION  ALL
         
         SELECT '7월' AS MON,
                C.MEM_ID AS CID,
                C.MEM_NAME AS CNAME,
                D.TOT1 AS CTOT1
         FROM   (SELECT A.CART_MEMBER AS AMID,
                        SUM(A.CART_QTY*B.PROD_PRICE) AS TOT1
                 FROM   CART A, PROD B
                 WHERE  A.CART_NO LIKE '202007%'
                 AND    A.CART_PROD = B.PROD_ID
                 GROUP  BY A.CART_MEMBER
                 ORDER  BY  2 DESC) D, MEMBER C
         WHERE  C.MEM_ID = D.AMID
         AND    ROWNUM = 1
         ) -- (SELECT ~ ) T1을 만드는 부분
    SELECT  MON AS 월,
            CID AS 회원번호,
            CNAME AS 회원명,
            CTOT1 AS 구매금액
    FROM    T1;
    
사용 에) 6월과 7월에 판매된 모든 상품을 중복하지 않고 출력하시오
        Alias 상품코드, 상품명
    
    SELECT  DISTINCT A.CART_PROD AS 상품코드,
            B.PROD_NAME AS 상품명
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     A.CART_NO LIKE '202006%'
UNION 
    SELECT  DISTINCT A.CART_PROD AS 상품코드,
            B.PROD_NAME AS 상품명
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     A.CART_NO LIKE '202007%'
    ORDER   BY  1;          -- ORDER BY는 한번만
    
2) INTERSECT
 - 교집합(공통부분)의 결과 반환
 
사용 예) 2020년 매입상품 중 1월과 5월에 모두 매입된 상품의
        상품코드, 상품명, 매입처명을 조회하시오
        
    SELECT  DISTINCT A.BUY_PROD AS 상품코드, 
            C.PROD_NAME AS 상품명, 
            B.BUYER_NAME AS 매입처명
    FROM    BUYPROD A, BUYER B, PROD C
    WHERE   A.BUY_PROD = C.PROD_ID
    AND     C.PROD_BUYER = B.BUYER_ID
    AND     A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
INTERSECT
    SELECT  DISTINCT A.BUY_PROD AS 상품코드, 
            C.PROD_NAME AS 상품명, 
            B.BUYER_NAME AS 매입처명
    FROM    BUYPROD A, BUYER B, PROD C
    WHERE   A.BUY_PROD = C.PROD_ID
    AND     C.PROD_BUYER = B.BUYER_ID
    AND     A.BUY_DATE BETWEEN TO_DATE('20200501') AND TO_DATE('20200531')
    ORDER   BY  1;
    
사용 예) 1월 매입상품 중 5월 판매 5위 안에 존재하는 상품정보를 조회    

    WITH T1 AS
        (--(1월 매입상품)
        SELECT  BUY_PROD
        FROM    BUYPROD 
        WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
        
    INTERSECT
        --(5월 판매 수량기준 1-5위 상품)
        SELECT  A.CART_PROD
        FROM    (SELECT CART_PROD,
                        SUM(CART_QTY)
                 FROM   CART
                 WHERE  CART_NO LIKE '202005%'
                 GROUP  BY  CART_PROD
                 ORDER  BY  2 DESC) A
        WHERE   ROWNUM <= 5
        )    
    SELECT  BUY_PROD AS 상품코드, 
            PROD_NAME AS 상품명
    FROM    T1, PROD
    WHERE   T1.BUY_PROD = PROD_ID;