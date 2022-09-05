2022-0905-01) SEQUENCE 객체   -- ORACLE에만 존재
 - 순차적으로 증가(감소)하는 값을 반환하는 객체
 - 테이블과 독립적으로 운용 : 여러 테이블에서 동시 사용 가능
 - 사용하는 경우 
  . 기본키가 필요하나 컬럼 중 기본키로 사용하기에 적합한 컬럼이 없는 경우
  . 순차적을 증가값이 필요한 경우(예, 계시판의 글번호 등)
  
 (사용형식)
 CREATE SEQUENCE 시퀀스명
    [START  WITH    n]  - 시작값 설정 생략되면 최소값(MINVALUE 값)
    [INCREMENT  BY  n]  - 증가(감소) 값 설정. 생략되면 1
    [MAXVALUE   n|NOMAXVALUE]   - 최대값 설정. 기본은 NOMAXVALUE(10^27)
    [MINVALUE   n|NOMINVALUE]   - 최소값 설정. 기본은 NOMINVALUE 이고 값은 1임
    [CYCLE|NOCYCLE] - 최대(최소)값까지 도달 후 다시 시퀀스를 생성할지 여부. 기본은 NOCYCLE
    [CACHE  n|NOCACHE]  - 캐쉬에 미리 생성할 지 여부. 기본은 CACHE 20
    [ORDER|NOORDER] - 요청한 옵션에 맞는 시퀀스 생성을 보장하는 여부. 기본은 NOORDER

 ** 시퀀스의 값을 참조 : 의사컬럼(Pseudo Column : NEXTVAL, CURRVAL) 사용
--------------------------------------------------------------------
    의사컬럼                의미
--------------------------------------------------------------------
 시퀀스명.NEXTVAL       '시퀀스'객체의 다음 값 반환
 시퀀스명.CURRVAL       '시퀀스'객체의 현재 값 반환
 
 *** 시퀀스 생성 후 반드시 '시퀀스명.NEXTVAL' 명령이 1번이상, 맨 처음으로 수행되어야 함
 
사용 예) LPROD 분류테이블에서 LPROD_ID 값을 시퀀스로 구하여 다음 자료를 입력하시오
        --------------------------------
         분류코드       분류명
        --------------------------------
          P501         농산물
          P502         수산물
          P503         임산물

    CREATE SEQUENCE SEQ_LPROD_ID
        START WITH 10;
    
    SELECT  SEQ_LPROD_ID.CURRVAL    FROM DUAL;  --ERROR 발생
    
    INSERT  INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)  
                VALUES(SEQ_LPROD_ID.NEXTVAL, 'P501', '농산물');
                       
    INSERT  INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)  
                VALUES(SEQ_LPROD_ID.NEXTVAL, 'P502', '수산물');
                       
    SELECT  *    FROM LPROD;
    
    SELECT  SEQ_LPROD_ID.NEXTVAL    FROM DUAL;  -- 번호 스킵됨
    
    INSERT  INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)  
                VALUES(SEQ_LPROD_ID.NEXTVAL, 'P503', '임산물');