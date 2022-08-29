2022-0829-01) 테이블 조인
 - 관계형 데이터베이스에서 관계(Relationship)를 이용하여 복수개의 테이블로부터
   필요한 자료를 추출하는 연산
 - 조인에 참여하는 테이블은 반드시 관계(외래키 관계) 맺어야함
   (관계가 없는 테이블 간의 조인을 Cartessian(Cross) join 이라고 함)
 - 조인의 종류
   . 내부조인과 외부조인(Inner Join, Outer Join) -- 조인조건 만족 : 내부조인, 만족하지 않는 결과도 포함 : 외부조인
   . 일반조인과 ANSI Join -- 회사마다 다른 일반조인 문법을 ANSI 에서 규격을 정해놈
   . Equi Join, Non-Equi Join, Self Join, Cartessian Product -- = 연산자 조인: Equi, 다른 연산자 : Non-Equi

1. 일반 조인
 - 각 DB벤더에서 자사의 DBMS에 최적화된 문법구조를 가짐
 - 사용 DB가 바뀌면 변경된 문법을 새로 습득해야 함
 (사용 형식)
 SELECT    컬럼list
 FROM      테이블명1 [별칭1], 테이블명2 [별칭2] [,...]            
 WHERE     [별칭1|테이블명1].컬럼명 = [별칭2|테이블명2].컬럼명
 [AND      조인조건]
 [AND      일반조건]
              :
  . n개의 테이블이 사용되면 조인조건 적어도 n-1개 이상 되어야 함
  . 일반조건과 조인조건은 사용 순서가 바뀌어도 상관 없음
   
2. ANSI 내부조인
 (사용 형식)
 SELECT    컬럼list
 FROM      테이블명1 [별칭1]
 INNER|CROSS|NATURAL JOIN   테이블명2 [별칭2] ON(조인조건 [AND 일반조건])
 INNER|CROSS|NATURAL JOIN   테이블명3 [별칭2] ON(조인조건 [AND 일반조건])
                                :                                
 [WHERE     일반조건]
               :
  . 테이블명1과 테이블명2는 반드시 직접 JOIN 가능해야함
  . 테이블명3은 테이블명1과 테이블명2의 조인결과와 조인 수행  -- 테이블1과 테이블2는 직접적으로 관계가 있어 조인이 되어야 함
  . 'CROSS JOIN'은 일반조인의 Cartessian Product와 동일
  . 'NATURAL JOIN'은 조인연산에 사용된 테이블에 동일 컬럼명이 존재하면 자동으로 조인 발생
  
3. Cartessian Product Join(Cross Join)
 . 조인조건이 기술되지 않았거나 잘못 기술된 경우 발생
 . n행 m열의 테이블과 a행 b열의 테이블이 Cross Join된 경우 최악의 경우(조인조건이 누락된 경우)
   결과는 n*a 행 m+b 열이 반환됨
 . 반드시 필요한 경우가 아니면 사용을 자제해야 함
 
사용 예)
    SELECT  COUNT(*) AS "PROD 테이블 행의 수"     FROM    PROD;
    SELECT  COUNT(*) AS "CART 테이블 행의 수"     FROM    CART;
    SELECT  COUNT(*) AS "BUYPROD 테이블 행의 수"     FROM    BUYPROD;
    
    SELECT  COUNT(*) AS "BUYPROD 테이블 행의 수"     FROM    PROD, CART, BUYPROD;
    
    SELECT  *
    FROM    PROD
    CROSS   JOIN    CART
    CROSS   JOIN    BUYPROD;
    
    SELECT  *
    FROM    CART
    INNER   JOIN    BUYPROD ON 조인조건 -- 조인조건이 불분명 하기 때문에 오류
    CROSS   JOIN    PROD;
    
4. Equi Join(ANSI의 INNER JOIN)
 - 조인조건에 '=' 연산자 사용
 (일반조인 사용형식)
 SELECT     컬럼list
 FROM       테이블명1 [별칭1], 테이블명2 [별칭2] [,테이블명3 [별칭3],...]
 WHERE      [별칭1.]컬럼명1 = [별칭2.]컬럼명2         -- 조인조건
 [AND       [별칭1.]컬럼명1 = [별칭2.]컬럼명3]        -- 조인조건, 꼭 별칭1.컬럼명1 = 3 아니여도 됨 (2 = 3 가능)
                :
 [AND       일반조건]
 
 (ANSI조인 사용형식)
 SELECT     컬럼list
 FROM       테이블명1 [별칭1]
 INNER  JOIN    테이블명2 [별칭2] ON([별칭1.]컬럼명1=[별칭2.]컬럼명2 [AND 일반조건1])
 INNER  JOIN    테이블명3 [별칭3] ON([별칭1.]컬럼명1=[별칭3.]컬럼명3 [AND 일반조건2]) -- 꼭 1이 아니여도 됨 2 가능
                  :
 [WHERE      일반조건]
 
