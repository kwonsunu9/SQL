CREATE DATABASE movieDB;
USE movieDB;
CREATE TABLE movieTBL
	(movie_id INT,
    movie_title VARCHAR(30),
    movie_director VARCHAR(20),
    movie_star VARCHAR(20),
    movie_script LONGTEXT,
    movie_film LONGBLOB
    ) DEFAULT CHARSET = utf8mb4;
INSERT INTO movieTBL VALUES (1, '쉰들러 리스트', '스필버그', '리암 니슨',
	load_file('C:/SQL/Movies/Schindler.txt'), load_file('C:/SQL/Movies/Schindler.mp4')
    );
SELECT * FROM movieTBL;
SHOW VARIABLES LIKE 'max_allowed_packet';
SHOW VARIABLES LIKE 'secure_file_priv';
USE movieDB;
TRUNCATE movietbl;
INSERT INTO movieTBL VALUES (2, '쇼생크 탈출', '프랭크 다라본트', '팀 로빈스',
	load_file('C:/SQL/Movies/Shawshank.txt'), load_file('C:/SQL/Movies/Showshank.mp4')
    );
INSERT INTO movieTBL VALUES (3, '라스트 모히칸', '마이클 만', '다니엘 데이 루이스',
	load_file('C:/SQL/Movies/Mohican.txt'), load_file('C:/SQL/Movies/Mohican.mp4')
    );
    
-- 데이터 내려 받기
SELECT movie_script FROM movieTBL WHERE movie_id = 1
	INTO OUTFILE 'C:/SQL/Movies/Schindler_out.txt'
    LINES TERMINATED BY '\\n';
SELECT movie_film FROM movieTBL WHERE movie_id = 3
	INTO DUMPFILE 'C:/SQL/Movies/Mohican_out.mp4';