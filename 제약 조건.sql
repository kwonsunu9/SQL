-- 제약조건 
DROP SCHEMA IF EXISTS tableDB;
CREATE SCHEMA tableDB;
USE tableDB;
DROP TABLE IF EXISTS buyTBL, userTBL;
CREATE TABLE userTBL
(userID CHAR(8),
name VARCHAR(10),
birthYear INT,
addr CHAR(2),
mobile1 CHAR(3),
mobile2 CHAR(8),
height SMALLINT,
mDate DATE);
CREATE TABLE buyTBL
(num INT AUTO_INCREMENT PRIMARY KEY,
userID CHAR(8),
prodName CHAR(6),
groupName CHAR(4),
price INT,
amount SMALLINT
);
INSERT INTO userTBL VALUES ('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTBL VALUES ('KBS', '김범수', NULL, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTBL VALUES ('KKH', '김경호', 1871, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO userTBL VALUES ('JYP', '조용필', 1987, '경기', '011', '4444444', 166, '2009-4-4');
SET foreign_key_checks = 0;
INSERT INTO buyTBL VALUES (NULL, 'BBK', '모니터', '전자', 200, 5);
INSERT INTO buyTBL VALUES (NULL, 'KBS', '청바지', '의류', 50, 3);
INSERT INTO buyTBL VALUES (NULL, 'BBK', '메모리', '전자', 80, 10);
INSERT INTO buyTBL VALUES (NULL, 'SSK', '책', '서적', 15, 5);
INSERT INTO buyTBL VALUES (NULL, 'EJW', '책', '서적', 15, 2);
INSERT INTO buyTBL VALUES (NULL, 'EJW', '청바지', '의류', 50, 1);
INSERT INTO buyTBL VALUES (NULL, 'BBK', '운동화', NULL, 30, 2);
INSERT INTO buyTBL VALUES (NULL, 'EJW', '책', '서적', 15, 1);
INSERT INTO buyTBL VALUES (NULL, 'BBK', '운동호', NULL, 30, 2);
SET foreign_key_checks = 1;

ALTER TABLE userTBL
	ADD CONSTRAINT PK_userTBL_userID
    PRIMARY KEY (userID);
DESC userTBL;

DELETE FROM buyTBL WHERE userID = 'BBK';
/*
ALTER TABLE buyTBL
	ADD CONSTRAINT FK_userTBL_buyTBL
    FOREIGN KEY (userID)
    REFERENCES userTBL (userID);
*/

UPDATE userTBL SET birthYear=1979 WHERE userID = 'KBS';
UPDATE userTBL SET birthYear=1971 WHERE userID = 'KKH';
ALTER TABLE userTBL
	ADD CONSTRAINT CK_birthYear
    CHECK ((birthYear >= 1900 AND birthYear <= 2023) AND (birthYear IS NOT NULL));
INSERT INTO userTBL VALUES ('TKV', '태권뷔', 2999, '우주', NULL, NULL, 186, '2023-12-12');
INSERT INTO userTBL VALUES ('SSK', '신세경', 1979, '서울', NULL, NULL, 186, '2023-12-12');
INSERT INTO userTBL VALUES ('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO userTBL VALUES ('YJS', '윤종신', 1969, '경남', NULL, NULL, 170, '2005-5-5');
INSERT INTO userTBL VALUES ('EJW', '은지원', 1972, '경북', '018', '8888888', 174, '2014-3-3');
INSERT INTO userTBL VALUES ('JKW', '조관우', 1965, '경기', '011', '9999999', 172, '2010-10-10');
INSERT INTO userTBL VALUES ('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');

SET foreign_key_checks = 0;
UPDATE userTBL SET userID = 'VVK' WHERE userID = 'BBK';
SET foreign_key_checks = 1;
SELECT B.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buyTBL B
		INNER JOIN userTBL U
			ON B.userID = U.userID;
SELECT COUNT(*) FROM buyTBL;
SELECT B.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buyTBL B
		LEFT OUTER JOIN userTBL U
			ON B.userID = U.userID
	ORDER BY B.userID;
    
SET foreign_key_checks = 0;
UPDATE userTBL SET userID = 'BBK' WHERE userID = 'VVK';
SET foreign_key_checks = 1;

/*
ALTER TABLE buyTBL
	DROP FOREIGN KEY FK_userTBL_buyTBL;
*/

ALTER TABLE buyTBL
	ADD CONSTRAINT FK_userTBL_buyTBL
		FOREIGN KEY (userID)
        REFERENCES userTBL (userID)
        ON UPDATE CASCADE;
UPDATE userTBL SET userID = 'VVK' WHERE userID = 'BBK';
SELECT B.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buyTBL B
		INNER JOIN userTBL U
			ON B.userID = U.userID
	ORDER BY B.userID;
ALTER TABLE buyTBL
	DROP FOREIGN KEY FK_userTBL_buyTBL;
ALTER TABLE buyTBL
	ADD CONSTRAINT FK_userTBL_buyTBL
		FOREIGN KEY (userID)
        REFERENCES userTBL (userID)
        ON UPDATE CASCADE
        ON DELETE CASCADE;
DELETE FROM userTBL WHERE userID = 'VVK';
SELECT * FROM buyTBL;
/*
ALTER TABLE userTBL
	DROP COLUMN birthYear ;
*/