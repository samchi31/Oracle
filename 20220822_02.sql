2022-0822-02) 집계함수
 - 대상 데이터를 특정 컬럼을 기준으로 그룹으로 분할하여 각 그룹에 대하여
   합계(SUM), 평균(AVG), 자료 수(COUNT), 최대값(MAX), 최소값(MIN)을 반환하는 함수
   
기술형식)
 SELECT [컬럼명1 [,]
            :
        [컬럼명n]
        SUM|AVG|COUNT|MAX|MIN
 FROM   테이블명
 [WHERE] 조건
 [GROUP BY 컬럼명1,...컬럼명n]
 [HAVING 조건]
 
 - SELECT 절에서 집계함수만 사용된 경우에는 GROUP BY 절의 사용이 필요없음
 - SELECT 절에 집계함수 이외의 컬럼이 기술된 경우 (일반함수 포함) 반드시 GROUP BY 절이 기술되어야 하고
   GROUP BY 다음에 모든 일반컬럼을 ','로 구분하여 기술해야함
 - SELECT 절에 사용되지 않은 컬럼도 GROUP BY 절에 사용 가능
 - 집계함수에 조건이 부여될 때에는 반드시 HAVING 절로 조건 처리를 수행해야 함
 
 1) SUM(column | expr)
  . 기술된 컬럼의 값이나 수식의 결과를 모두 합한 결과 반환
  . 