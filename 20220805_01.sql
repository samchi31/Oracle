2022-0805-01) 데이터 타입
    - 오라클에는 문자열, 숫자, 날짜, 이진수 자료타입이 제공
    1. 문자 데이터 타입
     . 오라클의 문자자료는 ''안에 기술된 자료
     . 대소문자 구별
     . CHAR, VARCHAR, VARCHAR2, NVARCHAR2, LONG, CLOB, NCLOB 등이 제공됨
     1) CHAR(n[BYTE|CHAR])
      - 고정길이 문자열 저장 (고정길이는 사용자가 길이를 지정, 크기만큼 빈 공간(오른쪽) 생성, 크기보다 크면 에러)
      - 최대 2000BYTE까지 저장가능 (영문자 기준)
      - 'n[BYTE|CHAR]' : '[BYTE|CHAR]'이 생략되면 BYTE로 취급
        'CHAR'은 n글자수 까지 저장
      - 한글 한 글자는 3BYTE로 저장 (char는 1글자)
      - 기본키나 길이가 고정된 자료(주민번호, 우편번호)의 정당성을 확보하기 위해 사용
      - VARCHAR 는 가변길이, VARCHAR2 는 오라클에서만 사용하는 VARCHAR,
        NVARCHAR2 는 국제 언어 변환(national), LONG 2기가바이트 문자열, 
        CLOB 4기가바이트 문자열
사용 예)
CREATE TABLE TEMP01(
    COL1 CHAR(10),
    COL2 CHAR(10 BYTE),
    COL3 CHAR(10 CHAR));
- 삽입하기
INSERT INTO TEMP01 VALUES('대한', '대한민', '대한민국');
- 크기 확인하기 (LENGTHB:바이트길이)
SELECT LENGTHB(COL1) AS COL1,
       LENGTHB(COL2) AS COL2,
       LENGTHB(COL3) AS COL3 
  FROM TEMP01;
    '대한민국':18BYTE => (10char - 4char) + 4char * 3
    
     2) VARCHAR2(n[BYTE|CHAR])
      - 가변길이 문자열 자료 저장
      - 최대 4000BYTE 까지 저장 가능
      - VARCHAR, NVARCHAR2(UTF8,UTF16 형식으로 저장) 와 저장형식 동일      
사용 예)
CREATE TABLE TEMP02(
    COL1 CHAR(20), 
    COL2 VARCHAR2(2000 BYTE),
    COL3 VARCHAR2(4000 CHAR));
    
INSERT INTO TEMP02 VALUES('ILPOSTINO', 'BOYHOOD', '무궁화 꽃이 피었습니다-김진명');
SELECT * FROM TEMP02;
SELECT LENGTHB(COL1) AS COL1, --바이트수
       LENGTHB(COL2) AS COL2,
       LENGTHB(COL3) AS COL3,
       LENGTH(COL1) AS COL1, --글자수
       LENGTH(COL2) AS COL2,
       LENGTH(COL3) AS COL3 
  FROM TEMP02;

     3) LONG
      - 가변길이 문자열 자료 저장
      - 최대 2GB 까지 저장 가능
      - 한 테이블에 한 컬럼만 LONG 타입 사용 가능
      - 현재 기능 개선서비스 종료(오라클 8i) => CLOB로 UPGRADE      
      (사용형식)
      컬럼명 LONG
       . LONG 타입으로 저장된 자료를 참조하기 우해 최소 31bit가 필요
        => 일부 기능(LENGTHB, SUBSTR 등의 함수)이 제한
       . SELECT 문의 SELECT 절, UPDATE 의 SET 절, INSERT 문의 VALUES 절에서 사용 가능
  
사용 예)
CREATE TABLE TEMP03(
    COL1 VARCHAR2(2000),
    COL2 LONG); --LONG 사용은 가능
    
INSERT INTO TEMP03 VALUES('대전시 중고 계룡로 846','대전시 중고 계룡로 846');
SELECT * FROM TEMP03;
SELECT SUBSTR(COL1,8,3)    -- COL1에서 8번째부터 3글자
       --SUBSTR(COL2,8,3)     -- LONG 타입은 사용 X
       --LENGTHB(COL2)
  FROM TEMP03;
  
     4) CLOB(Character Large Objects)
      - 대용량의 가변길이 문자열 저장
      - 최대 4GB까지 처리 가능
      - 한 테이블에 복수개의 CLOB 타입 정의 가능
      - 일부 기능은 DBMS_LOB API(Application Programming Interface)에서 제공하는 함수 사용
      (사용 형식)
      컬럼명 CLOB
      
사용 예)
CREATE TABLE TEMP04(
    COL1 VARCHAR2(255),
    COL2 CLOB,
    COL3 CLOB);
    
INSERT INTO TEMP04 VALUES('APPLE BANANA PERSIMMON','APPLE BANANA PERSIMMON','APPLE BANANA PERSIMMON');
SELECT * FROM TEMP04;
SELECT SUBSTR(COL1,7,6) AS COL1,
       SUBSTR(COL3,7,6) AS COL3,        -- CLOB 중 처리 가능한 길이일 때 SUBSTR 가능
       --LENGTHB(COL2) AS COL4,
       DBMS_LOB.GETLENGTH(COL2) AS COL4,    -- 글자 수 반환
       DBMS_LOB.SUBSTR(COL2,7,6) AS COL2  -- COL2에서 6번째부터 7글자   
  FROM TEMP04;
  