사용 예) 매입테이블에서 2020년 6월 매입상품정보를 조회하시오
        Alias 일자, 상품번호, 상품명, 수량, 금액    -- 부모테이블BUY 자식테이블PROD 공통 컬럼일 경우 컬럼명을 동일하게해야한다.
    (일반조인)                                   -- (잘못된 예 :BUY_PROD 와 PROD_ID) (수정 : BUY_ID 와 PROD_ID) 
    SELECT  A.BUY_DATE AS 일자, 
            B.PROD_ID AS 상품번호,      -- A.BUY_PROD 사용 가능
            B.PROD_NAME AS 상품명, 
            A.BUY_QTY AS 수량, 
            A.BUY_QTY * B.PROD_COST AS 금액
    FROM    BUYPROD A, PROD B               -- 테이블 모두
    WHERE   A.BUY_PROD = B.PROD_ID          -- 조인조건
    AND     A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')      -- 일반조건
    ORDER   BY  1;

    (ANSI 조인)
    SELECT  A.BUY_DATE AS 일자, 
            B.PROD_ID AS 상품번호,     
            B.PROD_NAME AS 상품명, 
            A.BUY_QTY AS 수량, 
            A.BUY_QTY * B.PROD_COST AS 금액
    FROM    BUYPROD A       -- 테이블 하나만
    --INNER   JOIN    PROD B ON(A.BUY_PROD = B.PROD_ID AND        --조인조건
    --                        A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')) --일반조건
    INNER   JOIN    PROD B ON(A.BUY_PROD = B.PROD_ID)        --조인조건
    WHERE   A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630') --일반조건(조인테이블이 2개 일때만 가능)
    ORDER   BY  1;
    
사용 예) 상품테이블에서 'P10202' 거래처에서 납품하는 상품정보를 조회하시오
        Alias 상품코드, 상품명, 거래처명, 매입단가
    (일반조인)
    SELECT  A.PROD_ID AS 상품코드, 
            A.PROD_NAME AS 상품명, 
            B.BUYER_NAME AS 거래처명, 
            A.PROD_COST AS 매입단가
    FROM    PROD A, BUYER B
    WHERE   A.PROD_BUYER = B.BUYER_ID
    AND     A.PROD_BUYER = 'P10202';
    
    (ANSI조인)
    SELECT  A.PROD_ID AS 상품코드, 
            A.PROD_NAME AS 상품명, 
            B.BUYER_NAME AS 거래처명, 
            A.PROD_COST AS 매입단가
    FROM    PROD A
    INNER   JOIN    BUYER B ON(A.PROD_BUYER = B.BUYER_ID)
    WHERE   A.PROD_BUYER = 'P10202';
        
사용 예) 상품테이블에서 다음 정보를 조회하시오
        Alias 상품코드, 상품명, 분류명, 판매단가
    (일반조인)
    SELECT  A.PROD_ID AS 상품코드, 
            A.PROD_NAME AS 상품명, 
            B.LPROD_NM AS 분류명, 
            A.PROD_PRICE AS 판매단가
    FROM    PROD A, LPROD B
    WHERE   A.PROD_LGU = B.LPROD_GU;
    
    (ANSI조인)
    SELECT  A.PROD_ID AS 상품코드, 
            A.PROD_NAME AS 상품명, 
            B.LPROD_NM AS 분류명, 
            A.PROD_PRICE AS 판매단가
    FROM    PROD A
    INNER   JOIN    LPROD B ON(A.PROD_LGU = B.LPROD_GU);
    
사용 예) 사원테이블에서 사원번호, 사원명, 부서명, 입사일을 출력
    (일반조인)
    SELECT  A.EMPLOYEE_ID AS 사원번호, 
            A.EMP_NAME AS 사원명, 
            B.DEPARTMENT_NAME AS 부서명,
            A.HIRE_DATE AS 입사일
    FROM    HR.EMPLOYEES A, HR.DEPARTMENTS B
    WHERE   A.DEPARTMENT_ID = B.DEPARTMENT_ID; --내부 조인은 조인조건을 만족한 결과만 출력
    
    (ANSI조인)
    SELECT  A.EMPLOYEE_ID AS 사원번호, 
            A.EMP_NAME AS 사원명, 
            B.DEPARTMENT_NAME AS 부서명,
            A.HIRE_DATE AS 입사일
    FROM    HR.EMPLOYEES A
    INNER   JOIN    HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID);

