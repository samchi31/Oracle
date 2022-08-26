2022-0826-02) 계층형 쿼리 (ORACLE에서만 사용가능)
1) 계층형 쿼리란
 - 계층형 구조는 상하 수직관계의 트리형태의 구조로 이루어진 형태
 - 계층형 쿼리는 테이블에 저장된 데이터를 계층형 구조로 반환하는 쿼리
 - 오라클에서의 계층형 쿼리는 START WITH ... CONNECT BY 절로 생성할 수 있으며 계층형 정보를 표현하기 위한 목적으로 오라클 8부터 지원

2) 수행순서
 (1) START WITH 절에 시작 조건을 찾음
 (2) CONNECT BY 절에 연결조건을 찾음

3) 계층형 쿼리 START WITH.. CONNECT BY

 SELECT [컬럼]...
 FROM [테이블]
 WHERE [조건]
 START WITH [최상위 조건]
CONNECT BY [NOCYCLE][PRIOR 계층형 구조 조건];

 . START WITH 조건에 계층형 구조의 최상위 계층의 로우를 식별하는 조건 기술
 . CONNECT BY조건에서는 계층형 구조가 어떤식으로 연결되는지 표현
 . 마지막 컬럼에 나열한 LEVEL컬럼은 레벨 의사컬럼(LEVEL Pseudocolumn)이라고 하는데 계층형 정보를 표현할때 그 계층의 레벨을 표현
 . 이 레벨 의사컬럼을 다양하게 응용 - 가장 많이 응용하는 방법이 레벨별로 들여쓰기를 하여 좀
   더 직관적으로 데이터를 표현
 . PRIOR연산자
 - PRIOR키워드는 워직 계층형 쿼리에서만 사용하는 오라클 SQL연산자이다.
   키워드라고 표현했지만 실제로는 CONNECT BY절에서 등호(=)와 동등한 레벨로 사용되는 연산자이며
   CONNCET BY절에서 해당 컬럼의 부모로우를 식별하는데 사용된다.
 . 레벨 의사컬럼(LEVEL Pseudocolumn)

***********************************************************************
select * from hr.departments;
alter table departments add parent_id NUMBER(4,0); -- 자기참조 관계 parent_id == department_id    
alter table DEPARTMENTS add
 CONSTRAINT DEPT_DEPT_FK FOREIGN KEY(PARENT_ID)
 REFERENCES DEPARTMENTS(DEPARTMENT_ID);

commit;

update hr.departments set department_name='총무기획부' where
department_id=10;
update hr.departments set department_name='마케팅' where
department_id=20;
update hr.departments set department_name='구매부' where
department_id=30;
update hr.departments set department_name='인사부' where
department_id=40;
update hr.departments set department_name='배송부' where
department_id=50;
update hr.departments set department_name='IT' where
department_id=60;
update hr.departments set department_name='홍보부' where
department_id=70;
update hr.departments set department_name='영업부' where
department_id=80;
update hr.departments set department_name='기획부' where
department_id=90;
update hr.departments set department_name='재정부' where
department_id=100;
update hr.departments set department_name='회계부' where
department_id=110;
update hr.departments set department_name='자금부' where
department_id=120;
update hr.departments set department_name='법인세팀' where
department_id=130;
update hr.departments set department_name='신용 관리팀' where
department_id=140;
update hr.departments set department_name='주식 관리팀' where
department_id=150;
update hr.departments set department_name='복리후생팀' where
department_id=160;
update hr.departments set department_name='생산팀' where
department_id=170;
update hr.departments set department_name='건설팀' where
department_id=180;
update hr.departments set department_name='계약팀' where
department_id=190;
update hr.departments set department_name='운영팀' where
department_id=200;
update hr.departments set department_name='IT 지원팀' where
department_id=210;
update hr.departments set department_name='NOC' where
department_id=220;
update hr.departments set department_name='IT 헬프테스크' where
department_id=230;
update hr.departments set department_name='공공판매 사업팀' where
department_id=240;
update hr.departments set department_name='판매팀' where
department_id=250;
update hr.departments set department_name='채용팀' where
department_id=260;
update hr.departments set department_name='급여관리팀' where
department_id=270;

commit;
update departments
 set parent_id=null
 where DEPARTMENT_ID =10;

 update departments
 set parent_id=10
 where DEPARTMENT_ID in(20,30,40,50,80,90,110);

update departments
 set parent_id= 30
 where DEPARTMENT_ID in(180,200,170,220);

update departments
 set parent_id=40
 where DEPARTMENT_ID =260;

