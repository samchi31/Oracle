2022-0823-01) 집계함수 사용하기

사용 예) 
    SELECT  AVG(DISTINCT PROD_COST),    -- 중복된 값은 제외
            AVG(ALL PROD_COST),         -- 모든 값 포함
            AVG(PROD_COST)              -- ALL을 생략한 거와 같다
    FROM    PROD
    ORDER   BY 1;
    
사용 예) 상품테이블의 상품분류별 매입가격 평균 값

    SELECT  PROD_LGU AS 상품분류코드,
            ROUND(AVG(PROD_COST),2) PROD_COST  -- AS 생략 소수점 2자리까지 반올림
    FROM    PROD
    GROUP   BY PROD_LGU     -- ~별로 묶어서 집계
    ORDER   BY 1;
    
사용 예) 상품 분류별 구매가격 평균

    SELECT  PROD_LGU AS 상품분류,
            ROUND(AVG(PROD_SALE),2) 구매가격평균
    FROM    PROD
    GROUP   BY PROD_LGU
    ORDER   BY 1;
    
사용 예) 
    SELECT  PROD_LGU,
            PROD_BUYER,
            ROUND(AVG(PROD_COST),2) PROD_COST,
            SUM(PROD_COST),
            MAX(PROD_COST),
            MIN(PROD_COST),
            COUNT(PROD_COST)
    FROM    PROD
    GROUP   BY PROD_LGU, PROD_BUYER     -- 대분류 PROD_LGU, 중분류 PROD_BUYER
    ORDER   BY 1, 2;
    
사용 예) 상품테이블의 총 판매가격의 평균값을 구하시오
        Alias는 상품총판매가평균     -- Alias의 허용 BYTES는 30BYTES이다.
        
    SELECT  AVG(SUM(PROD_SALE)) AS 상품총판매가평균
    FROM    PROD
    GROUP   BY PROD_LGU;
    
사용 예) 상품테이블의 상품분류 별 판매가격 평균 값을 구하시오
        Alias 상품분류, 상품분류별판매가격평균 -- Alias의 허용 BYTES는 30BYTES이다 오류남
        
    SELECT  PROD_LGU AS 상품분류,
            TO_CHAR(ROUND(AVG(PROD_SALE),2),'L9,999,999.00') AS 상품총판매가평균  -- 소수점 2자리 0 정렬 맞추기
    FROM    PROD
    GROUP   BY PROD_LGU
    ORDER   BY 1;
    
사용 예) 거래처테이블의 담당자를 컬럼으로 하여 COUNT 집계 하시오     -- COUNT는 NULL값이 있으면 세지 않는다.
        Alias는 자료수(DISTINCT), 자료수, 자료수(*)            -- 후보키 : NOT NULL, NOT DUPLICATE
        
    SELECT  COUNT(*),           --74개   -- 행의 수 : CARDINALITY , 열의 수: DEGREE
            COUNT(PROD_COLOR)   --41개
    FROM    PROD;       
        
    SELECT  COUNT(DISTINCT BUYER_CHARGER) "자료수(DISTINCT)",
            COUNT(BUYER_CHARGER) 자료수,
            COUNT(*) "자료수(*)"
    FROM    BUYER;
    
사용 예) 회원테이블의 취미별 COUNT 집계, 회원의 취미 별 인원 수를 구해보자
        Alias는 취미, 자료수, 자료수(*)      -- #_$ : 테이블명, 컬럼명, Alias명에 들어갈 수 있다 (첫글자는 불가)
        
    SELECT  MEM_LIKE 취미, 
            COUNT(MEM_LIKE) 자료수, 
            COUNT(*) "자료수(*)"
    FROM    MEMBER
    GROUP   BY MEM_LIKE
    ORDER   BY 1;
    
사용 예) 장바구니테이블의 회원별 최대구매수량을 검색
        Alias 회원ID, 최대수량, 최소수량
        
    SELECT  CART_MEMBER 회원ID, 
            MAX(CART_QTY) 최대수량, 
            MIN(CART_QTY) 최소수량
    FROM    CART
    GROUP   BY CART_MEMBER
    ORDER   BY 1;
    
사용 예) 오늘이 2020년7월11일이라 가정하고 장바구니테이블에 발생될 추가주문번호를 검색
        Alias 최고치주문번호 , 추가주문번호
        
    SELECT  MAX(CART_NO) AS 최고치주문번호 , 
            MAX(CART_NO)+1 AS 추가주문번호
    FROM    CART
    WHERE   CART_NO BETWEEN '2020071100000' AND '2020071200000'; 
    -- WHERE SUBSTR(CART_NO, 1, 8) = '20200711'
    -- AND   CART_NO LIKE '20200711%'       -- LIKE와 함께 쓰인 %, _를 와일드 카드라고 한다
    
사용 예) 상품테이블에서 상품분류, 거래처별로 최고판매가, 최소판매가, 자료수를 검색

    SELECT  MAX(PROD_SALE) 최고판매가, 
            MIN(PROD_SALE) 최소판매가, 
            COUNT(*) 자료수
    FROM    PROD
    GROUP   BY PROD_LGU, PROD_BUYER;
    
    