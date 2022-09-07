2022-0907-01) 분기문과 반복문
1. 분기문
 - 프로그램의 제어를 변경시키는 명령
 - IF, CASE WHEN 등 제공
 1) IF 문
  . 개발언어의 IF 와 같은 기능 제공하며 사용방법도 유사
  (사용형식-1)
  IF 조건식 THEN
     명령문1;
  [ELSE 
     명령문2;]
  END IF;
  
  (사용형식-2)
  IF 조건식1 THEN
     명령문1;
  ELSIF 조건식2 THEN
     명령문2;
  ELSE 
     명령문3;  
  END IF;

  (사용형식-3)
  IF 조건식1 THEN
    IF 조건식2 THEN
        명령문1;
    ELSE 
        명령문2;
    END IF;
  ELSE 
     명령문3; 
  END IF;
  
 2) CASE 문
  . 다중 분기 기능 제공
  . JAVA의 SWITCH ~ CASE 와 유사
  (사용형식-1)
  CASE WHEN 조건식1 THEN
            명령문1;
       WHEN 조건식2 THEN
            명령문2;
              :
       ELSE
            명령문n;
  END CASE;
  
  (사용형식-2)
  CASE 조건식1 
       WHEN 값1 THEN
            명령문1;
       WHEN 값1 THEN
            명령문2;
              :
       ELSE
            명령문n;
  END CASE;
  
사용 예) 사원테이블에서 임의의 부서를 선택하여 첫번째 검색된 사원의 급여를 조회하고
        그 급여가 
            1 ~ 5000  : '저비용 사원'
         5001 ~ 10000 : '평균비용 사원'
        10001 ~ 20000 : '고비용 사원'
                그 이상 : '초고도비용 사원'을 사원명, 급여와 함께 출력하시오
    
DECLARE
    V_RES VARCHAR2(100);
    V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;
    V_SAL NUMBER := 0;
    V_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;
BEGIN
    V_DID := TRUNC(DBMS_RANDOM.VALUE(10,119),-1);   -- 정수형 난수 발생 10,20...110
    SELECT  EMP_NAME, SALARY
    INTO    V_ENAME, V_SAL
    FROM    HR.EMPLOYEES
    WHERE   DEPARTMENT_ID = V_DID
    AND     ROWNUM = 1;
    
    CASE WHEN V_SAL <= 5000 THEN
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'저비용 사원';
         WHEN V_SAL <= 10000 THEN
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'평균비용 사원';
         WHEN V_SAL <= 20000 THEN
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'고비용 사원';
         ELSE 
            V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'초고도비용 사원';
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE(V_RES);
END;

2. 반복문
 - 오라클 PL/SQL 에서 특정 명령문(들)을 반복 수행하는 경우 사용
 - 보통 커서를 수행하기위해 사용됨
 - LOOP, WHILE, FOR 문이 제공됨
 1) LOOP
  . 반복문의 기본 구조 제공
  . 무한 반복 기능 제공
  (사용형식)
  LOOP
    반복처리문(들)
    [EXIT WHEN 조건];
  END LOOP;
   - 'EXIT WHEN 조건' : 조건이 참이면 반복을 벗어남
   
사용 예) 구구단의 5단을 출력하시오

DECLARE
    V_CNT NUMBER := 0;
BEGIN
    LOOP
        V_CNT := V_CNT + 1;
        EXIT WHEN V_CNT > 9;        
        DBMS_OUTPUT.PUT_LINE('5 * '||V_CNT||' = '||V_CNT*5);
    END LOOP;
END;

사용 예) 사원테이블에서 임의의 부서를 선택하여 해당부서에 소속된 사원들의 급여를 조회하고  -- 여러 결과 -> 커서 사용
        그 급여가 
            1 ~ 5000  : '저비용 사원'
         5001 ~ 10000 : '평균비용 사원'
        10001 ~ 20000 : '고비용 사원'
                그 이상 : '초고도비용 사원'을 사원명, 급여와 함께 출력하시오
                
