2022-0809-01)연산자
 1. 관계(비교)연산자
  - 자료의 대소관계를 비교하는 연산자로 결과는 참(true)과 거짓(false)로 반환
  - >, <, >=, <=, +, != (<>:같지않다)
  - 표현식(CASE WHEN ~  THEN, DECODE) 이나 WHERE 조건절에 사용
  
사용 예) 회원 테이블(MEMBER)에서 모든 회원들의 회원번호, 회원명, 직업, 마일리지를 조회하되
        마일리지가 많은 회원부터 조회
        
  SELECT MEM_ID AS 회원번호,
         MEM_NAME AS 회원명,
         MEM_JOB AS 직업,
         MEM_MILEAGE AS 마일리지
    FROM MEMBER
   ORDER BY 4 DESC;     --ORDER BY MEM_MILEAGE DESC;  //COLUMN INDEX를 사용(기술하기 복잡한 경우 사용)

(HR 계정에서 실행) ***************************************************************  
  ** EMPLOYEES 테이블에 새로운 컬럼(EMP_NAME), 데이터타입은 VARCHAR2(80)인 컬럼을 추가
    ALTER TABLE 테이블명 ADD(컬럼명 데이터타입[(크기)][DEFAULT 값]);    
ALTER TABLE EMPLOYEES ADD(EMP_NAME VARCHAR2(80));

  ** 데이터는 기존 자료(FIRST_NAME + LAST_NAME)를 입력
    UPDATE 문 => 자료 수정,갱신할 때 사용
    UPDATE 테이블명
       SET 컬럼명 = 값[,]
                :
           컬럼명 = 값
    [WHERE 조건];     --생략 시 모든 행을 똑같은 값으로
    
UPDATE HR.EMPLOYEES     -- 계정명을 명시하면 접속가능한 객체 목록 확인 가능
   SET salary = 1000; 
ROLLBACK; --실행취소

UPDATE EMPLOYEES
   SET EMP_NAME = FIRST_NAME||' '||LAST_NAME;     -- ||:문자열결합
SELECT EMPLOYEE_ID, 
       EMP_NAME
  FROM EMPLOYEES;
COMMIT; -- DB반영
***************************************************************
사용 예) 사원테이블(HR.EMPLOYEES) 부서번호가 50번인 사원들을 조회
        Alias는 사원번호,사원명,부서번호,급여이다.  --별칭 -> SELECT 속성 종류
        
  SELECT EMPLOYEE_ID AS 사원번호,
         EMP_NAME AS 사원명,
         DEPARTMENT_ID AS 부서번호,
         SALARY AS 급여
    FROM HR.EMPLOYEES
   WHERE DEPARTMENT_ID = 50;

사용 예) 회원 테이블(MEMBER)에서 직업이 주부이고 --마일리지가 3000이상인 회원들을 조회
        Alias는 회원번호, 회원명, 직업, 마일리지
        
  SELECT MEM_ID AS 회원번호, 
         MEM_NAME AS 회원명, 
         MEM_JOB AS 직업, 
         MEM_MILEAGE AS 마일리지
    FROM MEMBER
   WHERE MEM_JOB = '주부'; --AND MEM_MILEAGE >= 3000;
   
 2. 산술연산자
  - '+', '-', '*', '/' => 4칙연산자
  - ( ) : 연산 우선순위 결정

