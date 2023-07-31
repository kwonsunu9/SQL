-- 데이터 존재  여부 확인 
SHOW databases;

USE employees;
-- 스키마 안에 존재하는 테이블 정보 출력
SHOW table status;

-- 데이터 베이스 안에 존재하는 테이블에 대하여 출력
SHOW tables;

-- employees에 열에 대한 정보 출력
DESC employees;

SELECT * FROM titles;
SELECT * FROM salaries;
SELECT emp_no AS id, salary FROM salaries
	WHERE salary >= 15000
    ORDER BY salary DESC
    LIMIT 2, 5;


-- 테이블 생성
DROP DATABASE IF EXISTS sqldb;
CREATE DATABASE sqldb;

USE sqldb;
CREATE TABLE userTBL
(userID CHAR(8) NOT NULL PRIMARY KEY, 
name VARCHAR(10) NOT NULL,
birthYear INT NOT NULL,
addr CHAR(2) NOT NULL,
mobile1 CHAR(3),
mobile2 CHAR(8),
height SMALLINT,
mDate DATE
);
SELECT * FROM userTBL;
CREATE TABLE buyTBL
(num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
userID CHAR(8) NOT NULL,
prodName CHAR(6) NOT NULL,
groupName CHAR(4),
price INT NOT NULL,
amount SMALLINT NOT NULL,
FOREIGN KEY (userID) REFERENCES userTBL(userID));

INSERT INTO userTBL VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTBL VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTBL VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO userTBL VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO userTBL VALUES('SSK', '성시경', 1979, '서울', NULL, NULL, 186, '2013-12-12');
INSERT INTO userTBL VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO userTBL VALUES('YJS', '윤종신', 1969, '경남', NULL, NULL, 170, '2005-5-5');
INSERT INTO userTBL VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO userTBL VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO userTBL VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buyTBL VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buyTBL VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'JYP', '모니터', '전자', 200, 1);
INSERT INTO buyTBL VALUES(NULL, 'BBK', '모니터', '전자', 200, 5);
INSERT INTO buyTBL VALUES(NULL, 'KBS', '청바지', '의류', 50, 3);
INSERT INTO buyTBL VALUES(NULL, 'BBK', '메모리', '전자', 80, 10);
INSERT INTO buyTBL VALUES(NULL, 'SSK', '책', '서적', 15, 5);
INSERT INTO buyTBL VALUES(NULL, 'EJW', '책', '서적', 15, 2);
INSERT INTO buyTBL VALUES(NULL, 'EJW', '청바지', '의류', 50, 1);
INSERT INTO buyTBL VALUES(NULL, 'BBK', '운동화', NULL, 30, 2);
INSERT INTO buyTBL VALUES(NULL, 'EJW', '책', '서적', 15, 1);
INSERT INTO buyTBL VALUES(NULL, 'BBK', '운동화', NULL, 30, 2);

SELECT * FROM userTBL 
WHERE height >= ALL(SELECT height FROM userTBL WHERE addr = '경남');
SELECT prodName AS '제품명', amount AS '수량', price AS '가격', amount*price AS '총 금액' 
	FROM buyTBL WHERE prodName LIKE '%모%';
SELECT prodName AS '제품명', amount AS '수량', price AS '가격', amount*price AS '총 금액' 
	FROM buyTBL WHERE prodName LIKE '모__';
SELECT DISTINCT prodName FROM buyTBL;
SELECT prodName AS '제품명', amount AS '수량', price AS '가격', amount*price AS '총 금액' 
	FROM buyTBL ORDER BY amount*price DESC;
    
CREATE TABLE newTBL (SELECT prodName, price FROM buyTBL);
SELECT * FROM newTBL;