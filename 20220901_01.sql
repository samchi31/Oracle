2022-0901-01)
** 재고수불테이블 생성
  1) 테이블명 : REMAIN
  2) 컬럼명
  ----------------------------------------------------------------
    컬럼명         데이터타입           NULLABLE            PK, FK
  ----------------------------------------------------------------
  REMAIN_YEAR      CHAR(4)                                 PK           --년도
  PROD_ID          VARCHAR(10)                             PK & FK      --상품코드
  REMAIN_J_00      NUMBER(5)        DEFAULT 0                           --기초재고
  REMAIN_I         NUMBER(5)                                            --입고수량
  REMAIN_O         NUMBER(5)                                            --출고수량
  REMAIN_J_99      NUBMER(5)        DEFAULT 0                           --기말(현) 재고
  REMAIN_DATE      DATE             DEFAULT SYSDATE                     --수정일자
  ----------------------------------------------------------------

CREATE TABLE REMAIN(
    REMAIN_YEAR      CHAR(4),
    PROD_ID          VARCHAR(10) DEFAULT 0, 
    REMAIN_J_00      NUMBER(5),
    REMAIN_I         NUMBER(5),
    REMAIN_O         NUMBER(5),
    REMAIN_J_99      NUMBER(5) DEFAULT 0,
    REMAIN_DATE      DATE DEFAULT SYSDATE,
    
    CONSTRAINT  pk_remain   PRIMARY KEY(REMAIN_YEAR,PROD_ID),
    CONSTRAINT  fk_remain_prod  FOREIGN KEY(PROD_ID)    REFERENCES PROD(PROD_ID));
    
** 재고수불테이블(REMAIN)에 다음 자료를 입력하세요
 년도 : 2020년
 상품코드 : PROD 테이블의 모든 상품코드
 기초재고 : PROD 테이블의 적정재고량(PROD_PROPERSTOCK)
 입고/출고수량 : 0
 기말재고 : PROD 테이블의 적정재고량(PROD_PROPERSTOCK)
 갱신일자 : 2020년 1월 1일
 
 1) INSERT 문과 SUBQUERY
  . '( )' 사용하지 않음
  . VALUES 절 생략하고 서브쿼리를 기술
  
    INSERT INTO   REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_I, REMAIN_O, REMAIN_J_99, REMAIN_DATE)
        SELECT  '2020', PROD_ID, PROD_PROPERSTOCK,0,0,PROD_PROPERSTOCK,TO_DATE('20200101')
        FROM    PROD;
        
    SELECT  *   FROM    REMAIN;
COMMIT;
 2) 서브쿼리를 이용한 UPDATE문
 (사용형식)
 UPDATE 테이블명
 SET    (컬럼명1[,컬럼명2,...])=(서브쿼리)
 [WHERE 조건]
 . SET 절에서 변경시킬 컬럼이 하나이상인 경우 보통 ( )안에 컬럼명을 기술하며
   서브쿼리의 SELECT 절의 컬럼들이 기술된 순서대로 1대1 대응되어 할당됨
 . SET 절에서 ( )를 사용하지 않으면 변경시킬 컬럼마다 서브쿼리를 기술해야 함

사용 예) 2020년 1월 상품들의 매입집계를 이용하여 재고수불테이블을 갱신하시오
        작업일자는 2020년 1월 31일      
        -- 재고수불테이블 갱신 : 메인쿼리    -- 2020년 1월 제품별 매입수량집계 : 서브쿼리
    UPDATE  REMAIN A
    SET     (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_I + B.BSUM, 
                    A.REMAIN_J_99 + B.BSUM, 
                    TO_DATE('20200131')
             FROM   (SELECT BUY_PROD,               -- 제품코드가 최종 목적에 필요하지 않음
                            SUM(BUY_QTY) AS BSUM
                     FROM   BUYPROD 
                     WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
                     GROUP  BY  BUY_PROD
                     ORDER  BY  1) B
             WHERE   A.PROD_ID = B.BUY_PROD
             )
    WHERE   A.PROD_ID IN (SELECT    BUY_PROD    -- 2020년 1월 매입된 상품의 코드
                            FROM    BUYPROD
                           WHERE    BUY_DATE    BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'));
                           
사용 예) 2020년 2-3월 상품들의 매입집계를 이용하여 재고수불테이블을 갱신하시오
        작업일자는 2020년 3월 31일               
        
    UPDATE  REMAIN A
    SET     (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_I + B.BSUM, 
                    A.REMAIN_J_99 + B.BSUM, 
                    TO_DATE('20200331')
             FROM   (SELECT BUY_PROD,
                            SUM(BUY_QTY) AS BSUM
                     FROM   BUYPROD 
                     WHERE  BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200331')
                     GROUP  BY  BUY_PROD) B
             WHERE   A.PROD_ID = B.BUY_PROD)
    WHERE   A.PROD_ID IN (SELECT    BUY_PROD        
                            FROM    BUYPROD
                           WHERE    BUY_DATE    BETWEEN TO_DATE('20200201') AND TO_DATE('20200331'));
                           
사용 예) 2020년 4-7월 상품들의 매입매출집계를 이용하여 재고수불테이블을 갱신하시오
        작업일자는 2020년 8월 1일    
    --A.PROD_ID = B.BUY_PROD AND A.PROD_ID = C.CART_PROD 를 만족하지 않는 행이 하나 있어서 동시에 불가
    (매입)
    UPDATE  REMAIN A
    SET     (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_I + B.BSUM,
                    A.REMAIN_J_99 + B.BSUM, 
                    TO_DATE('20200801')
             FROM   (SELECT BUY_PROD,
                            SUM(BUY_QTY) AS BSUM
                     FROM   BUYPROD 
                     WHERE  BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200731')
                     GROUP  BY  BUY_PROD) B
             WHERE   A.PROD_ID = B.BUY_PROD)
    WHERE   A.PROD_ID IN (SELECT    BUY_PROD
                            FROM    BUYPROD
                           WHERE    BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200731'));
    
    (매출)
    UPDATE  REMAIN A
    SET     (A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE) =
            (SELECT A.REMAIN_O + C.CSUM,
                    A.REMAIN_J_99 - C.CSUM, 
                    TO_DATE('20200801')
             FROM   (SELECT CART_PROD,
                            SUM(CART_QTY) AS CSUM
                     FROM   CART 
                     WHERE  SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007'
                     GROUP  BY  CART_PROD) C
             WHERE   A.PROD_ID = C.CART_PROD)
    WHERE   A.PROD_ID IN (SELECT   CART_PROD
                             FROM   CART 
                            WHERE   SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007');
                            
3) 서브쿼리를 이용한 DELETE 문
 (사용형식)
 DELETE FROM    테이블명
 WHERE  조건
 . '조건'에 IN이나 EXISTS 연산자를 사용하여 서브쿼리를 적용
 
사용 예) 장바구니 테이블에서 2020년 4월 'm001'회원의 구매자료 중 'P202000005' 제품의 구매내역을 삭제하시오
   
    DELETE  FROM CART A
    WHERE   A.CART_MEMBER = 'm001'
    AND     A.CART_NO   LIKE    '202004%'
    AND     A.CART_PROD = 'P202000005';
    
    (서브쿼리 사용)
    DELETE  FROM CART A
    WHERE   EXISTS(SELECT   1
                    FROM    MEMBER B
                    WHERE   B.MEM_ID = 'm001'
                    AND     B.MEM_ID = A.CART_MEMBER)
    AND     A.CART_NO   LIKE    '202004%'
    AND     A.CART_PROD = 'P202000005';
                    
ROLLBACK;
COMMIT;