2022-0817-02)
 4) LTRIM(c1 [,c2]), RTRIM(c1 [,c2])
    - 주어진 문자열 c1의 왼쪽부터(LTRIM) 또는 오른쪽부터(RTRIM) c2 문자열을 찾아
      찾은 문자열을 삭제함
    - 반드시 첫 글자부터 일치해야함  -- 양쪽 끝 글자부터 삭제만 가능
    - c2가 생략되면 공백을 찾아 삭제
    - c1 문자열 내부의 공백은 제거할 수 없음   --REPLACE로 제거
    
사용 예)
    SELECT LTRIM('APPLE PERSIMMON BANANA','PPLE'),      --시작글자 불일치 삭제불가
           LTRIM(' APPLE PERSIMMON BANANA'),            --공백이 있으면 삭제가능
           LTRIM('APPLE PERSIMMON BANANA','AP'),        --일치만하면 같은 문자가 연속되면 삭제됨 AP+P 삭제
           LTRIM('APPALE PERSIMMON BANANA','AP'),
           LTRIM('PAAP PERSIMMON BANANA','AP')
    FROM   DUAL;
    
    SELECT  * 
    FROM    MEMBER
    WHERE   MEM_NAME=RTRIM('이쁜이 ');  
    
 5) TRIM(c1)
    - 주어진 문자열 c1의 좌우 무효 공백 제거
    - 단어 내부의 공백 제거 불가
    
사용 예) 직무테이블(JOBS)에서 직무명(JOB_TITLE) 'Accounting Manager'인 직무를 조회하시오 
        -- JOB_TITLE CHAR(20)로 수정 후
    
    SELECT JOB_ID AS 직무코드, 
           JOB_TITLE AS 직무명,
           LENGTHB(JOB_TITLE) AS "직무명의 길이", 
           MIN_SALARY AS 최저급여, 
           MAX_SALARY AS 최고급여
    FROM   HR.JOBS
    WHERE  JOB_TITLE = 'Accounting Manager';  --TRIM 생략해도 알아서 TRIM 된 결과로 비교
    
사용 예) JOBS 테이블의 직무명의 데이터 타입을 VARCHAR2(40)으로 변경
        -- CHAR(고정길이)를 VARCHAR(가변길이)로 변환 시 UPDATE문 필수
    UPDATE HR.JOBS 
    SET    JOB_TITLE = TRIM(JOB_TITLE);
    
    COMMIT;
    
 6) SUBSTR(c1,m[,n])
    - 주어진 문자열 c1에서 m번째에서 n개의 문자를 추출
    - m은 시작위치를 나타내며 1부터 counting함
    - n은 추출할 문자의 수로 생략하면 m번째 이후 모든 문자를 추출
    - m이 음수이면 오른쪽부터 counting함
    
사용 예)
    SELECT  SUBSTR('ABCDEFGHIJK', 3, 5),
            SUBSTR('ABCDEFGHIJK', 3),
            SUBSTR('ABCDEFGHIJK', -3, 5),       --뒤에서부터 m번째
            SUBSTR('ABCDEFGHIJK', 3, 15)        --남아있는 길이보다 긴 경우 자료 모두 추출
    FROM    DUAL;
    
사용 예) 회원테이블의 주민번호 필드(MEM_REGNO1, MEM_REGNO2)를 이용하여 
        회원들의 나이를 구하고, 회원번호, 회원명, 주민번호, 나이를 출력하시오
        
    SELECT  MEM_ID AS 회원번호,
            MEM_NAME AS 회원명, 
            MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호, 
            CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1','2')       --CASE WHEN 조건 THEN     ELSE    END (if-else)
            THEN 
                2022 - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) + 1900)
            ELSE 
                2022 - (TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) + 2000) 
            END AS 나이              
    FROM    MEMBER;
    
사용 예) 오늘이 2020년 4월 1일이라고 가정하여 'c001'회원이 상품을 구매할 때
        필요한 장바구니번호를 생성하시오. MAX(), TO_CHAR() 함수 사용
        
    SELECT  '20200401'||TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO,9))) + 1,'00000'))
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,8) = '20200401';
    
    SELECT  MAX(CART_NO) + 1        --숫자로만 구성된 문자열인 경우만 가능
    FROM    CART
    WHERE   SUBSTR(CART_NO,1,8) = '20200401';
    
사용 예) 이번 달 생일인 회원들을 조회하시오
        Alias는 회원번호, 회원명, 생년월일, 생일
        단, 생일은 주민등록번호를 이용할 것
        
    SELECT  MEM_ID AS 회원번호, 
            MEM_NAME AS 회원명, 
            MEM_REGNO1 AS 생년월일, 
            SUBSTR(MEM_REGNO1,5) AS 생일
    FROM    MEMBER
    WHERE   SUBSTR(MEM_REGNO1,3,2) = '09';
    
 7) REPLACE(c1, c2 [,c3])
    - 주어진 문자열 c1에서 c2 문자열을 찾아 c3 문자열로 치환
    - c3가 생략되면 c2를 삭제함
    - 단어 내부의 공백제거 가능

사용 예) 
    SELECT  REPLACE('APPLE  PERSIMMON   BANANA','A','에이'),
            REPLACE('APPLE  PERSIMMON   BANANA','A'),
            REPLACE('APPLE  PERSIMMON   BANANA',' ','-'),
            REPLACE('APPLE  PERSIMMON   BANANA',' ')        --문자열 공백 모두 제거 시 사용
    FROM    DUAL;
    