DECLARE
    V_RES VARCHAR2(100);        -- 결과
    V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;     -- 사원명
    V_SAL NUMBER := 0;      -- 급여
    V_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;    -- 부서번호
    CURSOR EMP01_CUR(P_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS
        SELECT  EMP_NAME, SALARY
        FROM    HR.EMPLOYEES
        WHERE   DEPARTMENT_ID = P_DID;
BEGIN
    V_DID := TRUNC(DBMS_RANDOM.VALUE(10,119),-1);   -- 정수형 난수 발생 10,20...110
    OPEN    EMP01_CUR(V_DID);
    DBMS_OUTPUT.PUT_LINE('부서번호 : '||V_DID);
    LOOP
        FETCH   EMP01_CUR INTO V_ENAME, V_SAL;
        EXIT WHEN   EMP01_CUR%NOTFOUND;     -- 커서 속성은 FETCH 후 세팅됨
        
        CASE WHEN V_SAL <= 5000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'저비용 사원';
            WHEN V_SAL <= 10000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'평균비용 사원';
            WHEN V_SAL <= 20000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'고비용 사원';
            ELSE 
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'초고도비용 사원';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('사원 수 : '||EMP01_CUR%ROWCOUNT);
    CLOSE   EMP01_CUR;
END;

 2) WHILE 문
  . 반복 수행 전 조건을 평가하여 조건이 참이면 반복을 수행하고, 조건의 평가 결과가 거짓이면
    반복 수행을 종료함
  . 개발언어의 WHILE 문과 같은 기능 제공     -- LOOP문을 더 많이 사용
  (사용형식)
  WHILE 조건 LOOP
    반복 수행 명령;
  END LOOP;
  
사용 예) 구구단 5단을 출력하시오

DECLARE
    V_CNT NUMBER := 0;
BEGIN
    WHILE V_CNT <= 9 LOOP
        V_CNT := V_CNT + 1;     
        DBMS_OUTPUT.PUT_LINE('5 * '||V_CNT||' = '||V_CNT*5);
    END LOOP;
END;

사용 예) 사원테이블에서 임의의 부서를 선택하여 해당부서에 소속된 사원들의 급여를 조회하고 
        그 급여가 
            1 ~ 5000  : '저비용 사원'
         5001 ~ 10000 : '평균비용 사원'
        10001 ~ 20000 : '고비용 사원'
                그 이상 : '초고도비용 사원'을 사원명, 급여와 함께 출력하시오
                
DECLARE
    V_RES VARCHAR2(100);        -- 결과
    V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;     -- 사원명
    V_SAL NUMBER := 0;      -- 급여
    V_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;    -- 부서번호
    CURSOR EMP01_CUR(P_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS
        SELECT  EMP_NAME, SALARY
        FROM    HR.EMPLOYEES
        WHERE   DEPARTMENT_ID = P_DID;
BEGIN
    V_DID := TRUNC(DBMS_RANDOM.VALUE(10,119),-1);   -- 정수형 난수 발생 10,20...110
    OPEN    EMP01_CUR(V_DID);
    DBMS_OUTPUT.PUT_LINE('부서번호 : '||V_DID);
    FETCH   EMP01_CUR INTO V_ENAME, V_SAL;
    WHILE EMP01_CUR%FOUND LOOP  -- 커서 속성은 FETCH 후 세팅됨
    
        CASE WHEN V_SAL <= 5000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'저비용 사원';
            WHEN V_SAL <= 10000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'평균비용 사원';
            WHEN V_SAL <= 20000 THEN
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'고비용 사원';
            ELSE 
                V_RES := RPAD(V_ENAME, 40)||TO_CHAR(V_SAL,'99,999')||'초고도비용 사원';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);        
        FETCH   EMP01_CUR INTO V_ENAME, V_SAL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('사원 수 : '||EMP01_CUR%ROWCOUNT);
    CLOSE   EMP01_CUR;
