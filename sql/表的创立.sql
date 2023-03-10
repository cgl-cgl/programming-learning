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


-- database shop
create database shop;

-- table employee
create table employee (
id VARCHAR(5) not null,
name VARCHAR(10) not null,
salary int not null,
departmentid VARCHAR(5) not null,
PRIMARY KEY (id)
);

INSERT INTO employee VALUES('1', 'Joe', 70000, '1');
INSERT INTO employee VALUES('2', 'Henry', 80000, '2');
INSERT INTO employee VALUES('3', 'Sam', 60000, '2');
INSERT INTO employee VALUES('4', 'Max', 90000, '1');

-- table department
create table department(
id VARCHAR(5) not null,
name VARCHAR(10) not null,
PRIMARY KEY (id)
);

INSERT INTO department VALUES('1', 'IT');
INSERT INTO department VALUES('2', 'Sales');

-- table seat
create table seat(
id VARCHAR(5) not null,
student VARCHAR(15) not null,
PRIMARY KEY (id)
);

insert into seat values('1', 'Abbot');
insert into seat values('2', 'Doris');
insert into seat values('3', 'Emerson');
insert into seat values('4', 'Green');
insert into seat values('5', 'Jeames');


-- table score
create table score(
calss VARCHAR(2) not null,
score_avg int,
PRIMARY KEY(calss)
);

INSERT INTO score VALUES('1', 93);
INSERT INTO score VALUES('2', 93);
INSERT INTO score VALUES('3', 93);
INSERT INTO score VALUES('4', 91);

-- table_num
create table table_num(
id VARCHAR(2) not null,
num int not null,
PRIMARY key (id)
);

insert into table_num values ('1',1);
insert into table_num values ('2',1);
insert into table_num values ('3',1);
insert into table_num values ('4',2);
insert into table_num values ('5',1);
insert into table_num values ('6',2);
insert into table_num values ('7',2);
insert into table_num values ('8',4);
insert into table_num values ('9',3);
insert into table_num values ('10',4);
insert into table_num values ('11',4);
insert into table_num values ('12',4);
insert into table_num values ('13',5);
insert into table_num values ('14',5);
insert into table_num values ('15',5);
insert into table_num values ('16',5);