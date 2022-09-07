2022-0907-02) stored Procedure(Procedure)
 - 특정 로직을 처리하여 그 결과 값을 반환하지 않는 서브 프로그램
 - 미리 컴파일되어 저장(실행의 효율성이 좋고, 네트워크를 통해 전달되는 자료의 양이 작다)
 (사용형식)
 CREATE [OR REPLACE] PROCEDURE 프로시저명[(
    변수명 [IN|OUT|INOUT] 데이터타입[:=디폴트값],   -- IN|OUT|INOUT 생략 시 IN으로 취급
                :
    변수명 [IN|OUT|INOUT] 데이터타입[:=디폴트값])]
 IS|AS
    선언영역        -- 변수선언
 BEGIN
    실행영역        -- SQL, 반복, 분기문
 END;
  . '변수명' : 매개변수명
  . 'IN|OUT|INOUT' : 매개변수의 역할 정의(IN:입력용, OUT:출력용, INOUT:입출력 공용) --반환값 아님 SELECT 절에서 사용불가
  . '데이터타입' : 크기를 기술하면 오류                                           -- INOUT 부하가 심해서 사용 자제 권고
  . '디폴트값' : 사용자가 매개변수를 기술하고 값을 배정하지 않았을 때 자동으로 할당될 값   -- 사용자제 권고
  
  (실행문)
  EXECUTE|EXEC 프로시저명[(매개변수list)];
  또는 프로시저나 다른 블록에서 실행할 경우
  프로시저명[(매개변수list)];    -- OUT 매개변수 일때 ..?
  
사용 예) 부서번호를 입력받아 해당부서의 부서장의 이름, 직책, 부서명, 급여를 출력하는 프로시저를 작성하시오
    CREATE OR REPLACE PROCEDURE PROC_EMP01(
        P_DID IN HR.DEPARTMENTS.DEPARTMENT_ID%TYPE)
    IS
        V_NAME VARCHAR2(100);
        V_JOBID HR.JOBS.JOB_ID%TYPE;
        V_DNAME VARCHAR2(100);
        V_SAL NUMBER := 0;
    BEGIN
        SELECT  B.EMP_NAME, B.JOB_ID, A.DEPARTMENT_NAME, B.SALARY
        INTO    V_NAME, V_JOBID, V_DNAME, V_SAL
        FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
        WHERE   A.DEPARTMENT_ID = P_DID
        AND     A.MANAGER_ID = B.EMPLOYEE_ID;
        
        DBMS_OUTPUT.PUT_LINE('부서코드 : '||P_DID);
        DBMS_OUTPUT.PUT_LINE('부서장 : '||V_NAME);
        DBMS_OUTPUT.PUT_LINE('직무 : '||V_JOBID);
        DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DNAME);
        DBMS_OUTPUT.PUT_LINE('급여 : '||V_SAL);
    END;
    
    (실행)
    EXECUTE PROC_EMP01(60);