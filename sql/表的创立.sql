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
INSERT INTO employee VALUES('5', 'Janet', 69000, '1');
INSERT INTO employee VALUES('6', 'Randy', 85000, '1');

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
insert into seat values('6', 'John');


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

-- table table_num
create table table_num(
id int not null,
num int not null,
PRIMARY key (id)
);

insert into table_num values (1,1);
insert into table_num values (2,1);
insert into table_num values (3,1);
insert into table_num values (4,2);
insert into table_num values (5,1);
insert into table_num values (6,2);
insert into table_num values (7,2);
insert into table_num values (8,4);
insert into table_num values (9,3);
insert into table_num values (10,4);
insert into table_num values (11,4);
insert into table_num values (12,4);
insert into table_num values (13,5);
insert into table_num values (14,5);
insert into table_num values (15,5);
insert into table_num values (16,5);

-- table tree
CREATE table tree(
id int not null,
p_id int,
primary key(id)
);

insert into tree values(1,null);
insert into tree values(2,1);
insert into tree values(3,1);
insert into tree values(4,2);
insert into tree values(5,2);


--  employee_manager
create table employee_manager(
id char(3) not null,
name VARCHAR(10) not null,
department VARCHAR(2) not null,
managerid char(3),
PRIMARY KEY(id)
)

insert into employee_manager values('101', 'John', 'A', null);
insert into employee_manager values('102', 'Dan', 'A', '101');
insert into employee_manager values('103', 'James', 'A', '101');
insert into employee_manager values('104', 'Amy', 'A', '101');
insert into employee_manager values('105', 'Anne', 'A', '101');
insert into employee_manager values('106', 'Ron', 'B', '101');


-- survey_log
create table survey_log(
uid VARCHAR(2) not null,
action varchar(8) not null,
question_id VARCHAR(5) not null,
answer_id varchar(10),
q_num VARCHAR(10),
TIMESTAMP int)

insert into survey_log values ('5', 'show', '285', null, '1', 123);
insert into survey_log values ('5', 'answer', '285', '124124', '1', 124);
insert into survey_log values ('5', 'show', '369', null, '2', 125);
insert into survey_log values ('5', 'skip', '369', null, '2', 126);

-- point_2d
create table point_2d(
x int not null,
y int not null
);

INSERT INTO point_2d VALUES(-1, -1);
INSERT INTO point_2d VALUES(0, 0);
INSERT INTO point_2d VALUES(-1, -2);

-- trips
create table trips(
id VARCHAR(2) not null,
client_id VARCHAR(2),
driver_id VARCHAR(2),
city_id VARCHAR(2),
status varchar(20),
request_at date,
PRIMARY KEY(id)
);

insert into trips values('1', '1', '10', '1', 'completed', date'20131001');
insert into trips values('2', '2', '11', '1', 'cancelled_by_driver', date'20131001');
insert into trips values('3', '3', '12', '6', 'completed', date'20131001');
insert into trips values('4', '4', '13', '6', 'cancelled_by_client', date'20131001');
insert into trips values('5', '1', '10', '1', 'completed', date'20131002');
insert into trips values('6', '2', '11', '6', 'completed', date'20131002');
insert into trips values('7', '3', '12', '6', 'completed', date'20131002');
insert into trips values('8', '2', '12', '12', 'completed', date'20131003');
insert into trips values('9', '3', '10', '12', 'completed', date'20131003');
insert into trips values('10', '4', '13', '12', 'cancelled_by_driver', date'20131003');


-- users
create table users(
users_id VARCHAR(2) not null,
banned VARCHAR(5),
role varchar(10),
PRIMARY KEY(users_id)
);

insert into users values('1', 'No', 'client');
insert into users values('2', 'Yes', 'client');
insert into users values('3', 'No', 'client');
insert into users values('4', 'No', 'client');
insert into users values('10', 'No', 'driver');
insert into users values('11', 'No', 'driver');
insert into users values('12', 'No', 'driver');
insert into users values('13', 'No', 'driver');


-- abc_score
create table abc_score(
name CHAR(1) not null,
subject VARCHAR(10) not null,
score int not null
);

insert into abc_score values('A', 'chinese', 99);
insert into abc_score values('A', 'math', 98);
insert into abc_score values('A', 'english', 97);
insert into abc_score values('B', 'chinese', 92);
insert into abc_score values('B', 'math', 91);
insert into abc_score values('B', 'english', 90);
insert into abc_score values('C', 'chinese', 88);
insert into abc_score values('C', 'math', 87);
insert into abc_score values('C', 'english', 86);

-- anchor_sales
create table anchor_sales(
anchor_name VARCHAR(2),
date date,
sales int);

insert into anchor_sales values('A', '20210101', 40000);
insert into anchor_sales values('B', '20210101', 80000);
insert into anchor_sales values('A', '20210102', 10000);
insert into anchor_sales values('C', '20210102', 90000);
insert into anchor_sales values('A', '20210103', 7500);
insert into anchor_sales values('C', '20210103', 80000);

-- march
create table march(
cdate date,
result VARCHAR(2)
);

insert into march values('20210101', '胜');
insert into march values('20210101', '胜');
insert into march values('20210101', '负');
insert into march values('20210103', '胜');
insert into march values('20210103', '负');
insert into march values('20210103', '负');

-- t_act_records
DROP TABLE if EXISTS t_act_records;
CREATE TABLE t_act_records
(uid  VARCHAR(20),
imp_date DATE);

INSERT INTO t_act_records VALUES('u1001', 20210101);
INSERT INTO t_act_records VALUES('u1002', 20210101);
INSERT INTO t_act_records VALUES('u1003', 20210101);
INSERT INTO t_act_records VALUES('u1003', 20210102);
INSERT INTO t_act_records VALUES('u1004', 20210101);
INSERT INTO t_act_records VALUES('u1004', 20210102);
INSERT INTO t_act_records VALUES('u1004', 20210103);
INSERT INTO t_act_records VALUES('u1004', 20210104);
INSERT INTO t_act_records VALUES('u1004', 20210105);

-- orders
create table orders(
user_id VARCHAR(3) not null,
product_id VARCHAR(3) not null);

insert into orders values('123','1');
insert into orders values('123','2');
insert into orders values('123','3');
insert into orders values('456','1');
insert into orders values('456','2');
insert into orders values('456','4');
insert into orders values('789','1');
insert into orders values('789','2');
insert into orders values('789','5');
insert into orders values('234','2');
insert into orders values('234','3');