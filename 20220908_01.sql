2022-0908-01) 함수(User Defined Function : Function)
 - 목적 및 특징은 프로시저와 유사
 - 프로시저와 차이점은 반환 값이 존재함(SELECT 문의 SELECT 절, WHERE 절, UPDATE 및 INSERT 문의 조건절에 사용 가능)
 
 (사용형식)
 CREATE [OR REPLACE] FUNCTION 함수명[(
    변수명 [IN|OUT|INOUT] 데이터타입[:=디폴트값],  
                :
    변수명 [IN|OUT|INOUT] 데이터타입[:=디폴트값])]
    RETURN 타입명
 IS|AS
    선언영역       
 BEGIN
    실행영역     
    RETURN expr;
 END;
  . 실행영역에 반드시 하나 이상의 RETURN 문이 존재해야 함
  
사용 예) 오늘이 2020년 5월 17일이라고 가정하고 오늘 날짜를 입력 받아 장바구니 번호를 생성하는 함수를 생성

CREATE OR REPLACE FUNCTION FN_CREATE_CARTNO(P_DATE IN DATE)
    RETURN CHAR
IS
    V_CARTNO CART.CART_NO%TYPE;
    V_FLAG NUMBER:=0;
    V_DAY CHAR(9):=TO_CHAR(P_DATE,'YYYYMMDD')||TRIM('%');
BEGIN
    SELECT  COUNT(*) 
    INTO    V_FLAG
    FROM    CART
    WHERE   CART_NO LIKE V_DAY;
    
    IF V_FLAG = 0 THEN
        V_CARTNO := TO_CHAR(P_DATE,'YYYYMMDD')||TRIM('00001');
    ELSE    
        SELECT  MAX(CART_NO) + 1
        INTO    V_CARTNO
        FROM    CART
        WHERE   CART_NO LIKE V_DAY;
    END IF;
    
    RETURN  V_CARTNO;   
END;

(실행) 다음 자료를 CART 테이블에 저장하시오
        구매회원 : 'j001'
        구매상품 : 'P201000012'
        구매수량 : 5
        구매일자 : 오늘
    
    INSERT INTO CART(CART_MEMBER, CART_NO, CART_PROD, CART_QTY)
            VALUES('j001', FN_CREATE_CARTNO(SYSDATE), 'P201000012', 5);
            
사용 에) 년도와 월과 상품번호를 입력 받아 해당 기간에 발생된 상품별 매입집계를 조회하시오
        Alias 상품번호, 상품명, 매입수량, 매입금액
(매입수량)
CREATE OR REPLACE FUNCTION FN_SUM_BUYQTY(
    P_PERIOD IN CHAR,
    P_PID IN VARCHAR2)
    RETURN NUMBER
IS
    V_SUM NUMBER := 0;  --수량집계
    V_SDATE DATE := TO_DATE(P_PERIOD||'01');
    V_EDATE DATE := LAST_DAY(V_SDATE);
BEGIN
    SELECT  NVL(SUM(BUY_QTY), 0)
    INTO    V_SUM
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN V_SDATE AND V_EDATE
    AND     BUY_PROD = P_PID;
    
    RETURN  V_SUM;   
END; 

(매입금액)
CREATE OR REPLACE FUNCTION FN_SUM_BUYCOST(
    P_PERIOD IN CHAR,
    P_PID IN VARCHAR2)
    RETURN NUMBER
IS
    V_SUM NUMBER := 0;  --매입금액
    V_SDATE DATE := TO_DATE(P_PERIOD||'01');
    V_EDATE DATE := LAST_DAY(V_SDATE);
BEGIN
    SELECT  NVL(SUM(BUY_COST * BUY_QTY), 0)
    INTO    V_SUM
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN V_SDATE AND V_EDATE
    AND     BUY_PROD = P_PID;
    
    RETURN  V_SUM;   
END; 

(함수두개 결합)
CREATE OR REPLACE FUNCTION FN_SUM_BUY(
    P_PERIOD IN CHAR,
    P_PID IN VARCHAR2)
    RETURN VARCHAR2
IS
    V_RESULT VARCHAR2(40);
    V_SDATE DATE := TO_DATE(P_PERIOD||'01');
    V_EDATE DATE := LAST_DAY(V_SDATE);
BEGIN
    SELECT  LPAD(NVL(SUM(BUY_QTY), 0),5)||LPAD(NVL(SUM(BUY_COST * BUY_QTY), 0),20)
    INTO    V_RESULT
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN V_SDATE AND V_EDATE
    AND     BUY_PROD = P_PID;
    
    RETURN  V_RESULT;   
END; 

(실행)
    SELECT  PROD_ID AS 상품코드,
            PROD_NAME AS 상품명,
            FN_SUM_BUYQTY('202002',PROD_ID) AS 매입수량,
            FN_SUM_BUYCOST('202002',PROD_ID) AS 매입금액
    FROM    PROD;
    
    SELECT  PROD_ID AS 상품코드,
            PROD_NAME AS 상품명,
            FN_SUM_BUY('202002',PROD_ID) AS 매입수량금액
    FROM    PROD;