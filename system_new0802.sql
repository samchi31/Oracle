2022-0801) 사용자 생성 및 권한 설정
1) 사용자 생성
    - CREATE USER 명령 사용
    (사용형식)
    CREATE USER 사용자명 IDENTIFIED BY 암호;
    
CREATE USER in89 IDENTIFIED BY java;

2) 권한 부여
    - GRANT
    (사용형식)
    GRANT 권한명[,권한명,...] TO 사용자명;
    . 권한명 : CONNECT, RESOURCE, DBA 등이 주로 사용
    
GRANT CONNECT, RESOURCE, DBA TO in89;

3) HR 계정 활성화
    -ALTER 명령  사용하여 활성화 및 암호 설정
    
ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENTIFIED BY java;