2022-0901-02) 집합연산자
 - SELECT 문의 결과를 대상으로 집합연산 수행
 - UNION ALL, UNION, INTERSECT, MINUS 연산자 제공    -- 중복 배제 안하면 ALL
 - 집합연산자로 연결되는 SELECT 문의 각 SELECT 절의 컬럼의 갯수와 데이터 타입을
   일치해야 함
 - ORDER BY 절은 맨 마지막 SELECT 문에만 사용 가능
 - BLOB, CLOB, BFILE 타입의 컬럼은 집합 연산자를 사용할 수 없음
 - UNION, INTERSECT, MINUS 연산자는 LONG 타입형 컬럼에 사용할 수 없음
 - GROUPING SETS(col1, col2,...) => UNION ALL 개념이 포함된 형태
   ex) GROUPING SETS(col1, col2, col3) 
       => ((GROUP BY col1) UNION ALL (GROUP BY col2) UNION ALL (GROUP BY col3))