update departments
 set parent_id=60
 where DEPARTMENT_ID in(210,230);

update departments
 set parent_id= 80
 where DEPARTMENT_ID in(190,240,250);

update departments
 set parent_id= 90
 where DEPARTMENT_ID in(60,70,100);

update departments
 set parent_id= 100
 where DEPARTMENT_ID in(110,120,130,140,150,160);

update departments
 set parent_id=120
 where DEPARTMENT_ID =270;

commit;

select * from departments;


CREATE TABLE BOM (
 ITEM_ID INTEGER NOT NULL, -- 품목식별자
 PARENT_ID INTEGER, -- 상위품목 식별자
 ITEM_NAME VARCHAR2(20) NOT NULL, -- 품목이름
 ITEM_QTY INTEGER, -- 품목 개수
 PRIMARY KEY (ITEM_ID)
);

INSERT INTO BOM VALUES ( 1001, NULL, '컴퓨터', 1);
INSERT INTO BOM VALUES ( 1002, 1001, '본체', 1);
INSERT INTO BOM VALUES ( 1003, 1001, '모니터', 1);
INSERT INTO BOM VALUES ( 1004, 1001, '프린터', 1);
INSERT INTO BOM VALUES ( 1005, 1002, '메인보드', 1);
INSERT INTO BOM VALUES ( 1006, 1002, '랜카드', 1);
INSERT INTO BOM VALUES ( 1007, 1002, '파워서플라이', 1);
INSERT INTO BOM VALUES ( 1008, 1005, 'CPU', 1);
INSERT INTO BOM VALUES ( 1009, 1005, 'RAM', 1);
INSERT INTO BOM VALUES ( 1010, 1005, '그래픽카드', 1);
INSERT INTO BOM VALUES ( 1011, 1005, '기타장치', 1);


CREATE TABLE RECURSIVE_BOOK(
 BOOK_ID NUMBER(4) NOT NULL,
 PARENT_ID NUMBER(4),
 BOOK_NAME VARCHAR2(20) NOT NULL,
 BOOK_QTY NUMBER(3),
CONSTRAINT BOOK_KEY PRIMARY KEY (BOOK_ID));

DELETE FROM RECURSIVE_BOOK;

INSERT INTO RECURSIVE_BOOK VALUES (101, null, '도서', 1);
INSERT INTO RECURSIVE_BOOK VALUES (102, 101, '과학책', 1);
INSERT INTO RECURSIVE_BOOK VALUES (103, 101, '역사책', 1);
INSERT INTO RECURSIVE_BOOK VALUES (104, 101, '잡지', 1);
INSERT INTO RECURSIVE_BOOK VALUES (105, 102, '달나라_여행', 1);
INSERT INTO RECURSIVE_BOOK VALUES (106, 102, '내셔널지오그래픽_동물사전',1);
INSERT INTO RECURSIVE_BOOK VALUES (107, 102, '블랙홀은_존재하는가', 1);
INSERT INTO RECURSIVE_BOOK VALUES (108, 106, '독화살개구리의_생존', 1);
INSERT INTO RECURSIVE_BOOK VALUES (109, 106, '오리너구리의_비밀', 1);
INSERT INTO RECURSIVE_BOOK VALUES (110, 104, '90년대_오렌지족_패션', 1);
INSERT INTO RECURSIVE_BOOK VALUES (111, 103, '6.25전쟁의_진실', 1);

commit;


***********************************************************************
사용예)    --BOM 자제 리스트
 SELECT LEVEL, item_name, item_id, parent_id        -- LEVEL : 트리 차수
 FROM bom
 START WITH parent_id IS NULL           -- 루트노드를 지정,
 CONNECT BY PRIOR item_id = parent_id;  -- 부모와 자식노드들간의 관계를 연결
                                        -- 순서 지키기 자식 = 부모


 SELECT LPAD(' ', 2*(LEVEL-1)) || item_name as item_names,      -- (왼쪽에 값만큼 공백 인쇄) || 이름
        item_id,
        parent_id
 FROM bom
 START WITH parent_id IS NULL
 CONNECT BY PRIOR item_id = parent_id;


 select level,  --출력했을 때, NULL값을 가지고 있는 게 상위 부서 코드임
 department_id as 부서코드,
 lpad(' ',2*(level-1))||department_name as 부서명,
 manager_id as 부서장,
 location_id as 위치,
 parent_id as 상위부서코드
 from departments
 start with parent_id is null
 connect by prior department_id=parent_id;

