USE sqlDB;

DROP PROCEDURE IF EXISTS userProc3;
DELIMITER $$
CREATE PROCEDURE userProc3(IN txtValue CHAR(10), OUT outvalue INT)
BEGIN
	INSERT INTO testTBL VALUES(NULL, txtValue);
    SELECT MAX(id) INTO outValue FROM testTBL;
END $$
DELIMITER ;

CREATE TABLE IF NOT EXISTS testTBL(
	ID INT AUTO_INCREMENT PRIMARY KEY,
    txt CHAR(10)
);
    
CALL userProc3('테스트값',@myValue);
SELECT CONCAT('현재 입력된 값 ID 값 ->', @myValue);
SELECT * FROM testTBL;
CALL userProc3('두 번째 호출',@myValue);

USE tableDB;
DROP PROCEDURE IF EXISTS ifelseProc;
DELIMITER $$
CREATE PROCEDURE ifelseProc(
	IN userName VARCHAR(10)
)
BEGIN
	DECLARE bYear INT;
    SELECT birthYear INTO bYear FROM userTBL
		WHERE name = userName;
	IF (bYear >= 1980) THEN
		SELECT '아직 젊군요.';
	ELSE
		SELECT '나이가 지긋하시네요.';
	END IF;
END $$
DELIMITER ;

CALL ifelseProc('조용필');

DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc(
	IN userName VARCHAR(10)
)
BEGIN
	DECLARE bYear INT;
    DECLARE tti CHAR(7);
    SELECT birthYear INTO bYear FROM userTBL
		WHERE name = userName;
	CASE
		WHEN(bYear%12 = 0) THEN SET tti = 'monkey';
        WHEN(bYear%12 = 1) THEN SET tti = 'chicken';
        WHEN(bYear%12 = 2) THEN SET tti = 'dog';
        WHEN(bYear%12 = 3) THEN SET tti = 'pig';
        WHEN(bYear%12 = 4) THEN SET tti = 'mouse';
        WHEN(bYear%12 = 5) THEN SET tti = 'cow';
        WHEN(bYear%12 = 6) THEN SET tti = 'tiger';
        WHEN(bYear%12 = 7) THEN SET tti = 'rabbit';
        WHEN(bYear%12 = 8) THEN SET tti = 'dragon';
        WHEN(bYear%12 = 9) THEN SET tti = 'snake';
        WHEN(bYear%12 = 10) THEN SET tti = 'horse';
        ELSE SET tti = 'sheep';
	END CASE;
    SELECT CONCAT(userName, '의 띠 ==>', tti);
END $$
DELIMITER ;

CALL caseProc('권순우');

DROP PROCEDURE IF EXISTS errorProc;
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
	DECLARE i INT ;
    DECLARE hap INT;
    DECLARE saveHap INT;
    DECLARE EXIT HANDLER FOR 1264
    BEGIN
		SELECT CONCAT('INT 오버플로 직선의 합계 --> ' , saveHap);
        SELECT CONCAT('1+2+3+4+...+',i ,'=오버플로');
	END;
    
    SET i = 1;
    SET hap = 0;
    
    WHILE (TRUE) DO
		SET saveHap = hap;
        SET hap = hap + i ;
        SET i = i + 1 ;
        INSERT INTO sumTBL VALUES(str);
	END WHILE;
END $$
DELIMITER ;

CALL errorProc();

DROP TABLE IF EXISTS guguTBL;
CREATE TABLE guguTBL (txt VARCHAR(10000));
DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE str VARCHAR(1000);
    DECLARE i INT;
    DECLARE k INT;
    SET i = 2;
    
    WHILE (i < 20) DO
		SET str = '';
        SET k = 1;
        WHILE (k < 20) DO
            SET str = CONCAT(str, ' ', i, 'x', k, '=', i * k);
            SET k = k + 1;
		END WHILE;
        SET i = i + 1;
		INSERT INTO guguTBL VALUES(str);
	END WHILE;
END $$
DELIMITER ;

CALL whileProc();
SELECT * FROM guguTBL;
	
    

DROP PROCEDURE IF EXISTS nameProc;
DELIMITER $$
CREATE PROCEDURE nameProc(IN tblName VARCHAR(20))
BEGIN
	SET @sqlQuery = CONCAT('SELECT * FROM ', tblName);
    PREPARE myQuery FROM @sqlQuery ;
    EXECUTE myQuery;
    DEALLOCATE PREPARE myQuery;
END $$
DELIMITER ;

CALL nameProc('userTBL');

/*프로시저 함수*/
SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS getAgeFunc;
DELIMITER $$
CREATE FUNCTION getAgeFunc(bYear INT)
	RETURNS INT
