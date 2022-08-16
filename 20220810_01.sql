2022-0810-01)
4. 기타연산자
 - 오라클에서 제공하는 기타 연산자는 IN, ANY, SOME, ALL, EXISTS, BETWEEN, LIKE 연산자가 있음
 - EXISTS 는 SUBQUERY가 반드시 뒤에 와야함 ( IN , ANY, SOME, ALL 은 괄호 안에 값만 적어도 됨)
 1) IN 연산자
  . IN 연산자에는 '='(Equal to) 기능이 내포
  . IN 다음 '( )'안에 기술된 값 중 어느 하나와 일치하면 전체 결과가 참(TRUE)을 반환
  . IN 연산자는 '=ANY', '=SOME'으로 치환 가능
  . IN 연산자는 OR 연산자로 치환 가능
  (사용 형식)
   expr IN (값1,값2,..값n);
   => expr = 값1 OR expr = 값2 OR ... OR expr = 값n;
  . IN 연산자는 불연속적인 값이나 불규칙한 값을 비교할 때 주로 사용
   => 연속적인 값은 보통 BETWEEN 사용 

사용 예) 사원테이블에서 부서번호가 20, 50, 60, 100번에 속한 사원들을 조회
        Alias는 사원번호, 사원명, 부서번호, 입사일
    (OR 사용)
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           DEPARTMENT_ID AS 부서번호, 
           HIRE_DATE AS 입사일
      FROM HR.EMPLOYEES
     WHERE DEPARTMENT_ID =20
        OR DEPARTMENT_ID =50
        OR DEPARTMENT_ID =60
        OR DEPARTMENT_ID =100
     ORDER BY 3;
     
    (IN 사용)
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           DEPARTMENT_ID AS 부서번호, 
           HIRE_DATE AS 입사일
      FROM HR.EMPLOYEES
     WHERE DEPARTMENT_ID IN (20, 50, 60, 100)
     ORDER BY 3;
     
    (ANY, SOME 사용)
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           DEPARTMENT_ID AS 부서번호, 
           HIRE_DATE AS 입사일
      FROM HR.EMPLOYEES
     --WHERE DEPARTMENT_ID = ANY(20, 50, 60, 100)
     WHERE DEPARTMENT_ID = SOME(20, 50, 60, 100)
     ORDER BY 3;
     
 2) ANY(SOME) 연산자
  . IN 연산자와 비슷한 기능 제공
  . ANY 와 SOME 은 동일 기능
  (사용형식)
   expr 관계연산자 ANY|SOME(값1,...,값n) -- 관계연산자 필수 (=,!=,>,<...)
    - expr의 값이 ( )안의 값 중 어느 하나와 제시된 관계연산자를 만족하면 전체가 참(TRUE)을 반환 함
    
사용 예) 사원테이블에서 부서번호 60번 부서에 속한 사원들의 급여 중 가장 적은 급여보다 더 많은 급여를 받는 사원들을 조회
        Alias는 사원번호, 사원명, 급여, 부서번호이며 급여가 적은 사람부터 출력하시오

    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           SALARY AS 급여,
           DEPARTMENT_ID AS 부서번호
      FROM hr.EMPLOYEES
     WHERE SALARY > ANY(SELECT SALARY               -- SOME (~ 과 같음
                          FROM HR.EMPLOYEES         -- WHERE SALARY > ANY(9000,6000,4800,4200)
                         WHERE DEPARTMENT_ID = 60) 
       AND DEPARTMENT_ID != 60
     ORDER BY 3; 
     --알려있지않은 값을 기반을 비교할 때 => SUBQUERY
     
사용 예) 2020년 4월 판매된 상품 중 매입되지 않은 상품을 조회하시오
        Alias는 상품코드이다.
        
    SELECT DISTINCT CART_PROD AS 상품코드
      FROM CART
     WHERE CART_NO LIKE '202004%'           
       AND NOT CART_PROD = ANY(SELECT DISTINCT BUY_PROD      --매출 != 매입;
                                 FROM BUYPROD
                                WHERE BUY_DATE >= '20200401' AND BUY_DATE <= '20200430');                            
  
 3) ALL 연산자
 (사용형식)
  expr 관계연산자 ALL(값1,...,값n)
  - expr의 값이 주어진 '값1'~'값n'의 모든 값과 관계연산을 수행한 결과가 참이면
    WHERE 절의 결과를 TRUE로 반환
  - ANY(SOME)은 가장 작은 값을 기준으로 하고, ALL 은 가장 큰 값을 기준으로 함
  - '='과 같이 사용 불가 (논리적으로 안됨)
  
사용 예) 사원테이블에서 부서번호 60번 부서에 속한 사원들의 급여 중 가장 많은 급여보다 더 많은 급여를 받는 사원들을 조회
        Alias는 사원번호, 사원명, 급여, 부서번호이며 급여가 적은 사람부터 출력하시오

    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           SALARY AS 급여,
           DEPARTMENT_ID AS 부서번호
      FROM hr.EMPLOYEES
     WHERE SALARY > ALL(9000,6000,4800,4200)  -- 9000보다 큰사람만 찾음
     ORDER BY 3; 
     
     