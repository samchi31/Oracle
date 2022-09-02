2022-0902-02) 오라클 객체
1. VIEW 객체
 - TABLE과 유사한 객체
 - 기존의 테이블이나 VIEW를 대상으로 새로운 SELECT 문의 결과가  VIEW 가 됨
 - SELECT 문의 종속 객체가 아니라 독립 객체임
 - 사용이유
  . 필요한 정보가 분산되어 매번 조인을 필요로 하는 경우
  . 특정자료의 접근을 제한한고자 하는 경우(보안상)
 (사용형식)
 CREATE [OR REPLACE] VIEW 뷰이름 [(컬럼 list)]
 AS
    SELECT 문
    [WITH READ ONLY]
    [WITH CHECK OPTION];    
    
  . 'OR REPLACE' : 이미 존재하는 뷰인 경우 기존의 뷰를 대치하고 존재하지 않는 뷰는 생성
  . '(컬럼 list)' : 뷰에서 사용할 컬럼명. (생략하면 
                        1) 뷰를 생성하는 SELECT 문의 SELECT 절에 컬럼별칭이 사용되었으면
                            컬럼별칭이 뷰의 컬럼명이 됨
                        2) 뷰를 생성하는 SELECT 문의 SELECT 절에 컬럼별칭이 사용되지 않았으면
                            SELECT 절의 컬럼명이 뷰의 컬럼명이 됨
  . 'WITH READ ONLY' : 읽기전용뷰(뷰에만 적용)
  . 'WITH CHECK OPTION' : 생성된 뷰를 대상으로 뷰를 생성하는 SELECT 문의 조건절을 위배하도록 하는
                            DML 명령을 사용할 수 없음(뷰에만 적용)
**** 'WITH READ ONLY'와 'WITH CHECK OPTION'는 같이 사용할 수 없음