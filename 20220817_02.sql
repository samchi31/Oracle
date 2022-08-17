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
    - 주어진 문자열 좌우 공백 제거
    - 단어 내부의 공백 제거 불가