-- CREATE VIEW <视图名称> (<列名1>,<列名2>,...) AS <SELECT 语句>
-- drop view <视图名称>
/*创建出满足下述三个条件的视图（视图名称为 ViewPractice5_1）。使用 product（商品）表作为参照表，假设表中包含初始状态的 8 行数据。
	条件 1：销售单价大于等于 1000 日元。
	条件 2：登记日期是 2009 年 9 月 20 日。
	条件 3：包含商品名称、销售单价和登记日期三列。
*/
CREATE VIEW ViewPractice5_1 AS 
SELECT product_name
			,sale_price
			,regist_date
from product
where sale_price >= 1000
and regist_date = date'20090920';

-- 向视图 ViewPractice5_1中插入如下数据，会得到什么样的结果？为什么？
INSERT into viewpractice5_1 VALUES ('刀子', 300, '2009-11-02');


-- 求出全部商品的平均销售单价sale_price_avg
-- 标量子查询（查询结果只有一个值）
select *
			,(select avg(sale_price) 
			    from product) as sale_price_avg
from product;

-- 求出各商品种类的平均销售单价
select *
from product
where sale_price > (select avg(sale_price)
			    from product p2
				 where p1.product_type = p2.product_type)
and sale_price > 1000;
