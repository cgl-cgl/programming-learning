-- https://linklearner.com/#/learn/detail/70


--------------------------------------------------------
-- DDL: CREATE DROP ALTER(修改数据库和表等对象的结构)
-- DML: SELECT INSERT UPDATE DELETE
-- DCL: COMMIT ROLLBACK GRANT(赋予用户操作权限) REVOKE(取消用户的操作权限)

-- 1.新建表
-- 列名 数据类型 约束 注释,
create table addressbook(
 regist_no int NOT NULL COMMENT '注册编号',
 name VARCHAR(128) NOT NULL COMMENT '姓名',
 address VARCHAR(256) NOT NULL COMMENT '住址',
 tel_no CHAR(10) COMMENT '电话号码',
 mail_address CHAR(20) COMMENT '邮箱地址',
 PRIMARY KEY (regist_no)
 );
 
 -- 2.添加新的列
alter table addressbook add column postal_code char(8) NOT NULL;


-- 3.删除表
drop table addressbook;

-- 4.误删表后如何恢复：表被误删后在没有其他工具的情况之下无法使用SQL语句进行恢复


--------------------------------------------------------
-- NULL在sql中是第三种逻辑值：UNKNOWN
-- count(*) count(1) 计算全部数据的行数(包括NULL)
-- count(<列名>) 计算该列NULL以外的行数
-- HAVING子句必须和GROUP BY子句配合使用，且HAVING限定的是分组聚合的结果，WHERE限定的是数据行
-- SQL在使用HAVING子句时SELECT语句的执行顺序为：FROM-WHERE-GROUP BY-SELECT-HAVING-ORDER BY，因此ORDER BY可以使用别名

-- 1.从 product(商品) 表中选取出“登记日期(regist_date)在2009年4月28日之后”的商品，查询结果要包含 product name 和 regist_date 两列。
select product_name, regist_date
from product
where regist_date > date'20090428';

-- 2.观察结果输出
SELECT *
  FROM product
 WHERE purchase_price = NULL;

SELECT *
  FROM product
 WHERE purchase_price <> NULL;

SELECT *
  FROM product
 WHERE product_name > NULL;
-- 输出结果为NULL，表示不确定
 
-- 3.从 product 表中取出“销售单价（sale_price）比进货单价（purchase_price）高出500日元以上”的商品
-- 写法1
select product_name, sale_price, purchase_price
from product
where sale_price - purchase_price >= 500;

-- 写法2
select product_name, sale_price, purchase_price
from product
where not (sale_price - purchase_price < 500);

-- 写法3
select product_name, sale_price, purchase_price
from product
where sale_price >= purchase_price + 500;

-- 4.从 product 表中选取出满足“销售单价打九折之后利润高于 100 日元的办公用品和厨房用具”条件的记录。查询结果要包括 product_name列、product_type 列以及销售单价打九折之后的利润（别名设定为 profit）。
SELECT product_name, product_type, (sale_price*0.9-purchase_price) as profit
from product
where (sale_price*0.9-purchase_price) > 100
and (product_type = '办公用品' or product_type = '厨房用具');