END;

 3) FOR 문
  . 반복횟수를 알거나 반복횟수가 중요한 경우 사용
  . 개발언어의 FOR 문과 같은 기능 제공
  (일반 FOR 문 사용형식)
  FOR 레코드명 IN [REVERSE] 초기값..최종값 LOOP
    반복처리명령문(들);
  END LOOP;
   - '인덱스명' : '초기값' 에서 '최종값'을 1씩 변화시켜 저장할 변수로 -- 증감 폭 조절 불가
                시스템에서 자동으로 확보(선언 불필요)
   - 'REVERSE' : 역순으로 처리할 때 사용('초기값..최종값'은 변경하지 않음)
   
  (커서사용 FOR 문 사용형식)
  FOR 레코드명 IN 커서명|커서 생성 in-line subquery LOOP
    반복처리명령문(들);
  END LOOP;
   - '레코드명' : 커서내의 각 행들을 저장할 변수로
                시스템에서 자동으로 확보(선언 불필요)
   - '커서 생성 in-line subquery' : 커서생성 SELECT 문
   - 커서의 컬럼참조는 '레코드명.커서컬럼명'으로 참조
   - 커서의 행의 수만큼 반복수행
   - 커서의 OPEN, FETCH, CLOSE 문 불필요       -- 대부분의 커서 사용은 FOR 문으로
   
사용 예) 구구단 5단을 출력하시오

DECLARE
    V_CNT NUMBER := 0;
BEGIN
    FOR V_CNT IN 1..9 LOOP    
        DBMS_OUTPUT.PUT_LINE('5 * '||V_CNT||' = '||V_CNT*5);
    END LOOP;
END;

사용 예) 사원테이블에서 임의의 부서를 선택하여 해당부서에 소속된 사원들의 급여를 조회하고 
        그 급여가 
            1 ~ 5000  : '저비용 사원'
         5001 ~ 10000 : '평균비용 사원'
        10001 ~ 20000 : '고비용 사원'
                그 이상 : '초고도비용 사원'을 사원명, 급여와 함께 출력하시오
                
DECLARE
    V_CNT NUMBER := 0;
    V_RES VARCHAR2(100);        -- 결과
    CURSOR EMP01_CUR IS
        SELECT  EMP_NAME, SALARY
        FROM    HR.EMPLOYEES
        WHERE   DEPARTMENT_ID = 80;
BEGIN
    DBMS_OUTPUT.PUT_LINE('부서번호 : 80');
    FOR REC IN EMP01_CUR LOOP 
        V_CNT := V_CNT + 1;
        CASE WHEN REC.SALARY <= 5000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'저비용 사원';
            WHEN REC.SALARY <= 10000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'평균비용 사원';
            WHEN REC.SALARY <= 20000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'고비용 사원';
            ELSE 
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'초고도비용 사원';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);      
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('사원 수 : '||V_CNT); -- 반복문 외부에서 커서 사용 불가
END;

    (IN-LINE SUBQUERY 사용)
DECLARE
    V_CNT NUMBER := 0;
    V_RES VARCHAR2(100);        -- 결과
BEGIN
    DBMS_OUTPUT.PUT_LINE('부서번호 : 80');
    FOR REC IN (SELECT  EMP_NAME, SALARY
                FROM    HR.EMPLOYEES
                WHERE   DEPARTMENT_ID = 80) LOOP 
        V_CNT := V_CNT + 1;
        CASE WHEN REC.SALARY <= 5000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'저비용 사원';
            WHEN REC.SALARY <= 10000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'평균비용 사원';
            WHEN REC.SALARY <= 20000 THEN
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'고비용 사원';
            ELSE 
                V_RES := RPAD(REC.EMP_NAME, 40)||TO_CHAR(REC.SALARY,'99,999')||'초고도비용 사원';
        END CASE;
    
        DBMS_OUTPUT.PUT_LINE(V_RES);      
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('사원 수 : '||V_CNT); -- 반복문 외부에서 커서 사용 불가
END;