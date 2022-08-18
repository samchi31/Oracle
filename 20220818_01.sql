2022-0818-01) 
2. 숫자함수
 - 제공되는 숫자함수로는 수학적 함수(ABS, SIGN, SQRT 등), GREATEST, ROUND, MOD, FLOOR, WIDTH_BUCKET 등이 있음
 
 1) 수학적 함수
  (1) ABS(n), SIGN(n), POWER(e, n), SQRT(n)
   - ABS : n의 절대값 반환
   - SIGN : n이 양수이면 1, 음수이면 -1, 0이면 0을 반환
   - POWER : e의 n제곱 값(e의 n번 곱한 값) 반환
   - SQRT : n의 제곱근 반환
   
사용 예)
    SELECT  ABS(10), ABS(-100), ABS(0),
            SIGN(-20000), SIGN(-0.0099), SIGN(0.000005), SIGN(500000), SIGN(0),
            POWER(2,10),
            SQRT(3.3)
    FROM    DUAL;
    
 2) GREATEST(n1, n2[,...n]), LEAST(n1, n2[,...n])
    - 주어진 값 n1 ~ n 사이의 값 중 제일 큰 값(GREATEST), 제일 작은 값(LEAST) 반환
    - 열 데이터 중 가장 큰 값 -> MAX, 행 값 중 가장 큰 값 GREATEST
    
사용 예)
    SELECT  GREATEST('KOREA', 1000, '홍길동'),     -- 문자열 첫 글자의 ASCII 코드값으로 변경, 한글은 값이 큼
            LEAST('200', 'B', '대전시')
    FROM    DUAL;     
    SELECT  ASCII('홍') FROM DUAL;
    
사용 예) 회원테이블에서 마일리지가 1000미만인 회원을 찾아 1000으로 변경하여 출력
        Alias는 회원번호, 회원명, 원본마일리지, 변경된마일리지
        
    SELECT  MEM_ID AS 회원번호, 
            MEM_NAME AS 회원명, 
            MEM_MILEAGE AS 원본마일리지, 
            GREATEST(MEM_MILEAGE, 1000) AS 변경된마일리지
    FROM    MEMBER;