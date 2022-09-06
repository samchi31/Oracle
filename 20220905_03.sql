2022-0905-03) 인덱스(INDEX) 객체
 - 자료검색을 효율적으로 수행하기 위한 객체
 - DBMS의 성능개선에 도움
 - B-TREE 개념이 적용되어 동일 시간안에 모든 자료 검색을 담보함
 - 데이터 검색, 삽입, 변경 시 필요자료 선택의 효율성 증대
 - 정렬과 그룹화의 성능 개선에 도움
 - 인덱스 구성에 자원이 많이 소요됨
 - 지속적인 데이터 변경이 발생되면 인덱스파일 갱신에 많은 시간 소요
 - 인덱스의 종류
  . Unique/Non Unique Index -- Unique : 키값 중복 X(NULL포함)
  . Single/Composite Index  -- Single : 한 컬럼 기준으로 키
  . Normal/Bitmap/Function-Based Normal Index   -- Normal : B-TREE COLUMN의 값
                                                -- Bitmap : 이진 매핑 데이터
                                                -- Function-Based : 함수 기반으로 키 값
 (사용형식)
 CREATE [UNIQUE|BITMAP] INDEX 인덱스명
 ON     테이블명(컬럼명[,컬럼명,...])[ASC|DESC]
 
사용 예) 회원테이블에서 이름컬럼으로 인덱스를 구성하시오
    
    CREATE INDEX    IDX_NAME
    ON MEMBER(MEM_NAME);
    
    SELECT  *
    FROM    MEMBER
    WHERE   MEM_NAME = '배인정';
    
    DROP INDEX  IDX_NAME;

COMMIT;

    CREATE INDEX    IDX_REGNO
    ON  MEMBER(SUBSTR(MEM_REGNO2,2,4)); -- Function-Based Normal
    
    SELECT  *
    FROM    MEMBER
    WHERE   SUBSTR(MEM_REGNO2,2,4) = '4558';
    
1. 인덱스 재구성
 - 인덱스 파일을 다른 테이블 스페이스로 이동 한 후
 - 업데이트나 삭제 등의 작업이 많이 수행된 직후 인덱스를 재구성 해야 하는 경우
 (사용형식)
 ALTER  INDEX   인덱스명    REBUILD;
 