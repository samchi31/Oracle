2022-0822-01) 형변환 함수
 - 오라클의 데이터 형변환 함수는 TO_CHAR, TO_DATE, TO_NUMBER, CAST 함수가 제공됨
 - 해당 함수가 사용된 곳에서 일시적 변환
 
 1) CAST(expr AS type)
  . expr로 제공되는 데이터(수식, 함수 등)를 'type' 형태로 변환하여 반환함
  
사용 예)
    SELECT  BUYER_ID AS 거래처코드,
            BUYER_NAME AS 거래처명1,
            CAST(BUYER_NAME AS CHAR(30)) AS 거래처명2,
            BUYER_CHARGER AS 담당자
    FROM    BUYER;
    
    SELECT  --CAST(BUY_DATE AS NUMBER)    -- 오류 발생
            CAST(TO_CHAR(BUY_DATE,'YYYYMMDD') AS NUMBER)
    FROM    BUYPROD
    WHERE   BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131');
    
 2) TO_CHAR(d [, fmt])
  . 변환함수 중 가장 널리 사용
  . 숫자, 날짜, 문자 타입을 문자 타입으로 변환
  . 문자타입은 CHAR, CLOB 를 VARCHAR2 로 변환할 때만 사용     --VARCHAR2 -> VARCHAR2 변환 시 오류
  . 'fmt'는 형식문자열로 크게 날짜형과 숫자형으로 구분 됨
  
**날짜형 형식문자    
-------------------------------------------------------------------------------------
    FORMAT 문자      의미               사용예
-------------------------------------------------------------------------------------
    CC              세기              SELECT TO_CHAR(SYSDATE,'CC')||'세기' FROM DUAL;
    AD,BC           기원전,기원후       SELECT TO_CHAR(SYSDATE, 'CC BC')||EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
    YYYY,YYY,YY,Y   년도              SELECT TO_CHAR(SYSDATE, 'YYYY YEAR') FROM DUAL; 
    YEAR            년도를 알파벳으로    
    Q               분기              SELECT TO_CHAR(SYSDATE,'Q') FROM DUAL;
    MM,RM           월(로마식)         SELECT TO_CHAR(SYSDATE,'MM RM') FROM DUAL;
    MONTH,MON       월                SELECT TO_CHAR(SYSDATE,'MONTH MON') FROM DUAL; --영어일 때는 다름 풀네임, 요약이름
    WW,W            주                SELECT TO_CHAR(SYSDATE,'WW W') FROM DUAL;      --1월1일부터 몇주, 한달 안에서 몇주
    DDD,DD,D        일                SELECT TO_CHAR(SYSDATE,'DDD DD D') FROM DUAL;  --년,달,주(일:1~토:7)
    DAY, DY         요일              SELECT TO_CHAR(SYSDATE,'DAY DY') FROM DUAL;    --풀네임, 요약이름
    AM,PM,A.M.,P.M. 오전/오후          SELECT TO_CHAR(SYSDATE,'AM PM A.M. P.M.') FROM DUAL; --시간이 오후면 AM 써도 오후 출력   
    HH,HH12,HH24    시각              SELECT TO_CHAR(SYSDATE,'HH HH24') FROM DUAL;    --HH=HH12
    MI              분                SELECT TO_CHAR(SYSDATE,'HH:MI') FROM DUAL;
    SS,SSSSS        초                SELECT TO_CHAR(SYSDATE,'SS SSSSS') FROM DUAL;   -- 초 전체 수

**숫자형 형식문자    
-------------------------------------------------------------------------------------
    FORMAT 문자      의미                       사용예
-------------------------------------------------------------------------------------
    9, 0            숫자자료출력                SELECT   TO_CHAR(12345.56,'9,999,999.99'),               -- 무효의 0은 공백으로 (9,9 공백 3칸)
                                                       TO_CHAR(12345.56,'0,000,000.00') FROM DUAL;     -- 무효의 0은 0으로
    ,(COMMA),       3자리마다 자리점(,)
    .(DOT)          소숫점
    $,L             화폐기호                   SELECT  TO_CHAR(PROD_PRICE,'L9,999,999') FROM PROD;
                                             SELECT TO_CHAR(SALARY , '$999,999') AS 급여1, TO_CHAR(SALARY) AS 급여2 FROM HR.EMPLOYEES
    PR              음수자료를 '<>'안에 출력     SELECT TO_CHAR(-2500,'99,999PR') FROM DUAL;
    MI              음수자료 출력 시            SELECT TO_CHAR(-2500,'99,999MI') FROM DUAL;
                    오른쪽에 '-'출력
    
    " "             사용자가 직접 정의하는 문자열  SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL;
    
 3) TO_DATE(c [,fmt])
  . 주어진 문자열 자료 c를 날짜 타입의 자료로 형변환 시킴.
  . c에 포함된 문자열 중 날짜 자료로 변환될 수 없는 문자열이 포함된 경우
    'fmt'를 사용하여 기본 형식으로 변환할 수 있음
  . 'fmt'는 TO_CHAR 함수의 '날짜형 형식문자'와 동일
  
사용 예)
    SELECT  TO_DATE('20200504'),        --기본타입으로 변경 -- 숫자 자료형은 바꿀수 없다 문자만 가능
            TO_DATE('20200504','YYYY-MM-DD'),     --기본 데이터 타입 구별자 '-'와 '/' 중 '/'가 우선적으로 사용됨
            TO_DATE('2020년 08월 22일','YYYY"년" MM"월" DD"일"')
    FROM    DUAL;
    
 4) TO_NUMBER(c [,fmt])
  . 주어진 문자열 자료 c를 숫자 타입의 자료로 형변환 시킴.
  . c에 포함된 문자열 중 숫자 자료로 변환될 수 없는 문자열이 포함된 경우
    'fmt'를 사용하여 기본 숫자으로 변환할 수 있음
  . 'fmt'는 TO_CHAR 함수의 '숫자형 형식문자'와 동일
  
사용 예)
    SELECT  TO_NUMBER('2345') / 7,
            TO_NUMBER('2345.56'),
            TO_NUMBER('2,345', '9,999'),   --0,000 가능
            TO_NUMBER('$2345', '$9999'),
            TO_NUMBER('002,345', '000,000'),
            TO_NUMBER('<2,345>', '9,999PR')
    FROM    DUAL;