2022-0805-02) 숫자자료형
 - 정수와 실수 저장
 - NUMBER 타입 제공
(사용형식)
 NUMBER[(정밀도|*[,스케일])]
 - 값의 표현 범위 : 10e-130 ~ 9.999...9e125
 - 정밀도 : 전체자리 수 (1-38)
 - 스케일 : 소숫점 이하의 자리수
 - '*' 는 38자리 이내에서 사용자가 입력한 데이터를 저장할 수 있는 최적의 기억공간을 시스템이 설정
 - 저장은 소숫점 이하 '스케일' + 1번째 자리에서 반올림하여 '스케일'자리까지 저장(스케일이 양수인 경우)
   '스케일'이 음수이면 정수부분 '스케일' 자리에서 반올림하여 저장 ( -2 라면 십의자리를 반올림 )
 저장 예)
 ---------------------------------------------
  선언             입력값           저장형태
 ---------------------------------------------
 NUMBER         12345.6789      12345.6789
 NUMBER(*,2)    12345.6789      12345.68
 NUMBER(6,2)    12345.6789      --ERROR(정수자리 부족, 소수자리면 반올림)
 NUMBER(7,2)    12345.6789      12345.68
 NUMBER(8,0)    12345.6789         12346    --앞에 공백 3글자
 NUMBER(6)      12345.6789      12346
 NUMBER(6,-2)   12345.6789      12300
 
CREATE TABLE TEMP05(
    COL1 NUMBER,
    COL2 NUMBER(*,2),
    COL3 NUMBER(6,2),
    COL4 NUMBER(7,2),
    COL5 NUMBER(8,0),
    COL6 NUMBER(6),
    COL7 NUMBER(6,-2));
    
INSERT INTO TEMP05 VALUES( 12345.6789 , 12345.6789 , 2345.6789 , 12345.6789 , 12345.6789 , 12345.6789 , 12345.6789 );
SELECT * FROM TEMP05;

** 정밀도 < 스케일인 경우
 - 정밀도 : 소숫점 이하에서 0이 아닌 유효숫자의 갯수
 - 스케일 : 소숫점 이하의 자리수
 - [스케일 - 정밀도] : 소숫점 이하에서 존재해야할 0의 갯수
 ------------------------------------------------
    입력값         선언              저장 값
 ------------------------------------------------
 1234.5678      NUMBER(2,4)     --ERROR(정수 자리 부족)
 0.12           NUMBER(3,5)     --ERROR(정수 자리 부족)
 0.003456       NUMBER(2,4)     0.0035      --전체자리 4자리, 실제 6자리 ->반올림 
 0.0345678      NUMBER(2,3)     0.035