사용 예) 사원테이블(HR.EMPLOYEES)에서 보너스를 계산하고 지급액을 결정하여 출력하세요
        보너스 = 본봉 * 영업실적의 30%
        지급액=본봉+보너스
        Alias는 사원번호, 사원명, 본봉, 영업실적, 보너스, 지급액
        모든 값은 정수부분만 출력
        
    SELECT EMPLOYEE_ID AS 사원번호, 
           EMP_NAME AS 사원명,             --FIRST_NAME||' '||LAST_NAME
           SALARY AS 본봉, 
           COMMISSION_PCT AS 영업실적, 
           NVL(ROUND(SALARY * COMMISSION_PCT * 0.3),0) AS 보너스,     --ROUND():소수첫째자리 반올림 (TRUNC)
                                                                     --NVL(,0):NULL값이면 0값으로
           SALARY + NVL(ROUND(SALARY * COMMISSION_PCT * 0.3),0) AS 지급액
      FROM HR.EMPLOYEES;     
     -- 표준 SQL 변수 사용 불가
     -- NULL 값 연산 시 결과 NULL
 
 3. 논리연산자
  - 두 개이상의 관계식을 연결(AND, OR)하거나 반전(NOT)결과 반환
  - NOT, AND, OR
  --------------------------
     입력          출력
    A   B       OR  AND
  --------------------------
    0   0       0   0
    0   1       1   0
    1   0       1   0
    1   1       1   1
 
사용 예) 상품테이블(PROD)에서 판매가격이 30만원 이상이고 적정재고가 5개 이상인
        제품번호, 제품명, 매입가, 판매가, 적정재고를 조회           -- 열 조회:SELECT, 행 조회 조건:WHERE

    SELECT PROD_ID AS 제품번호,
           PROD_NAME AS 제품명, 
           PROD_COST AS 매입가,
           PROD_PRICE AS 판매가, 
           PROD_PROPERSTOCK AS 적정재고
      FROM PROD
     WHERE PROD_PRICE >= 300000 
       AND PROD_PROPERSTOCK >= 5
     ORDER BY 4;

사용 예) 매입테이블(BUYPROD)에서 2020년 1월이고 매입수량이 10개 이상인 매입정보를 조회
        Alias 매입일, 매입상품, 매입수량, 매입금액
   
    SELECT BUY_DATE AS 매입일,
           BUY_PROD AS 매입상품, 
           BUY_QTY AS 매입수량,
           BUY_QTY * BUY_COST AS 매입금액
      FROM BUYPROD
     WHERE BUY_DATE >= TO_DATE('20200101')  
       AND BUY_DATE <= TO_DATE('20200131')
       AND BUY_QTY >= 10; 
       
사용 예) 회원테이블(MEMBER)에서 연령대가 20대이거나 여성인 회원을 조회    --주민번호 앞자리+주민번호 뒷자리,또는 생년월일 사용
        Alias는 회원번호, 회원명, 주민번호, 마일리지

    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명, 
           MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
           TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) = 20 -- TRUNC(,-1) : 일의자리 버림
                                                                                -- EXTRACT : 특정 부분만 추출
        OR SUBSTR(MEM_REGNO2,1,1) IN ('2','4');    
    
사용 예) 회원테이블(MEMBER)에서 연령대가 20대이거나 여성이면서 마일리지가 2000이상인 회원을 조회
        Alias는 회원번호, 회원명, 주민번호, 마일리지
        
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명, 
           MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
           TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE (TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) = 20 
        OR SUBSTR(MEM_REGNO2,1,1) IN ('2','4'))
       AND MEM_MILEAGE >= 2000;  
       
사용 예) 키보드로 년도를 입력받아 윤년과 평년을 판단하시오
        윤년 : 4의배수이면서 100의 배수가 아니거나 또는 400의 배수가 되는 년도
    ACCEPT P_YEAR PROMPT '년도입력 : '      -- 헤더 부분, ACCEPT: 사용자 입력 값 저장
    DECLARE                                -- 선언부분
        V_YEAR NUMBER:=TO_NUMBER('&P_YEAR');        -- P_YEAR 문자열을 숫자로
        V_RES VARCHAR2(100);        
    BEGIN                                  -- 실행부분
        IF (MOD(V_YEAR, 4)=0 AND MOD(V_YEAR,100) != 0) OR (MOD(V_YEAR, 400)=0) THEN     -- MOD : %나머지연산
            V_RES:=TO_CHAR(V_YEAR)||'년도는 윤년입니다';
        ELSE 
            V_RES:=TO_CHAR(V_YEAR)||'년도는 평년입니다';
        END IF;            
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END;