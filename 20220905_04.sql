2022-0905) 조인 보강
CENOS
1. CARTESIAN PRODUCT : 행과 열이 모두 조합
2. EQUI JOIN : CARTESIAN PRODUCT 후 조인 조건이 같은 것
3. NON-EQUI JOIN :
4. OUTER JOIN
5. SELF JOIN

1) 연결고리 찾기 -> ERD 를 봐라 -> 기본키+외래키 찾기 -> 조인조건으로 사용
    --CARTESIAN PRODUCT
    SELECT  *
    FROM    LPROD, PROD; -- 12 X 74 행 = 888행
    
    -- 조인 조건 Equi JOIN (외래키)
    SELECT  *
    FROM    LPROD, PROD
    WHERE   LPROD_GU = PROD_LGU;
    
    SELECT  *
    FROM    CART, MEMBER
    WHERE   CART_MEMBER = MEM_ID;
    
    SELECT  *
    FROM    CART, MEMBER, PROD
    WHERE   CART_MEMBER = MEM_ID
    AND     CART_PROD = PROD_ID;
    
    -- PROD : 어떤 상품이 있는데
    -- BUYER : 그 상품을 납품한 업체는?
    -- CART : 그 상품을 누가 장바구니에 담았는가?
    -- MEMBER : 누가가 누구인가?
    SELECT  A.BUYER_ID, A.BUYER_NAME,
            B.PROD_ID, B.PROD_NAME, B.PROD_BUYER,
            C.CART_PROD, C.CART_MEMBER, C.CART_QTY,
            D.MEM_ID, D.MEM_NAME
    FROM    BUYER A, PROD B, CART C, MEMBER D
    WHERE   A.BUYER_ID = B.PROD_BUYER       -- 조인조건 개수는 테이블개수-1
    AND     B.PROD_ID = C.CART_PROD
    AND     C.CART_MEMBER = D.MEM_ID;
    
    (ANSI)
    SELECT  A.BUYER_ID, A.BUYER_NAME,
            B.PROD_ID, B.PROD_NAME, B.PROD_BUYER,
            C.CART_PROD, C.CART_MEMBER, C.CART_QTY,
            D.MEM_ID, D.MEM_NAME
    FROM    BUYER A 
    INNER JOIN PROD B ON (A.BUYER_ID = B.PROD_BUYER)
    INNER JOIN CART C ON (B.PROD_ID = C.CART_PROD)
    INNER JOIN MEMBER D ON (C.CART_MEMBER = D.MEM_ID)
    WHERE   B.PROD_NAME LIKE '%샤넬%';
    
    