사용 예) 2020년 4월 회원별, 상품별 판매집계를 조회하시오
        Alias 회원번호, 회원명, 상품명, 구매수량합계, 구매금액합계
    (일반조인)
    SELECT  A.CART_MEMBER AS 회원번호, 
            B.MEM_NAME AS 회원명, 
            C.PROD_NAME AS 상품명, 
            SUM(A.CART_QTY) AS 구매수량합계, 
            SUM(A.CART_QTY * C.PROD_PRICE) AS 구매금액합계
    FROM    CART A, MEMBER B, PROD C
    WHERE   A.CART_MEMBER = B.MEM_ID        -- 조인조건
    AND     A.CART_PROD = C.PROD_ID         -- 조인조건 
    AND     A.CART_NO LIKE '202004%'   -- 일반조건
    GROUP   BY  A.CART_MEMBER, B.MEM_NAME, C.PROD_NAME
    ORDER   BY  1;
    
    (ANSI조인)
    SELECT  A.CART_MEMBER AS 회원번호, 
            B.MEM_NAME AS 회원명, 
            C.PROD_NAME AS 상품명, 
            SUM(A.CART_QTY) AS 구매수량합계, 
            SUM(A.CART_QTY * C.PROD_PRICE) AS 구매금액합계
    FROM    CART A
    INNER   JOIN    MEMBER B ON(A.CART_MEMBER = B.MEM_ID)
    --INNER   JOIN    PROD C ON(A.CART_PROD = C.PROD_ID   
    --        AND     A.CART_NO LIKE '202004%')   -- 일반조건 (날짜와 관련된 조건은 언제의 구매수량인지 알기 위함이므로 여기에 기술)
    INNER   JOIN    PROD C ON(A.CART_PROD = C.PROD_ID)
    WHERE   A.CART_NO LIKE '202004%'        -- INNER 조인에서는 WHERE조건을 따로 써도 문제 없음 (외부조인은 X)
    GROUP   BY  A.CART_MEMBER, B.MEM_NAME, C.PROD_NAME
    ORDER   BY  1;
    
사용 예) 2020년 5월 거래처별 매출집계를 조회하시오
        Alias 거래처코드, 거래처명, 매출금액합계
    (일반조인)
    SELECT  A.BUYER_ID AS 거래처코드, 
            A.BUYER_NAME AS 거래처명, 
            SUM(B.CART_QTY * C.PROD_PRICE) AS 매출금액합계
    FROM    BUYER A, CART B, PROD C
    WHERE   A.BUYER_ID = C.PROD_BUYER
    AND     C.PROD_ID = B.CART_PROD
    AND     B.CART_NO LIKE '202005%'
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
    
    (ANSI조인)
    SELECT  A.BUYER_ID AS 거래처코드, 
            A.BUYER_NAME AS 거래처명, 
            SUM(B.CART_QTY * C.PROD_PRICE) AS 매출금액합계
    FROM    BUYER A
    INNER   JOIN    PROD C ON(A.BUYER_ID = C.PROD_BUYER)
    INNER   JOIN    CART B ON(C.PROD_ID = B.CART_PROD)
    WHERE   B.CART_NO LIKE '202005%'
    GROUP   BY  A.BUYER_ID, A.BUYER_NAME;
        
사용 예) HR 계정에서 미국이외의 국가에 위치한 부서에 근무하는 직원정보를 조회하시오
        Alias 부서번호, 부서명, 주소, 국가명
    (일반조인)
    SELECT  A.DEPARTMENT_ID AS 부서번호, 
            A.DEPARTMENT_NAME AS 부서명, 
            B.STREET_ADDRESS||' '||B.CITY||' '||B.STATE_PROVINCE AS 주소, 
            C.COUNTRY_NAME AS 국가명
    FROM    HR.DEPARTMENTS A, HR.LOCATIONS B, HR.COUNTRIES C
    WHERE   A.LOCATION_ID = B.LOCATION_ID
    AND     B.COUNTRY_ID = C.COUNTRY_ID
    AND     C.COUNTRY_NAME != 'United States of America';
    
    (ANSI조인)
    SELECT  A.DEPARTMENT_ID AS 부서번호, 
            A.DEPARTMENT_NAME AS 부서명, 
            B.STREET_ADDRESS||' '||B.CITY||' '||B.STATE_PROVINCE AS 주소, 
            C.COUNTRY_NAME AS 국가명
    FROM    HR.DEPARTMENTS A
    INNER   JOIN    HR.LOCATIONS B ON(A.LOCATION_ID = B.LOCATION_ID)
    INNER   JOIN    HR.COUNTRIES C ON(B.COUNTRY_ID = C.COUNTRY_ID)
    WHERE   C.COUNTRY_NAME != 'United States of America';