BEGIN
	DECLARE age INT;
    SET age = YEAR(CURDATE()) - bYear;
    RETURN age;
END $$
DELIMITER ;

SELECT getAgeFunc(1999);
SELECT getAgeFunc(1999) INTO @age1999;
SELECT getAgeFunc(2023) INTO @age2023;
SELECT CONCAT('1999년과 2023년의 나이 차 ==> ' , (@age2023-@age1999));

USE tableDB;
SELECT userID, name, getAgeFunc(birthYear) AS '만 나이' FROM userTBL;
SHOW CREATE FUNCTION getAgeFunc;

/* 커서 */
DROP PROCEDURE IF EXISTS cursorProc ;
DELIMITER $$
CREATE PROCEDURE cursorProc()
BEGIN
	DECLARE userHeight INT;
    DECLARE cnt INT DEFAULT 0;
    DECLARE totalHeight INT DEFAULT 0;
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;
    
    DECLARE userCuror CURSOR FOR
		SELECT height FROM userTBL;
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET endOfRow = TRUE ;
	OPEN userCuror;
    
    cursor_loop:LOOP
		FETCH userCuror INTO userHeight;
        IF endOfRow THEN
			LEAVE cursor_loop;
		END IF;
        
        SET cnt = cnt + 1;
        SET totalHeight = totalHeight + userHeight;
	END LOOP cursor_loop;
    SELECT CONCAT('고객 키의 평균 ==> ', (totalHeight/cnt));
    CLOSE userCuror;
END $$
DELIMITER ;

CALL cursorProc();

ALTER TABLE userTBL ADD grade VARCHAR(5);

DROP PROCEDURE IF EXISTS gradeProc;
DELIMITER $$
CREATE PROCEDURE gradeProc()
BEGIN
	DECLARE id VARCHAR(10);
    DECLARE hap BIGINT;
    DECLARE userGrade CHAR(5);
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;
    
    DECLARE userCuror CURSOR FOR
		SELECT U.userID, sum(price*amount)
        FROM buyTBL B
			RIGHT OUTER JOIN userTBL U
            ON B.userID = U.userID
		GROUP BY U.userID, U.name ;
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET endOfRow = True;
	OPEN userCuror;
    grade_loop : LOOP
		FETCH userCuror INTO ID, hap;
        IF endOfRow THEN
			LEAVE grade_loop;
		END IF;
        
        CASE 
			WHEN (hap >= 1500) THEN SET userGrade = '최우수고객';
            WHEN (hap >= 1000) THEN SET userGrade = '우수고객';
            WHEN (hap >= 1 ) THEN SET userGrade = '일반고객';
			ELSE SET userGrade = '유령고객';
		END CASE;
        
        UPDATE userTBL SET grade = userGrade WHERE userID = ID;
	END LOOP grade_loop;
    
    CLOSE userCuror;
END $$
DELIMITER ;

CALL gradeProc();
SELECT * FROM userTBL;

/*트리거*/
CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
CREATE TABLE IF NOT EXISTS tableTBL (ID INT, txt VARCHAR(10));
INSERT INTO tableTBL VALUES (1, '레드벨벳');
INSERT INTO tableTBL VALUES (2, 'ITZY');
INSERT INTO tableTBL VALUES (3, '블랙핑크');
DROP TRIGGER IF EXISTS testTrg;
DELIMITER //
CREATE TRIGGER testTrg
	AFTER DELETE
    ON tableTBL
    FOR EACH ROW
BEGIN
	SET @msg = '가수 그룹이 삭제됨';
END //
DELIMITER ;
SET @msg = '';
INSERT INTO tableTBL VALUES (4, '뉴진스');
SELECT @msg;
UPDATE tableTBL SET txt = '블핑' WHERE ID = 3;
SELECT @msg;
DELETE FROM tableTBL WHERE ID = 4;
SELECT @msg;
USE tableDB;
DROP TABLE buyTBL;
CREATE TABLE backup_userTBL
(userID CHAR(8) NOT NULL PRIMARY KEY,
name VARCHAR(10) NOT NULL,
birthYear INT NOT NULL,
addr CHAR(2) NOT NULL,
mobile1 CHAR(3),
mobile2 CHAR(8),
height SMALLINT,
mDate DATE,
modType CHAR(2),
modDate DATE,
modUser VARCHAR(256)
);
DROP TRIGGER IF EXISTS backUserTBL_UpdateTrg;
DELIMITER //
CREATE TRIGGER backUserTBL_UpdateTrg
	AFTER UPDATE
    ON userTBL
    FOR EACH ROW
