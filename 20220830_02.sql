2020-0830-02) 외부조인(OUTER JOIN)
 - 내부조인은 조인조건을 만족하는 결과만 반환하지만, 
   외부조인은 자료가 부족한 테이블에 NULL행을 추가하여 조인을 수행    (자료 종류 수, 행의 수 아님)
 - 조인조건 기술 시 자료가 부족한 테이블의 컬럼 뒤에 외부조인 연산자 '(+)'를 추가 기술함
 - 외부조인 조건이 복수개일 때 모든 외부조인 조건에 모두 '(+)'연산자를 기술해야 함
 - 한번에 한 테이블에만 외부조인을 할 수 있음
   즉, A, B, C 테이블을 외부조인할 경우 A를 기준으로 B와 외부조인하고 동시에
   C를 기준으로 B를 외부조인할 수 없다(A=B(+) AND C=B(+)는 허용되지 않음)
 - 일반 외부조인에서 일반조건이 부여되면 정확한 결과가 반환되지 않은 => 서브쿼리를 사용한 외부조인
   또는 ANSI 외부 조인으로 해결해야 함
 - IN 연산자와 외부조인연산자('(+)')는 같이 사용할 수 없다
   (일반 외부조인 사용형식)
   SELECT   컬럼list
   FROM     테이블명1 [별칭1], 테이블명2 [별칭2],...
   WHERE    별칭1.컬럼명1 (+)= 별칭2.컬럼명2 => 테이블명1이 자료가 부족한 테이블인 경우
   
   (ANSI 외부조인 사용형식)
   SELECT   컬럼list
   FROM     테이블명1 [별칭1]
   RIGHT|LEFT|FULL  OUTER   JOIN    테이블명2 [별칭2] ON(조인조건1 [AND 일반조건1])
            :
   [WHERE   일반조건]   -- 일반조건도 거의 ON 절에 적기
   
   - 'RIGHT|LEFT|FULL' : FROM 절에 기술된 테이블(테이블1)의 자료가 
                         OUTER JOIN 테이블명2 보다 많으면 'LEFT', 적으면 'RIGHT', 양쪽 모두 적으면 'FULL' 사용
                         
** 1) SELECT 에 사용하는 컬럼 중 양쪽 테이블에 모두 존재하는 컬럼은 많은 쪽 테이블 것을 사용해야 함
   2) 외부조인의 SELECT 절에 COUNT 함수를 사용하는 겨우
      '*'는 NULL 값을 갖는 행도 하나의 행으로 인식하여 부정확한 값을 반환함
      따라서 '*' 대신 해당 테이블의 기본키를 사용
      
사용 예) 모든 분류에 속한 상품의 수를 출력하시오
    (일반 외부 조인)
    SELECT  B.LPROD_GU AS 분류코드, 
            B.LPROD_NM AS 분류명, 
            COUNT(A.PROD_ID) AS "상품의 수"
    FROM    PROD A, LPROD B     -- PROD 자료 종류 수 7개, LPROD 9개
    WHERE   A.PROD_LGU(+) = B.LPROD_GU
    GROUP   BY  B.LPROD_GU, B.LPROD_NM
    ORDER   BY 1;
    
    (ANSI 외부 조인)
    SELECT  B.LPROD_GU AS 분류코드, 
            B.LPROD_NM AS 분류명, 
            COUNT(A.PROD_ID) AS "상품의 수"
    FROM    PROD A              -- PROD 자료 종류 수 7개, LPROD 9개
    RIGHT   OUTER   JOIN    LPROD B ON(A.PROD_LGU = B.LPROD_GU) -- 조건에 (+) 생략
    GROUP   BY  B.LPROD_GU, B.LPROD_NM
    ORDER   BY 1;
    
사용 예) 2020년 6월 모든 거래처별 매입집계를 조회하시오
        Alias 거래처코드, 거래처명, 매입금액합계
    (일반 외부 조인) -- 원하는 결과 출력 X
    SELECT  A.BUYER_ID AS 거래처코드, 
            A.BUYER_NAME AS 거래처명, 
            SUM(B.BUY_QTY * C.PROD_COST) AS 매입금액합계
    FROM    BUYER A, BUYPROD B, PROD C      -- 자료 종류 수 BUYER > PROD > BUYPROD
    WHERE   BUY_PROD(+) = C.PROD_ID
    AND     A.BUYER_ID = C.PROD_BUYER(+)
    AND     B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630') -- 외부조인조건과 일반조건 같이 쓰면 내부 조인 발생
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
    
    (ANSI 외부 조인)
    SELECT  A.BUYER_ID AS 거래처코드, 
            A.BUYER_NAME AS 거래처명, 
            NVL(SUM(B.BUY_QTY * C.PROD_COST),0) AS 매입금액합계
    FROM    BUYER A
    LEFT    OUTER   JOIN    PROD C ON(A.BUYER_ID = C.PROD_BUYER) 
    LEFT    OUTER   JOIN    BUYPROD B ON(B.BUY_PROD = C.PROD_ID
                    AND     B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630'))
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
        
    (서브쿼리)
    SELECT  A.BUYER_ID AS 거래처코드, 
            A.BUYER_NAME AS 거래처명, 
            NVL(TBL.BSUM,0) AS 매입금액합계
    FROM    BUYER A,
            (--거래처별 2020년 6월 매입금액합계
            SELECT  C.PROD_BUYER AS CID,
                    SUM(B.BUY_QTY * C.PROD_COST) AS BSUM
            FROM    BUYPROD B, PROD C
            WHERE   B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
            AND     B.BUY_PROD = C.PROD_ID
            GROUP   BY  C.PROD_BUYER) TBL
    WHERE   A.BUYER_ID = TBL.CID(+)
    ORDER   BY  1;
    
사용 예) 2020년 상반기(1-6월) 모든 제품별 매입수량집계를 조회하시오
    
    SELECT  B.PROD_NAME AS 제품,
            SUM(A.BUY_QTY) AS 매입수량집계
    FROM    BUYPROD A, PROD B
    WHERE   A.BUY_PROD = B.PROD_ID
    GROUP   BY  B.PROD_NAME
    ORDER   BY  1;
    
사용 예) 2020년 상반기(1-6월) 모든 제품별 매출수량집계를 조회하시오

사용 예) 2020년 상반기(1-6월) 모든 제품별 매입/매출수량집계를 조회하시오