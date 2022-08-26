2022-0826-03) 순위 함수
 - 특정 컬럼의 값을 기준으로 순위(등수)를 부여할 때 사용
 - RANK(), DENSE_RANK(), ROW_NUMBER() 등이 제공됨
 1)  RANK()
  - 일반적인 순위함수
  - 같은 값이면 같은 순위를 부여하고 다음 순위는 ‘현 순위 + 동일 순위 개수’로 부여
    ex) 1, 1, 3, 4, 5, 6, 7, 7, 7, 10…
  (사용형식)
    RANK() OVER(ORDER BY 컬럼명1 [DESC|ASC][,컬럼명2 [DESC|ASC],…])
    - SELECT 문의 SELECT 절에 사용

사용 예) 회원테이블에서 회원번호, 회원명, 마일리지, 순위를 조회하시오.
        순위는 마일리지가 많은 회원부터 부여하고 같은 마일리지이면 같은 순위를 부여하시오.
    SELECT	MEM_ID		AS	회원번호,   
            MEM_NAME	AS	회원명,
            MEM_MILEAGE	AS	마일리지,
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) AS 나이,
            -- RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS 순위,
            -- RANK() OVER(ORDER BY MEM_MILEAGE DESC, MEM_ID) AS. 순위,
            RANK() OVER(ORDER BY MEM_MILEAGE DESC,                                -- 마일리지 먼저 적용 후
            (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR)) DESC) AS 순위-- 나이 적용 마일리지를 가지고 등수를 구분하지 못할 때
    FROM	MEMBER;
    
 2) DENSE_RANK()
  . 순위를 구하는 기능은 RANK()와 동일
  . 동일 순위가 복수개 발생하더라도 다음 순위는 현재순위 바로 다음 순위로 부여
    ex) 1,1,2,3,4,5,6,7,7,7,8,9,...
  (사용형식)
  DENSE_RANK() OVER(ORDER BY 컬럼명 [DESC|ASC][,컬럼명2 [DESC|ASC],...)
  - SELECT 문의 SELECT 절에 사용
  
사용 예) 
    SELECT	MEM_ID		AS	회원번호,   
            MEM_NAME	AS	회원명,
            MEM_MILEAGE	AS	마일리지,
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) AS 나이,
            -- RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS 순위,
            DENSE_RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS 순위
            -- RANK() OVER(ORDER BY MEM_MILEAGE DESC, MEM_ID) AS. 순위,
            -- RANK() OVER(ORDER BY MEM_MILEAGFE DESC,                              -- 마일리지 먼저 적용 후
            -- (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) DESC) AS 순위-- 나이 적용 마일리지를 가지고 등수를 구분하지 못할 때
    FROM	MEMBER;
  
 3) ROW_NUMBER()
  . 순위를 부여하는 함수
  . 동점자도 행의 순번에 따라 순위를 부여
    ex) 90,90,85,84,80,78,78,78,75
    순위  1, 2, 3, 4, 5, 6, 7, 8, 9
    
  (사용형식)
  ROW_NUMBER() OVER(ORDER BY 컬럼명1 [DESC|ASC][,컬럼명2 [DESC|ASC],...])
   - SELECT 문의 SELECT 절에 사용
   
사용 예) 
    SELECT	MEM_ID		AS	회원번호,   
            MEM_NAME	AS	회원명,
            MEM_MILEAGE	AS	마일리지,
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) AS 나이,
            -- RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS 순위,
            ROW_NUMBER() OVER(ORDER BY MEM_MILEAGE DESC) AS 순위
            -- RANK() OVER(ORDER BY MEM_MILEAGE DESC, MEM_ID) AS. 순위,
            -- RANK() OVER(ORDER BY MEM_MILEAGFE DESC,                              -- 마일리지 먼저 적용 후
            -- (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) DESC) AS 순위-- 나이 적용 마일리지를 가지고 등수를 구분하지 못할 때
    FROM	MEMBER;
    
 4) 그룹별 순위
  . 자료를 그룹으로 분류하고 각 그룹 내에서 특정 컬럼의 값을 기준으로 순위를 부여
  . PARTITION BY 예약어로 그룹을 구성함
  (사용형식)
  RANK() OVER(PARTITION BY 컬럼명p1[,컬럼명p2,...] ORDER BY 컬럼명b1 [DESC|ASC] 
        [, 컬럼명b2 [DESC|ASC],...])
    - SELECT 문의 SELECT 절에 사용

사용 예) 사원테이블에서 부서별로 급여에 따른 순위를 부여하시오
        Alias 사원번호, 사원명, 부서번호, 급여, 순위
        순위는 급여가 많은 사람 순으로
        같은 급여는 동일 순위 부여할 것
        
    SELECT  EMPLOYEE_ID AS 사원번호, 
            EMP_NAME AS 사원명, 
            DEPARTMENT_ID AS 부서번호, 
            SALARY AS 급여, 
            RANK() OVER(PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS 순위 
            -- ~별 = PARTITION BY ~
    FROM    HR.EMPLOYEES;
    