2022-0826-01) NULL 처리 함수
 - 오라틀의 컬럼은 사용자가 데이터를 정의하지 않으면 NULL 값이 기본값으로 저장
 - NULL 값과 연산되면 결과는 모두 NULL 이 반환됨
 - NULL 에 관련된 연산자 : IS NULL, IS NOT NULL
 - NULL 처리 함수 : NVL, NVL2, NULLIF 등이 제공
 
 1) NULL 처리 연산자
  . NULL 값은 '='(Equal to)으로 비교 불가능
  . 반드시 IS [NOT] NULL 로 비교해야 함
  
사용 예) 사원테이블에서 영업실적이 NULL이 아닌 사원을 조회하시오
        Alias 사원번호, 사원명, 영업실적, 부서코드
        
    SELECT  EMPLOYEE_ID AS 사원번호, 
            EMP_NAME AS 사원명, 
            COMMISSION_PCT AS 영업실적, 
            DEPARTMENT_ID AS 부서코드
    FROM    HR.EMPLOYEES
    --WHERE   COMMISSION_PCT <> NULL;
    WHERE   COMMISSION_PCT IS NOT NULL;
    
 2) NVL(expr, val)
  . 'expr'의 값이 NULL이면 'val'을 반환하고, NULL이 아니면 자신('expr')을 반환
  . 'expr'과 'val'은 반드시 같은 데이터 타입이어야 함
  
  ** 상품테이블에서 분류코드가 'P301'을 제외한 모든 상품의 마일리지를 해당 상품의 판매가의 0.5%로 변경하시오
    COMMIT;     -- ROLLBACK을 위한 커밋 지점 생성
  
    UPDATE  PROD
    SET     PROD_MILEAGE=ROUND(PROD_PRICE*0.0005)
    WHERE   PROD_LGU <> 'P301';
    
사용 예) 상품테이블에서 상품의 마일리지가 NULL인 상품은 '마일리지가 제공되지 않는 상품'이라는 메시지를 
        상품마일리지 출력컬럼에 출력하시오
        Alias 상품번호, 상품명, 마일리지
        
    SELECT  PROD_ID AS 상품번호,
            PROD_NAME AS 상품명,
            NVL(LPAD(TO_CHAR(PROD_MILEAGE ),5),'마일리지가 제공되지 않는 상품') AS 마일리지  --왼쪽공백 오른쪽 정렬  
    FROM    PROD;
    
***NVL은 OUTER JOIN 에 많이 사용됨
사용 예) 2020년 6월 모든 제품별 판매집계를 조회하시오
        
    SELECT  A.PROD_ID AS 제품코드, 
            A.PROD_NAME AS 제품명,
            COUNT(B.CART_PROD) AS 판매횟수, 
            NVL(SUM(B.CART_QTY),0) AS 판매수량합계, 
            NVL(SUM(B.CART_QTY * A.PROD_PRICE),0) AS 판매금액합계
    FROM    PROD A
    LEFT OUTER JOIN     CART B ON(A.PROD_ID=B.CART_PROD AND
                                  B.CART_NO   LIKE    '202006%') -- PROD이 CART 테이블보다 종류가 많다
    GROUP   BY  A.PROD_ID, A.PROD_NAME  -- 같은 기능의 속성이라도 집계함수가 쓰여지지 않은 속성은 작성해야함
    ORDER   BY  1;
    
** 2020년 4월 판매자료를 이용하여 모든 구매회원들의 마일리지를 변경하시오
    (1. 2020년 4월 판매자료를 이요한 회원별 마일리지 합계)
    SELECT  A.CART_MEMBER,
            SUM(A.CART_QTY*B.PROD_MILEAGE)
    FROM    CART A, PROD B
    WHERE   A.CART_PROD = B.PROD_ID
    AND     A.CART_NO LIKE '202004%'
    GROUP   BY  A.CART_MEMBER;
    
COMMIT;
    (2. 회원테이블의 마일리지 갱신)
    UPDATE  MEMBER TA
    SET     TA.MEM_MILEAGE = TA.MEM_MILEAGE + NVL((SELECT    TB.MSUM        --NULL 값을 0으로
                              FROM    (SELECT   A.CART_MEMBER AS MID,
                                                SUM(A.CART_QTY * B.PROD_MILEAGE) AS MSUM
                                        FROM    CART A, PROD B
                                        WHERE   A.CART_PROD = B.PROD_ID
                                        AND     A.CART_NO LIKE '202004%'
                                        GROUP   BY  A.CART_MEMBER) TB
                              WHERE     TB.MID = TA.MEM_ID), 0);
                              
    CREATE OR REPLACE VIEW V_MEM_MILEAGE
    AS
        SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
        FROM    MEMBER
        WITH    READ    ONLY;
    
    SELECT * FROM V_MEM_MILEAGE;
    
사용 예) 2020년 4월 구매회원들에게 특별 마일리지 300포인트를 지급하시오
    UPDATE  MEMBER
    SET     MEM_MILEAGE = MEM_MILEAGE + 300
    WHERE   MEM_ID IN (SELECT   DISTINCT CART_MEMBER
                        FROM    CART
                        WHERE   CART_NO LIKE '202004%');
                        
 2)NVL2(expr, val1, val2)
  . 'expr' 값이 NULL이면 'val2'를 반환하고 NULL이 아니면 'val1'을 반환
  . 'val1' 과 'val2'의 데이터 타입은 동일해야 함
  . NVL을 확장한 개념
  
사용 예) 상품테이블에서 상품의 색상을 출력하시오. 
        단, 색상값이 없으면 '색상없음'을 출력하시오 (NVL, NVL2 각각 구현)
        Alias 상품번호, 상품명, 색상
    (NVL 사용)
    SELECT  PROD_ID AS 상품번호, 
            PROD_NAME AS 상품명, 
            NVL(PROD_COLOR,'색상없음') AS 색상
    FROM    PROD;
    
    (NVL2 사용)
    SELECT  PROD_ID AS 상품번호, 
            PROD_NAME AS 상품명, 
            NVL2(PROD_COLOR, PROD_COLOR,'색상없음') AS 색상
    FROM    PROD;