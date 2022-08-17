2022-0817-01) 함수
 - 오라클사에서 미리 작성 및 컴파일하여 실행 가능한 상태
   프로그램 모듈
 - 함수는 반환 값이 존재
 - 유형
    . 단일행함수 : 테이블에 저장된 개별 행을 대상으로 적용하여 하나의 결과를 반환
                 SELECT, WHERE, ORDER BY 절에 사용 가능
                 중첩사용 가능
                 문자열, 숫자, 날짜, 형변환, NULL처리 함수 등으로 분류
    . 복수행함수 : 여러 행들을 그룹화하여 각 그룹에 대한 집계 결과를 반환
                 중첩사용 불가        -- 단일 + 복수 는 중첩 가능
                 GROUP BY 절을 사용해야 함
                 SUM, AVG, COUNT, MIN, MAX 등이 있음    -- 그룹함수 5개 꼭 외우기
                 
1. 문자열 함수
 1) CONCAT(c1, c2)
    - 주어진 두 문자열 c1과 c2를 결합하여 새로운 문자열을 반환
    - 문자열 결합연산자 '||'과 같은 기능
    
사용 예) 회원테이블에서 여성회원의 회원번호, 회원명, 주민번호, 직업을 출력
        단, 주민번호는 'XXXXXX-XXXXXXX'형식으로 출력
    ('||' 사용)
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명, 
           MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
           MEM_JOB AS 직업
    FROM   MEMBER
    WHERE  SUBSTR(MEM_REGNO2,1,1) IN ('2','4');
    (CONCAT 사용)     -- 불편해서 많이 사용 안함
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명, 
           CONCAT(CONCAT(MEM_REGNO1, '-'),MEM_REGNO2) AS 주민번호, 
           MEM_JOB AS 직업
    FROM   MEMBER
    WHERE  SUBSTR(MEM_REGNO2,1,1) IN ('2','4');

 2) LOWER(c1), UPPER(c1), INITCAP(c1) 
    - 대문자를 소문자로(LOWER), 소문자를 대문자로(UPPER), 단어의 첫 글자만 대문자로(INITCAP) 바꾸어 주는 함수
    - 주로 소문자(대문자)와 숫자 등의 결합으로 구성된 컬럼 값을 조회하거나(LOWER,UPPER),
      이름 등을 구성(INITCAP)할 때 사용
      
사용 예) 상품의 분류코드가 'p202'에 속한 분류명과 상품의 수를 출력       --테이블 2개 사용(LPROD:분류명, PROD:분류코드)
    -- JOIN 사용(관계데이터베이스에서 사용) / 양 쪽의 같은 컬럼명을 가진 속성들을 비교
    SELECT B.LPROD_NM AS 분류명, 
           COUNT(*) AS "상품의 수"        --별칭에 공간 있을 시 쌍따옴표
    FROM   PROD A, LPROD B              --테이블에 별칭 (AS 사용 X)
    WHERE  A.PROD_LGU = B.LPROD_GU      --테이블 두 개 사용 시 WHERE 필수
      AND  LOWER(A.PROD_LGU) = 'p202'
    GROUP  BY B.LPROD_NM;
    
사용 예)
    SELECT  EMPLOYEE_ID AS 사원번호,
            EMP_NAME AS 사원명,
            LOWER(EMP_NAME),
            UPPER(EMP_NAME),
            INITCAP(LOWER(EMP_NAME))
    FROM    HR.EMPLOYEES;
    
    SELECT  LOWER(EMAIL)||'@gmail.com' AS 이메일주소
    FROM    HR.EMPLOYEES;
    
 3) LPAD(c1,n[,c2]), RPAD(c1,n[,c2])
    - LPAD : 주어진 문자열 c1을 지정된 기억공간의 n에 오른쪽부터 저장하고 남는 공간에 c2 문자열 왼쪽에 삽입
             단 c2가 생략되면 공백을 삽입
             수표보호문자로 주로 사용
    - RPAD : 주어진 문자열 c1을 지정된 기억공간의 n에 왼쪽부터 저장하고 남는 공간에 c2 문자열 오른쪽에 삽입
             단 c2가 생략되면 공백을 삽입
             
사용 예) 
    SELECT  LPAD('대전시 중구', 20, '*'),
            LPAD('대전시 중구', 20),
            RPAD('대전시 중구', 20, '*'),
            RPAD('대전시 중구', 20)
    FROM    DUAL;

사용 예) 회원테이블에서 마일리지가 많은 회원 3명이 2020년 4-6월 구매한 정보를 조회하시오
        컬럼은 회원번호, 회원명, 마일리지, 구매금액합계 이다.
    SELECT  A.MEM_ID AS 회원번호,
            A.MEM_NAME AS 회원명,
            A.MEM_MILEAGE AS 마일리지,
            F.FSUM AS 구매금액합계
    FROM    MEMBER A,
            (SELECT E.CART_MEMBER AS CMID,
                    SUM(E.CART_QTY*D.PROD_PRICE) AS FSUM
             FROM   (SELECT C.MEM_ID AS DMID
                     FROM   (SELECT MEM_ID, MEM_MILEAGE
                             FROM   MEMBER
                             ORDER  BY 2 DESC) C
                     WHERE ROWNUM <= 3) B,
                    PROD D,
                    CART E
             WHERE   B.DMID = E.CART_MEMBER
             AND     D.PROD_ID = E.CART_PROD
             AND     SUBSTR(E.CART_NO,1,6) BETWEEN '202004' AND '202006'
             GROUP   BY E.CART_MEMBER) F
    WHERE   F.CMID = A.MEM_ID;
    
 DECLARE
    CURSOR  CUR_MILE IS
    SELECT  C.MEM_ID AS DMID,
            C.MEM_MILEAGE AS DMILE,
            C.MEM_NAME AS DNAME
    FROM    (SELECT MEM_ID, MEM_MILEAGE, MEM_NAME
             FROM   MEMBER
             ORDER  BY 2 DESC) C
    WHERE   ROWNUM <= 3;
    V_SUM NUMBER:=0;
    V_RES   VARCHAR2(100);
 BEGIN
    FOR REC IN CUR_MILE LOOP
        SELECT  SUM(A.CART_QTY * B.PROD_PRICE) INTO V_SUM
        FROM    CART A, PROD B
        WHERE   A.CART_MEMBER = REC.DMID
        AND     SUBSTR(A.CART_NO,1,6) BETWEEN '202004' AND '202006'
        AND     A.CART_PROD = B.PROD_ID;    
        V_RES:=REC.DMID||' '||REC.DNAME||' '||REC.DMILE||LPAD(V_SUM,12);   --TO_CHAR(V_SUM,'99,999,999');
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END LOOP;
 END;
