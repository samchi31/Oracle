2022-0830-01)
5. SEMI Join
 - 세미조인은 서브쿼리를 이용하는 조인으로 서브 쿼리의 결과 내에서 최종결과를 추출하는 조인
 - IN, EXISTS 연산자를 사용하는 조인
 
사용 예) 사원테이블에서 급여가 10000이상인 사원이 존재하는 부서를 조회하시오
        Alias 부서코드, 부서명, 관리사원명
    (IN 연산자)    
        SELECT  A.DEPARTMENT_ID AS 부서코드, 
                A.DEPARTMENT_NAME AS 부서명, 
                B.EMP_NAME AS 관리사원명
        FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
        WHERE   A.DEPARTMENT_ID IN(서브쿼리)
        AND     A.MANAGER_ID = B.EMPLOYEE_ID
        ORDER   BY  1;
        (서브쿼리 : 급여가 10000이상인 사원이 존재하는 부서)
        SELECT  DISTINCT DEPARTMENT_ID 
        FROM    HR.EMPLOYEES
        WHERE   SALARY >= 10000;        
    (결합)
    SELECT  A.DEPARTMENT_ID AS 부서코드, 
            A.DEPARTMENT_NAME AS 부서명, 
            B.EMP_NAME AS 관리사원명
    FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
    WHERE   A.DEPARTMENT_ID IN(SELECT  DISTINCT DEPARTMENT_ID -- 조인조건 비동등조인(세미조인)
                                FROM    HR.EMPLOYEES
                                WHERE   SALARY >= 10000)
    AND     A.MANAGER_ID = B.EMPLOYEE_ID                    -- 조인조건 동등조인
    ORDER   BY  1;
    
    (EXISTS 연산자)   
    SELECT  A.DEPARTMENT_ID AS 부서코드, 
            A.DEPARTMENT_NAME AS 부서명, 
            B.EMP_NAME AS 관리사원명
    FROM    HR.DEPARTMENTS A, HR.EMPLOYEES B
    WHERE   EXISTS(SELECT   1
                    FROM    HR.EMPLOYEES C
                    WHERE   C.SALARY >= 10000
                    AND     A.DEPARTMENT_ID = C.DEPARTMENT_ID)      -- 조인 조건
    AND     A.MANAGER_ID = B.EMPLOYEE_ID
    ORDER   BY  1;
    
6. SELF Join
 - 하나의 테이블에 2개 이상의 별칭을 부여하여 서로 다른 테이블로 간주한 후 조인을 수행하는 방법
 
사용 예) 회원테이블에서 '오철희' 회원의 마일리지보다 많은 마일리지를 보유한 회원정보를 출력
        Alias 회원번호, 회원명, 직업, 마일리지
    
    SELECT  B.MEM_ID AS 회원번호, 
            B.MEM_NAME AS 회원명, 
            B.MEM_JOB AS 직업, 
            B.MEM_MILEAGE AS 마일리지
    FROM    MEMBER A, MEMBER B          -- A 테이블 : 오철희의 조건, B 테이블 : 조건과 비교한 다른 사람들
    WHERE   A.MEM_NAME = '오철희'
    AND     A.MEM_MILEAGE < B.MEM_MILEAGE;
    
사용 예) 상품코드 'P202000012'와 같은 분류에 속한 상품 중 'P202000012'보다 매입단가가 큰 상품을 조회하시오
        Alias   상품코드, 상품명, 분류명, 매입단가
        
    SELECT  B.PROD_ID AS 상품코드, 
            B.PROD_NAME AS 상품명, 
            C.LPROD_NM AS 분류명, 
            B.PROD_COST AS 매입단가
    FROM    PROD A, PROD B, LPROD C     -- 상품코드 조건 테이블, 분류코드 비교 테이블,
    WHERE   A.PROD_ID = 'P202000012'
    AND     A.PROD_LGU = B.PROD_LGU     -- 조인조건 Equi
    AND     A.PROD_COST < B.PROD_COST   -- 조인조건 NON-Equi
    AND     A.PROD_LGU = C.LPROD_GU;    -- 조인조건 Equi