CREATE TABLE stdTBL
(stdName VARCHAR(10) NOT NULL,
addr CHAR(4) NOT NULL
);
CREATE TABLE clubTBL
(clubName VARCHAR(10) NOT NULL,
roomNo CHAR(4) NOT NULL
);
CREATE TABLE stdclubTBL
(num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
stdName VARCHAR(10) NOT NULL,
clubName VARCHAR(10) NOT NULL
);
INSERT INTO stdTBL VALUES ('김범수', '경남'), ('성시경', '서울'), ('조용필', '경기'), ('은지원','경북'), ('바비킴','서울');
INSERT INTO clubTBL VALUES ('수영', '101호'), ('바둑', '102호'), ('축구', '103호'), ('봉사','104호');
INSERT INTO stdclubTBL VALUES (NULL,'김범수', '바둑'), (NULL,'김범수', '축구'),  (NULL,'조용필', '축구'), (NULL,'은지원','측구'), (NULL,'바비킴','봉사');
-- 세 개 테이블 OUTER JOIN
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTBL S
		LEFT OUTER JOIN stdclubTBL SC
			ON S.stdName = SC.stdName
		LEFT OUTER JOIN clubTBL C
			ON SC.clubName = C.clubName
UNION
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTBL S
		LEFT OUTER JOIN stdclubTBL SC
			ON SC.stdName = S.stdName
		RIGHT OUTER JOIN clubTBL C
			ON SC.clubName = C.clubName;
            
USE employees;
SELECT count(*) AS '데이터 개수'
	FROM employees
		CROSS JOIN titles;
        
USE sqlDB;
CREATE TABLE empTBL (emp CHAR(3), manager CHAR(3), empTBL VARCHAR(8));
INSERT INTO empTBL VALUES ('나사장', NULL, '0000');
INSERT INTO empTBL VALUES ('김재무', '나사장', '2222');
INSERT INTO empTBL VALUES ('김부장', '김재무', '2222-1');
INSERT INTO empTBL VALUES ('이부장', '김재무', '2222-2');
INSERT INTO empTBL VALUES ('우대리', '이부장', '2222-2-1');
INSERT INTO empTBL VALUES ('지사원', '이부장', '2222-2-2');
INSERT INTO empTBL VALUES ('이영업', '나사장', '1111');
INSERT INTO empTBL VALUES ('한과장', '이영업', '1111-1');
INSERT INTO empTBL VALUES ('최정보', '나사장', '3333');
INSERT INTO empTBL VALUES ('윤차장', '최정보', '3333-1');
INSERT INTO empTBL VALUES ('이주임', '윤차장', '3333-1-1');
SELECT A.emp AS '부하직원', B.emp AS '직속상관', B.empTBL AS '직속상관 연락처'
	FROM empTBL A
		INNER JOIN empTBL B
			ON A.manager = B.emp
		WHERE A.emp = '우대리';