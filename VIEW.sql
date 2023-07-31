-- 뷰 생성 및 출력
USE sqlDB;
CREATE VIEW v_userbuyTBL
	AS
		SELECT U.userID AS 'USER ID', U.name AS 'USER NAME', B.prodName AS 'PRODUCT NAME', 
        U.addr, CONCAT(U.mobile1, U.mobile2) AS 'MOBILE PHONE'
        FROM userTBL U
			INNER JOIN buyTBL B
				ON U.userID = B.userID;
SELECT `USER ID`,`USER NAME` FROM v_userbuyTBL; -- 백틱 사용
ALTER VIEW v_userbuyTBL
	AS SELECT U.userID AS '사용자 아이디', U.name AS '이름', B.prodName AS '제품 이름',
	U.addr, CONCAT(U.mobile1, U.mobile2) AS '전화 번호'
	FROM userTBL U
		INNER JOIN buyTBL B
			ON U.userID = b.userID ;
SELECT `이름`,`전화 번호` FROM v_userbuyTBL;
DROP VIEW v_userbuyTBL;

/* 기존의 뷰에 덮어 쓰는 뷰 */
CREATE OR REPLACE VIEW v_userTBL
	AS SELECT userID, name, addr FROM userTBL;
DESCRIBE v_userTBL;
SHOW CREATE VIEW v_userTBL; -- 뷰 소스 코드 확인

/* 뷰를 통한 데이터 변경 */
UPDATE v_userTBL SET addr = '부산' WHERE userID = 'JKW';
INSERT INTO v_userTBL(userID, name, addr) VALUES ('KBM', '김병만', '충북'); -- 오류 코드 1423

/* 그룹 함수를 포함하는 뷰 */
CREATE VIEW v_sum
	AS SELECT userID AS 'userID', SUM(price*amount) AS 'total'
		FROM buyTBL GROUP BY userID;
SELECT * FROM v_sUm;
SELECT * FROM INFORMATION_SCHEMA.VIEWS
	WHERE TABLE_SCHEMA = 'sqlDB' AND TABLE_NAME = 'v_sum'; -- 데이터를 변경할 수 없음을 할 수 있음.

CREATE OR REPLACE VIEW v_height177
	AS SELECT * FROM userTBL WHERE height >= 177 ;
SELECT * FROM v_height177;
DELETE FROM v_height177 WHERE height < 177;
INSERT INTO v_height177 VALUES ('KBM', '김병만', 1977, '경기', '010', '5555555', 158, '2023-01-01');
ALTER VIEW v_height177
	AS SELECT * FROM userTBL WHERE height >= 177
		WITH CHECK OPTION; -- 조건에 맞는 데이터만 입력 받음
INSERT INTO v_height177 VALUES ('SJH', '서장훈', 2006, '서울', '010', '3333333', 155, '2023-3-3');

CREATE OR REPLACE VIEW v_userbuyTBL
	AS SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS mobile
    FROM userTBL U
		INNER JOIN buyTBL B
			ON U.userID = B.userID;
INSERT INTO v_userbuyTBL VALUES ('PKL', '박경리', '운동화', '경기', '00000000000', '2023-2-2'); 

DROP TABLE IF EXISTS buyTBL, userTBL;
SELECT * FROM v_userbuyTBL; -- 참조할 테이블이 없기 때문에 조회할 수 없단는 메시지 출력
CHECK TABLE v_userbuyTBL; -- 뷰의 상태 체크