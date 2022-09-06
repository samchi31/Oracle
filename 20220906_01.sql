2022-0906-01) PL/SQL
 - 표준 SQL 이 가지고있는 단점(변수, 반복문, 분기문 등이 없음)을 보완
 - PROCEDUAL LANGUAGE SQL 
 - BLOCK 구조로 구성되어 있음
 - 익명 블록(Anonymous Block), Stored Procedure, User Defined Function, Trigger,
   Package 등이 제공
 - 모듈화 및 캡슐화 기능 제공
 
 
1) 익명블록
 - PL/SQL 의 기본구조 제공
 - 이름이 없어 재실행(호출)이 불가능
 (구성)
 DECLARE
    선언부(변수, 상수, 커서, 선언);
 BEGIN
    실행부:비지니스 로직 구현하기 위한 SQL구문, 반복문, 분기문 등으로 구성
    [EXCEPTION
        예외처리 문
    ]
 END;
 - 실행영역에서 사용하는 SELECT 문은 
   SELECT   컬럼list 
   INTO     변수명[,변수명,...]   -- 반드시 나와야함
   FROM     테이블명
   [WHERE   조건]
   . 컬럼의 갯수와 데이터타입은 INTO절의 변수의 갯수 및 데이터타입과 동일
   
 (1) 변수
  . 개발언어의 변수와 같은 개념
  . SCALAR 변수, REFERENCE 변수, COMPOSITE 변수, BINDING 변수 등이 제공     -- BINDING : 매개변수
  
  (사용형식)
  ** SCALAR 변수
  변수명[CONSTANT] 데이터타입[(크기)] [:=초기값];
   . 데이터타입 : SQL 에서 제공하는 데이터 타입, PLS_INTEGER, BINARY_INTEGER, BOOLEAN 등이 제공됨
   . 'CONSTANT' : 상수 선언(반드시 초기값이 설정되어야 함)
   
  ** REFERENCE 변수
  변수명 테이블명.컬럼명%TYPE     --한 열값
  변수명 테이블명%ROWTYPE        --한 행값
  
사용 예) 키보드로 부서를 입력받아 해당부서에 가장먼저 입사한 사원의 
        사원번호, 사원명, 직책코드, 입사일을 출력하는 블록을 작성하시오

ACCEPT  P_DID PROMPT '부서번호 입력 : '  -- 입력받은 데이터를 저장할 변수
DECLARE
    V_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;
    V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; --사원번호
    V_NAME VARCHAR2(100);               --사원명
    V_JID HR.JOBS.JOB_ID%TYPE;          --직책코드
    V_HDATE DATE;                       --입사일
BEGIN
    V_DID := TO_NUMBER('&P_DID');
    
    SELECT  A.EMPLOYEE_ID, A.EMP_NAME, A.JOB_ID, A.HIRE_DATE
    INTO    V_EID, V_NAME, V_JID, V_HDATE
    FROM    (
            SELECT  EMPLOYEE_ID, EMP_NAME, JOB_ID, HIRE_DATE
            FROM    HR.EMPLOYEES
            WHERE   DEPARTMENT_ID = V_DID
            ORDER   BY  4) A
    WHERE     ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||V_NAME);
    DBMS_OUTPUT.PUT_LINE('직책코드 : '||V_JID);
    DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HDATE);
END;

사용 예) 회원테이블에서 직업이 '주부'인 회원들의 2020년 5월 구매현황을 조회하시오
        Alias 회원번호, 회원명, 직업, 구매금액합계
        
    SELECT  A.MEM_ID AS 회원번호, 
            A.MEM_NAME AS 회원명, 
            A.MEM_JOB AS 직업, 
            D.BSUM AS 구매금액합계
    FROM    (
            SELECT  MEM_ID, MEM_NAME, MEM_JOB
            FROM    MEMBER
            WHERE   MEM_JOB = '주부') A, 
            (
            SELECT  B.CART_MEMBER AS BMID, 
                    SUM(B.CART_QTY * C.PROD_PRICE) AS BSUM
            FROM    CART B, PROD C
            WHERE   B.CART_PROD = C.PROD_ID
            AND     CART_NO LIKE '202005%'
            GROUP   BY  B.CART_MEMBER) D
    WHERE   A.MEM_ID = D.BMID;
    
    (익명블록사용)    
DECLARE 
    V_MID MEMBER.MEM_ID%TYPE;
    V_NAME VARCHAR2(100);
    V_JOB MEMBER.MEM_JOB%TYPE;
    V_SUM NUMBER := 0;       --몇자린지 모르면 크기 생략 27자리까지 잡아줌 !!초기화 필수!!
    CURSOR CUR_MEM IS           -- 변수에 여러 값을 저장할 때 사용
        SELECT  MEM_ID, MEM_NAME, MEM_JOB
        FROM    MEMBER
        WHERE   MEM_JOB = '주부'
BEGIN
    OPEN CUR_MEM;       -- 커서 사용하기 위한
    LOOP
        FETCH CURSOR    INTO    V_MID,V_NAME,V_JOB;
        EXIT WHEN   CUR_MEM%NOTFOUND;
        SELECT  SUM(A.CART_QTY * B.PROD_PRICE) INTO V_SUM
        FROM    CART A, PROD B
        WHERE   A.CART_PROD = B.PROD_ID
        AND     A.CART_NO LIKE '202005'
        AND     A.CART_MEMBER = V_MID;
        DBMS_OUTPUT.PUT_LINE('회원번호:'||V_MID);
        DBMS_OUTPUT.PUT_LINE('회원명:'||V_NAME);
        DBMS_OUTPUT.PUT_LINE('직업:'||V_JOB);
        DBMS_OUTPUT.PUT_LINE('구매금액:'||V_SUM);
    END LOOP;
    CLOSE CUR_MEM;
END;

사용 예) 년도를 입력 받아 윤년인지 평년인지 구별하는 블록을 작성하시오

ACCEPT P_YEAR PROMPT '년도입력:'
DECLARE
    V_YEAR NUMBER := TO_NUMBER('&P_YEAR');
    V_RES VARCHAR2(200);
BEGIN
    IF (MOD(V_YEAR,4) = 0 AND MOD(V_YEAR,100) != 0) OR MOD(V_YEAR,400) = 0
    THEN    V_RES := V_YEAR||'년은 윤년';
    ELSE
            V_RES := V_YEAR||'년은 평년';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(V_RES);
END;

사용 예) 반지름을 입력받아 원의 넓이와 원주의 길이를 구하시오
        (원주율 : 3.1415926)
ACCEPT P_R PROMPT '반지름:'
DECLARE
    V_R NUMBER := TO_NUMBER('&P_R');
    V_PI CONSTANT NUMBER := 3.1415926;
    V_AREA NUMBER := 0;
    V_CIRCUM NUMBER := 0;
BEGIN       
    V_AREA := V_R * V_R * V_PI;
    V_CIRCUM := 2 * V_R * V_PI;
    DBMS_OUTPUT.PUT_LINE('원 넓이 : '||V_AREA);
    DBMS_OUTPUT.PUT_LINE('원 둘레 : '||V_CIRCUM);
END;