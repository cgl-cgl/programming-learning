-- database test
create database test;

-- table test_score
create table test_score (
id int NOT NULL comment "学号",
score int COMMENT "成绩",
PRIMARY KEY (id)
);

INSERT INTO test_score VALUES(1, 80);
INSERT INTO test_score VALUES(2, 78);
INSERT INTO test_score VALUES(3, 78);
INSERT INTO test_score VALUES(4, 78);
INSERT INTO test_score VALUES(5, 60);
