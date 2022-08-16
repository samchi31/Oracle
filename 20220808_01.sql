2022-0808-01) 
3. 날짜자료형
 - 날짜 시각 정보를 저장(년,월,일,시,분,초)
 - 날짜 자료는 덧셈과 뺄셈이 가능함
 - date, timestamp 타입 제공
 1) DATE 타입
  . 기본 날짜 및 시각정보 저장
  (사용형식)
  컬럼명 DATE 
   . 덧셈은 더해진 정수만큼 다가올 날짜(미래)
   . 뺄셈은 차감한 정수만큼 지나온 날짜(과거)
   . 날짜 자료 사이의 뺄셈은 날짜 수(DAYS) 반환
   . 날짜자료는 년/월/일 부분과 시/분/초 부분으로 구분하여 저장 
  ** 시스템이 제공하는 날짜정보는 SYSDATE 함수를 통하여 참조할 수 있음
  
사용 예)
CREATE TABLE TEMP06(
    COL1 DATE,
    COL2 DATE,
    COL3 DATE);
    
INSERT INTO TEMP06 VALUES(SYSDATE, SYSDATE-10,SYSDATE+10);
SELECT * FROM TEMP06;
SELECT TO_CHAR(COL1, 'YYYY-MM-DD'),
       TO_CHAR(COL2, 'YYYY-MM-DD HH24:MI:SS'),
       TO_CHAR(COL3, 'YYYY-MM-DD HH12:MI:SS')
  FROM TEMP06;
  
SELECT CASE MOD(TRUNC(SYSDATE)-TRUNC(TO_DATE('00010101'))-1,7)  --TRUNC:자리버림 , MOD:나머지
            WHEN 1 THEN '월요일'       -- 조건분기문
            WHEN 2 THEN '화요일'
            WHEN 3 THEN '수요일'
            WHEN 4 THEN '목요일'
            WHEN 5 THEN '금요일'
            WHEN 6 THEN '토요일'
            ELSE '월요일'
        END AS 요일
  FROM DUAL;        -- DUAL : 쿼리에 테이블이 필요없지만 규격(FROM 생략불가)을 위해 사용되는 가상의 테이블 
  
SELECT SYSDATE-TO_DATE('20200807') FROM DUAL;

 2)TIMESTAMP 타입
  . 시간대 정보(TIME ZONE)나 정교한 시각정보(10억 분의 1초)가 필요한 경우 사용
  (사용형식)
  컬럼명 TIMESTAMP - 시간대 정보 없이 정교한 시각정보 저장
  컬렴명 TIMESTAMP WITH LOCAL TIME ZONE - 데이터베이스가 운영 중인 서버의 시간대를 기준으로
                                         서버에 접속하는 클라이언트와의 시차가 계산된 시간 입력
                                         시간은 클라이언트 지역의 시간으로 자동 변환 출력되기 때문에
                                         시간대 정보는 저장되지 않음
  컬럼명 TIMESTAMP WITH TIME ZONE - 서버의 시간대 정보 저장
  
  . 초를 최대 9자리까지 표현할 수 있으나 기본은 6자리임
  
사용 예)
CREATE TABLE TEMP07(
    COL1 DATE,
    COL2 TIMESTAMP,
    COL3 TIMESTAMP WITH LOCAL TIME ZONE,
    COL4 TIMESTAMP WITH TIME ZONE);
INSERT INTO TEMP07 VALUES(SYSDATE, SYSDATE, SYSDATE, SYSDATE);
SELECT * FROM TEMP07;


