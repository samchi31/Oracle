2022-0913-01) 트리거(trigger)      -- 숙련자가 아니라면 사용을 매우 조심
 - 특정 이벤트가 발생되었을 때 이 이벤트로 이전이나 이후 자동적으로 실행되는 프로시저를 의미
 (사용형식)
 CREATE [OR REPLACE] TRIGGER 트리거명
    트리거타이밍 AFTER|BEFORE 이벤트 INSERT | UPDATE | DELETE
    ON 테이블명             -- 이벤트의 대상이 되어지는 테이블
    [FOR EACH ROW]
    [WHEN 조건]
    [DECLARE
        선언부(변수, 상수, 커서 선언문);
    ]
 BEGIN
    트리거 본문;         -- TCL(COMMIT 등) 사용불가
 END;
  - 트리거타이밍 : 트리거 본문이 실행될 시점.
   . AFTER : 이벤트가 발생된 후 트리거 본문 실행
   . BEFORE : 이벤트가 발생되기 전 트리거 본문 실행
  - 트리거 이벤트 : 트리거를 유발시키는 DML 명령으로 OR 로 연결시킬 수 있음        
                  INSERT OR DELETE OR UPDATE, INSERT OR UPDATE 등, 
                  트리거 함수 INSERTING, UPDATING, DELETING 사용       -- IF와 같이 사용
  - 트리거 유형
   . 문장 단위 트리거 : 'FOR EACH ROW'가 생략된 경우로 이벤트 수행에 오직 한번만 트리거 수행
   . 행 단위 트리거 : 이벤트의 결과가 복수개 행으로 구성될 때 각 행마다 트리거 본문 수행
                    'FOR EACH ROW' 기술해야 함. 트리거 의사레코드 :OLD, :NEW 사용 가능
                    
사용 예) 분류테이블에서 LPROD_ID가 13번인 자료를 삭제하시오. 삭제 후 '자료가 삭제되었습니다'를 출력하는 트리거 작성

    CREATE OR REPLACE TRIGGER tg_delete_lprod
        AFTER DELETE ON LPROD
    BEGIN   
        DBMS_OUTPUT.PUT_LINE('자료가 삭제');
    END;
    
    ROLLBACK;
    DELETE  FROM LPROD WHERE LPROD_ID= 13;
    SELECT  * FROM LPROD;
    
    DELETE  FROM LPROD WHERE LPROD_ID = 13;
    COMMIT;
    
사용 예) 2020년 6월 12일이라 했을 때 
        상품코드     매입가격  수량
        P201000019  210000  5       (P201000019	22	0	0	22	2020/01/01)
        P201000009  28500   3       (P201000009	9	26	0	35	2020/01/31)
        P202000012  55000   7   
        을 매입한 경우 이를 매입테이블(BUYPROD)에 저장한 후
        재고수불테이블을 수정하는 트리거를 작성하시오
        
    CREATE OR REPLACE TRIGGER tg_buyprod_insert
        AFTER INSERT ON BUYPROD
        FOR EACH ROW
    DECLARE
        V_PID PROD.PROD_ID%TYPE := (:NEW.BUY_PROD);     --매입상품코드
        V_QTY NUMBER := (:NEW.BUY_QTY);         --매입수량
    BEGIN
        UPDATE  REMAIN A
        SET     A.REMAIN_I = A.REMAIN_I + V_QTY,
                A.REMAIN_J_99 = A.REMAIN_J_99 + V_QTY,
                A.REMAIN_DATE = SYSDATE
        WHERE   A.PROD_ID = V_PID;
    END;
    
    (실행)
    INSERT INTO BUYPROD VALUES(SYSDATE, 'P201000019', 5, 210000);
    
사용 예) 사원번호 190 - 194번까지 5명을 퇴직처리하시오
        퇴직자 정보는 사원테이블에서 삭제되기 전에 필요 정보만 퇴직자테이블에 저장하시오
        
    CREATE OR REPLACE TRIGGER tg_delete_emp1
        BEFORE  DELETE ON HR.EMPLOYEES
        FOR EACH ROW
    BEGIN
        INSERT INTO RETIRE
                VALUES(:OLD.EMPLOYEE_ID, :OLD.EMP_NAME, :OLD.JOB_ID, :OLD.HIRE_DATE, SYSDATE, :OLD.DEPARTMENT_ID);
    END;
    
    DELETE  FROM EMPLOYEES
    WHERE   EMPLOYEE_ID BETWEEN 190 AND 194;
    
사용 예) 다음 매출자료가 발생한 후의 작업을 트리거로 작성하시오
        구매회원 : 오철희('k001', 5000 포인트)
        구매 상품코드 : 'P202000010' (2020	P202000010	38	42	0	80	2020/01/31)
        구매 수량 : 5
        
    CREATE OR REPLACE TRIGGER tg_change_cart
        AFTER INSERT OR UPDATE OR DELETE ON CART
        FOR EACH ROW
    DECLARE
        V_QTY NUMBER := 0;
        V_PID PROD.PROD_ID%TYPE;
        V_DATE DATE;
        V_MID MEMBER.MEM_ID%TYPE;
        V_MILE NUMBER := 0;
    BEGIN
        IF INSERTING THEN
            V_QTY := (:NEW.CART_QTY);
            V_PID := (:NEW.CART_PROD);
            V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO,1,8));
            V_MID := (:NEW.CART_MEMBER);
        ELSIF UPDATING THEN
            V_QTY := (:NEW.CART_QTY) - (:OLD.CART_QTY);
            V_PID := (:NEW.CART_PROD);
            V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO,1,8));
            V_MID := (:NEW.CART_MEMBER);
        ELSIF DELETING THEN
            V_QTY := -(:OLD.CART_QTY);
            V_PID := (:OLD.CART_PROD);
            V_DATE := TO_DATE(SUBSTR(:OLD.CART_NO,1,8));
            V_MID := (:OLD.CART_MEMBER);
        END IF;
        
        UPDATE  REMAIN
        SET     REMAIN_O = REMAIN_O + V_QTY,
                REMAIN_J_99 = REMAIN_J_99 - V_QTY,
                REMAIN_DATE = V_DATE
        WHERE   PROD_ID = V_PID;
        
        SELECT  V_QTY * PROD_MILEAGE INTO V_MILE
        FROM    PROD
        WHERE   PROD_ID = V_PID;
        
        UPDATE  MEMBER
        SET     MEM_MILEAGE = MEM_MILEAGE + V_MILE
        WHERE   MEM_ID = V_MID;
    END;
    
    INSERT INTO CART VALUES('k001', FN_CREATE_CARTNO(SYSDATE), 'P202000010', 5);
    
    (3개 반품      2020	P202000010	38	42	5	65	2020/06/12)
    UPDATE  CART
    SET     CART_QTY = 2
    WHERE   CART_NO = '2020061200002'
    AND     CART_PROD = 'P202000010';
    
    (구매 취소)
    DELETE  FROM CART
    WHERE   CART_NO = '2020061200002'
    AND     CART_PROD = 'P202000010';
    
    ROLLBACK;