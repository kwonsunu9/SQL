CREATE TABLE newTBL
	(id int AUTO_INCREMENT PRIMARY KEY,
    userName CHAR(3),
    age int);
INSERT INTO newTBL VALUES (NULL, '지민', 23), (NULL,'유나', 21), (NULL, '유진', 20);
SELECT * FROM newTBL;
ALTER TABLE newTBL AUTO_INCREMENT = 1000;
SET @@auto_increment_increment = 5;
INSERT INTO newTBL VALUES (NULL, '수현', 23), (NULL,'김현', 21), (NULL, '현준', 20);
SELECT * FROM newTBL;

CREATE TABLE salary (id int, Fname VARCHAR(50), Lname vARCHAR(50))
	(SELECT emp_no, first_name, last_name, gender FROM employees.employees);
-- 테이블 갱신
UPDATE salary
	SET Lname = '없음'
	WHERE Fname = 'Kyoichi';
SELECT * FROM salary;
-- 테이블 삭제
DELETE FROM salary;
DROP TABLE salary;
TRUNCATE TABLE salary;

-- 변수
SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '가수 이름 ==> ';

SELECT @myVar1 ;
SELECT @myVar2 + @myVar3;
SELECT @myVar4, Name FROM userTBL WHERE height > 180 ;

SET @myVar1 = 3;
PREPARE myQuery
	FROM 'SELECT Name, height FROM userTBL ORDER BY height LIMIT ?';
EXECUTE myQuery USING @myVar1 ;

SELECT ASCII('A', SPACE(10));


SELECT ceiling(1025.25658);

SELECT SECOND(535156), MICROSECOND(now());

SELECT current_user(), database();
