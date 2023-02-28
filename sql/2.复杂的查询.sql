-- CREATE VIEW <视图名称> (<列名1>,<列名2>,...) AS <SELECT 语句>
-- drop view <视图名称>

/* 1.创建出满足下述三个条件的视图（视图名称为 ViewPractice5_1）。使用 product（商品）表作为参照表，假设表中包含初始状态的 8 行数据。
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

-- 2.向视图 ViewPractice5_1中插入如下数据，会得到什么样的结果？为什么？
INSERT into viewpractice5_1 VALUES ('刀子', 300, '2009-11-02');
-- 视图插入数据时，原表也会插入数据，而原表数据插入时不满足约束条件，所以会报错（因为原表有三个带有NOT NULL约束的字段）


-- 3.求出全部商品的平均销售单价sale_price_avg
-- 标量子查询（查询结果只有一个值）
select *
			,(select avg(sale_price) 
			    from product) as sale_price_avg
from product;

-- 4.求出各商品种类的平均销售单价，并保存为视图AvgPriceByType
create view AvgPriceByType AS
select product_id
      ,product_name
			,product_type
			,sale_price
			,(select AVG(sale_price)
			    from product p2
				 where p1.product_type = p2.product_type) as sale_price_avg_type
from product p1;

select *
from AvgPriceByType;


-- IN/NOT IN是无法选取出NULL数据
-- IN(NOT IN)谓词具有其他谓词所没有的用法：可以使用子查询作为其参数
-- EXISTS是只有1个参数的谓词，只需要在右侧书写1个参数，该参数通常都会是一个子查询

-- 5.四则运算中含有NULL时（不进行特殊处理的情况下），运算结果会变为NULL
-- 6.IN和NOT IN谓词无法选取出NULL数据，因此NOT IN或IN中存在NULL时，得到的结果就是NULL
/* 7.按照销售单价( sale_price )对product（商品）表中的商品进行如下分类。
低档商品：销售单价在1000日元以下（T恤衫、办公用品、叉子、擦菜板、 圆珠笔）
中档商品：销售单价在1001日元以上3000日元以下（菜刀）
高档商品：销售单价在3001日元以上（运动T恤、高压锅）
请编写出统计上述商品种类中所包含的商品数量的 SELECT 语句
*/
select sum(case when sale_price <= 1000 then 1 else 0 end) as low_price
			,sum(case when sale_price <= 3000 and sale_price > 1000 then 1 else 0 end) as mid_price
			,sum(case when sale_price > 3000 then 1 else 0 end) as high_price
from product;