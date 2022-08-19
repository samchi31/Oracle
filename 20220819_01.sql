2022-0819-01)
3. 날짜함수
 1) SYSDATE 
  - 시스템이 제공하는 날짜 및 시간정보 제공
  - 덧셈과 뺄셈, ROUND, TRUNC 함수의 연산 대상이 됨
  - 기본 출력 타입은 '년/월/일'이고 '시분초'를 출력하기 위해서는 TO_CHAR 함수 사용
  - 단위는 '일', '시분초'는 소수점
  
 2) ADD_MONTHS(d, n)
  - 주어진 날짜 d 에 n 만큼의 월을 더한 날짜 반환
  - 기간이 정해진 날짜가 필요한 경우 많이 사용

사용 예) 오늘 어느 단체의 2개월 유료회원으로 등록한 경우 다음 등록일자를 조회하시오    
    SELECT ADD_MONTHS(SYSDATE, 2)-1 FROM DUAL;
    
 3) NEXT_MONTHS(d, c)
    - 주어진 날짜 d 이후 c요일에 해당하는 날짜 반환
    - c는 '월', '월요일', '화', ...'일요일' 사용
    
사용 예)
    SELECT  NEXT_DAY(SYSDATE, '금'),
            NEXT_DAY(SYSDATE, '토요일')
            --NEXT_DAY(SYSDATE, 'FRIDAY')     -- 한글만 사용 가능
    FROM    DUAL;