BEGIN
	INSERT INTO backup_userTBL VALUES (OLD.userID, OLD.name, OLD.birthYear, OLD.addr, OLD.mobile1,
    OLD.mobile2, OLD.height, OLD.mDate,
    '수정', CURDATE(), CURRENT_USER());
END //
DELIMITER ;
UPDATE userTBL SET addr = '몽고' WHERE userID = 'JKW';
DROP TRIGGER backUserTBL_UpdateTrg;
DROP TRIGGER IF EXISTS backUserTBL_DeleteTrg;
DELIMITER //
CREATE TRIGGER backUserTBL_DeleteTrg
	AFTER DELETE
    ON userTBL
    FOR EACH ROW
BEGIN
	INSERT INTO backup_userTBL VALUES (OLD.userID, OLD.name, OLD.birthYear, OLD.addr, OLD.mobile1,
    OLD.mobile2, OLD.height, OLD.mDate,
    '삭제', CURDATE(), CURRENT_USER());
END //
DELIMITER ;
DELETE FROM userTBL WHERE height >= 177;
SELECT * FROM backup_userTBL;
TRUNCATE TABLE userTBL;
SELECT * FROM backup_userTBL;
DROP TRIGGER backUserTBL_DeleteTrg;
DROP TRIGGER IF EXISTS userTBL_InsertTrg;
DELIMITER //
CREATE TRIGGER userTBL_InsertTrg
	AFTER INSERT
    ON userTBL
    FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '데이터의 입력을 시도했습니다. 귀하의 정보가 서버에 기록되었습니다.';
END //
DELIMITER ;
INSERT INTO userTBL VALUES ('ABC', '에비씨', 1977, '서울','011', '1111111', 181, '2019-12-25');
DROP TRIGGER userTBL_InsertTrg;
DROP TRIGGER IF EXISTS userTBL_BeforeInsertTrg;
DELIMITER //
CREATE TRIGGER userTBL_BeforeInsertTrg
	BEFORE INSERT
    ON userTBL
    FOR EACH ROW
BEGIN
	IF NEW.birthYear < 1900 THEN
		SET NEW.birthYear = 0;
	ELSEIF NEW.birthYear > YEAR(CURDATE()) THEN
		SET NEW.birthYear = YEAR(CURDATE());
	END IF;
END //
DELIMITER ;
INSERT INTO userTBL VALUES ('AAA', '에이', 1877, '서울', '011', '1112222', 181, '2022-12-25');
INSERT INTO userTBL VALUES ('BBB', '비이', 2977, '경기', '011', '1113333', 171, '2019-3-25');
SELECT * FROM userTBL;
SHOW TRIGGERS FROM tableDB;
DROP TRIGGER userTBL_BeforeInsertTrg;


/* 중첩 트리거 **/
DROP DATABASE IF EXISTS triggerDB;
CREATE DATABASE IF NOT EXISTS triggerDB;
USE triggerDB;
CREATE TABLE orderTBL(
orderNo INT AUTO_INCREMENT PRIMARY KEY,
userID VARCHAR(5),
prodName VARCHAR(5),
orderamount INT);
CREATE TABLE prodTBL(
prodName VARCHAR(5),
account INT);
CREATE TABLE deliverTBL
(deliverNo INT AUTO_INCREMENT PRIMARY KEY,
prodName VARCHAR(5),
account INT);
INSERT INTO prodTBL VALUES ('사과', 100), ('배', 100), ('귤',100);
DROP TRIGGER IF EXISTS orderTrg;
DELIMITER //
CREATE TRIGGER orderTrg
	AFTER INSERT
    ON orderTBL
    FOR EACH ROW
BEGIN
	UPDATE prodTBL SET account = account - NEW.orderamount
		WHERE prodName = NEW.prodName;
END //
DELIMITER ;
DROP TRIGGER IF EXISTS prodTrg;
DELIMITER //
CREATE TRIGGER prodTrg
	AFTER UPDATE
    ON prodTBL
    FOR EACH ROW
BEGIN
	DECLARE orderAmount INT;
    -- 주문개수 = (변경 전의 개수 - 변경 후의 개수)
    SET orderAmount = OLD.account - NEW.account;
    INSERT INTO deliverTBL(prodName, account) VALUES(NEW.prodName, orderAmount);
END //
DELIMITER ;
INSERT INTO orderTBL VALUES (NULL, 'JOHN','배', 5);
SELECT * FROM orderTBL;
SELECT * FROM prodTBL;
SELECT * FROM deliverTBL;
ALTER TABLE deliverTBL CHANGE prodName productName VARCHAR(5);
INSERT INTO orderTBL VALUES (NULL, 'DANG', '사과', 9);
SELECT * FROM orderTBL;
SELECT * FROM prodTBL;
SELECT * FROM deliverTBL;