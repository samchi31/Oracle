2022-0902-02) 오라클 객체
1. VIEW 객체
 - TABLE과 유사한 객체
 - 기존의 테이블이나 VIEW를 대상으로 새로운 SELECT 문의 결과가  VIEW 가 됨
 - SELECT 문의 종속 객체가 아니라 독립 객체임
 - 사용이유
  . 필요한 정보가 분산되어 매번 조인을 필요로 하는 경우
  . 특정자료의 접근을 제한한고자 하는 경우(보안상)
 (사용형식)
 CREATE [OR REPLACE] VIEW 뷰이름 [(컬럼 list)]
 AS
    SELECT 문
    [WITH READ ONLY]
    [WITH CHECK OPTION];    
    
  . 'OR REPLACE' : 이미 존재하는 뷰인 경우 기존의 뷰를 대치하고 존재하지 않는 뷰는 생성
  . '(컬럼 list)' : 뷰에서 사용할 컬럼명. 
                        (생략하면 
                        1) 뷰를 생성하는 SELECT 문의 SELECT 절에 컬럼별칭이 사용되었으면
                            컬럼별칭이 뷰의 컬럼명이 됨
                        2) 뷰를 생성하는 SELECT 문의 SELECT 절에 컬럼별칭이 사용되지 않았으면
                            SELECT 절의 컬럼명이 뷰의 컬럼명이 됨
  . 'WITH READ ONLY' : 읽기전용뷰(뷰에만 적용)    -- 테이블 변경은 얼마든지 가능
  . 'WITH CHECK OPTION' : 생성된 뷰를 대상으로 뷰를 생성하는 SELECT 문의 조건절을 위배하도록 하는
                            DML 명령을 사용할 수 없음(뷰에만 적용)
**** 'WITH READ ONLY'와 'WITH CHECK OPTION'는 같이 사용할 수 없음

사용 예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지로
        뷰를 생성하시오
    
    CREATE OR REPLACE VIEW V_MEM01--(MID,MNAME,MJOB,MILE)
    AS
        SELECT  MEM_ID,-- AS 회원번호,
                MEM_NAME,-- AS 회원명,
                MEM_JOB,-- AS 직업,
                MEM_MILEAGE-- AS 마일리지
        FROM    MEMBER
        WHERE   MEM_MILEAGE >= 3000;

    SELECT * FROM V_MEM01;

 ** V_MEM01 에서 오철희 회원(k001)의 마일리지를 2000으로 변경
    
    UPDATE  V_MEM01
    SET     MEM_MILEAGE = 2000
    WHERE   MEM_ID = 'k001';

 ** MEMBER 에서 오철희 회원(k001)의 마일리지를 5000으로 변경
    
    UPDATE  MEMBER
    SET     MEM_MILEAGE = 5000
    WHERE   MEM_ID = 'k001';
    
 ** MEMBER 에서 모든 회원들의 마일리지를 1000씩 추가 지급
    
    UPDATE  MEMBER
    SET     MEM_MILEAGE = MEM_MILEAGE + 1000;
    
    (읽기전용 뷰)
    CREATE OR REPLACE VIEW V_MEM01(MID,MNAME,MJOB,MILE)
    AS
        SELECT  MEM_ID,-- AS 회원번호,
                MEM_NAME,-- AS 회원명,
                MEM_JOB,-- AS 직업,
                MEM_MILEAGE-- AS 마일리지
        FROM    MEMBER
        WHERE   MEM_MILEAGE >= 3000
        WITH    READ ONLY;

 ** MEMBER 테이블에서 모든 회원의 마일리지를 1000씩 감소시키시오
    
    UPDATE  MEMBER
    SET     MEM_MILEAGE = MEM_MILEAGE - 1000;

COMMIT;

 ** 뷰 V_MEM01의 자료에서 오철희 회원의 마일리지('k001')를 3700으로 변경
 
    UPDATE  V_MEM01
    SET     MILE = 3700
    WHERE   MID = 'k001';
    -- 오류발생 : READ ONLY 로 만들어서 뷰 수정불가 (SELECT만 가능)
    
    (조건부여 뷰)
    CREATE OR REPLACE VIEW V_MEM01(MID,MNAME,MJOB,MILE)
    AS
        SELECT  MEM_ID,-- AS 회원번호,
                MEM_NAME,-- AS 회원명,
                MEM_JOB,-- AS 직업,
                MEM_MILEAGE-- AS 마일리지
        FROM    MEMBER
        WHERE   MEM_MILEAGE >= 3000
        WITH    CHECK OPTION;
        
 ** 뷰 V_MEM01에서 신용환 회원('c001')의 마일리지를 5500으로 변경하시오
 
    UPDATE  V_MEM01
    SET     MILE = 5500
    WHERE   MID = 'c001';
    -- MEM_MILEAGE >= 3000 조건을 위배하지 않으면 수정 가능
    -- 뷰가 바뀌면 원본 테이블 값도 변경
    
 ** 뷰 V_MEM01에서 신용환 회원('c001')의 마일리지를 1500으로 변경하시오
 
    UPDATE  V_MEM01
    SET     MILE = 1500 -- 에러 발생 : MEM_MILEAGE >= 3000을 위배
    WHERE   MID = 'c001';
    
 ** MEMBER 테이블에서 신용환 회원('c001')의 마일리지를 1500으로 변경하시오
 
    UPDATE  MEMBER
    SET     MEM_MILEAGE = 1500 
    WHERE   MEM_ID = 'c001';
    -- 테이블은 언제든지 수정 가능 => 뷰에 반영됨

ROLLBACK;