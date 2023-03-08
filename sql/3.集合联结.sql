-- UNION: 并集运算，并会自动删除重复记录
-- 1.假设连锁店想要增加成本利润率超过 50%或者售价低于 800 的货物的存货量, 请使用 UNION 对分别满足上述两个条件的商品的查询结果求并集
select *
from product
where (sale_price-purchase_price)/purchase_price>= 0.5
UNION
select *
from product
where sale_price<= 800;
-- 2.商店决定对product表中成本利润低于50% 或者 售价低于1000的商品提价, 请使用UNION ALL 语句将分别满足上述两个条件的结果取并集
select *
from product
where (sale_price-purchase_price)/purchase_price < 0.5
UNION ALL
select *
from product
where sale_price < 1000;

-- 隐式数据类型转换：将两个类型不同的列放在一列里显示（UNION可实现）
-- hive中进行join关联时，关联列要避免使用隐式数据类型转换，否则容易导致数据倾斜


-- INTERSECT：集合的交，但是mysql不支持，也不支持EXCEPT运算（减法运算，集合A减去集合B，表示将集合A中同时属于集合B的元素减掉）
-- 3.使用NOT谓词进行集合的减法运算, 求出 Product 表中, 售价高于2000、成本利润率不低于 30% 的商品
select *
from product
where product_id NOT IN (select product_id
													 from product
												  where sale_price<2000
													   or sale_price<1.3*purchase_price);


-- 4.使用AND谓词查找product表中利润率高于50%,并且售价低于1500的商品
select *
from product
where sale_price>=1.5*purchase_price
and sale_price <= 1500;

-- 对称差：仅属于A的元素或仅属于B的元素构成的集合
-- 5.使用Product表和Product2表的对称差来查询哪些商品只在其中一张表
select *
from product
where product_id not in (select product_id
                           from product2
												 )
 UNION
 select *
 from product2
where product_id not in (select product_id
                           from product
												 );



-- 6.找出每个商店里的衣服类商品的名称及价格等信息
select t1.shop_id,
       t1.shop_name,
			 t1.product_id,
			 t2.product_name,
			 t2.product_type,
			 t2.purchase_price
from shopproduct t1
inner join product t2
on t1.product_id = t2.product_id
where t2.product_type = '衣服';

-- 7.使用连结两个子查询和不使用子查询的方式, 找出东京商店里, 售价低于 2000 的商品信息
-- 不使用子查询
select t1.shop_id,
       t1.shop_name,
			 t1.product_id,
			 t1.quantity,
			 t2.product_id,
			 t2.product_name,
			 t2.product_type,
			 t2.sale_price
from shopproduct t1
inner join product t2
on t1.product_id = t2.product_id
where t2.sale_price<= 2000
and t1.shop_name = '东京';
-- 使用子查询
select t1.shop_id,
       t1.shop_name,
			 t1.product_id,
			 t1.quantity,
			 t2.product_id,
			 t2.product_name,
			 t2.product_type,
			 t2.sale_price
from (select *
        from shopproduct
			 where shop_name = '东京') t1
inner join (select *
              from product
						 where sale_price<= 2000)  t2
on t1.product_id = t2.product_id;


-- 8.每个商店中, 售价最高的商品的售价分别是多少
select t1.shop_id,
			 max(t2.sale_price) as max_sale_price
 from shopproduct t1
 inner join product t2
 on t1.product_id = t2.product_id
 group by t1.shop_id

 /*拓展：
 t1商店表：商店id，商品id
 t2商品表：商品id，商品销售价格
 展示 每间商店最贵的商品(三个字段：商店id，商品id，商品最高销售价格）
 */
 -- 关联子查询
 select t1.shop_id,
							t1.product_id,
							t2.sale_price
				from shopproduct t1
       INNER JOIN product t2 
			  on t1.product_id = t2.product_id 
where t2.sale_price  = (SELECT max(a.sale_price)
                        from (select t1.shop_id,
																			t1.product_id,
																			t2.sale_price
																from shopproduct t1
															 INNER JOIN product t2 
																on t1.product_id = t2.product_id )a
												where t1.shop_id = a.shop_id);
-- 联结
select a.*
from 
 (select t1.shop_id,
							t1.product_id,
							t2.sale_price
				from shopproduct t1
       INNER JOIN product t2 
			  on t1.product_id = t2.product_id )a
INNER JOIN (select t1.shop_id,
										min(t2.sale_price) as max_sale_price
							from shopproduct t1
						 INNER JOIN product t2 
							on t1.product_id = t2.product_id 
							GROUP BY t1.shop_id)b
	on a.shop_id = b.shop_id
	and a.sale_price = b.max_sale_price;
 
 -- 窗口函数
 
 
 
 
 



-- 自然连结NATURAL JOIN：内连结的一种特例，当两个表进行自然连结时，会按照两个表中都包含的列名来进行等值内连结，无需使用ON指定连接条件

select *
from product
NATURAL JOIN product2

-- 使用内连结求 Product 表和 Product2 表的交集

select t1.*
from product t1
INNER JOIN product2 t2
on t1.product_id = t2.product_id
and t1.product_name = t2.product_name
and t1.product_type = t2.product_type
and t1.sale_price = t2.sale_price
and t1.purchase_price = t2.purchase_price
and t1.regist_date = t2.regist_date;

-- 外连结（左连结、右连结、外连结）
-- 统计每种商品分别在哪些商店有售, 需要包括那些在每个商店都没货的商品。
select t1.product_id,
			 t1.product_name,
			 t2.shop_name
from product t1
left join shopproduct t2
on t1.product_id = t2.product_id;


-- 使用外连结从ShopProduct表和Product表中找出那些在某个商店库存少于50的商品及对应的商店
-- 注意：如果此时where条件写在最外层时，两个库存为空的商品就不会被筛选出来，因此要注意where条件的位置
SELECT t1.product_id,
		   t1.product_name,
			 t1.sale_price,
			 t2.shop_id,
			 t2.shop_name,
			 t2.quantity
 from product t1
left join (select *
						from shopproduct
						where quantity < 50)t2
			on t1.product_id = t2.product_id;
			
-- 使用内连接找出每个商店都有哪些商品, 每种商品的库存总量分别是多少
/*
1.INNER JOIN不管连接多少表，连接条件来自主表或者是上一个inner join的表得到的结果都是一样的
2.LEFG JOIN的连接条件便会影响筛选出来的结果，比如p为主表，left join sp和ip（前提：p和ip的id相等，sp的id较少）连接条件1为p.id = sp.id
连接条件2如果为p.id = ip.id，那么ip的所有id都能被选择出来；
连接条件2如果为sp.id = ip.id，那么ip被选择出来的id与sp是相等的
*/
select sp.shop_name,
			 p.product_name,
			 ip.inventory_id,
			 ip.inventory_quantity
from shopproduct sp
inner join product p
on sp.product_id = p.product_id
inner JOIN inventoryproduct ip
on sp.product_id = ip.product_id;

-- ON子句非等值连结：比较运算符(<,<=,>,>=,BETWEEN)和谓词运算(LIKE,IN,NOT等等)都能作为连结条件
-- 对 Product 表中的商品按照售价赋予排名. 一个从集合论出发,使用自左连结的思路是, 对每一种商品,找出售价不低于它的所有商品, 然后对售价不低于它的商品使用 COUNT 函数计数

SELECT t1.product_name,
       RANK() OVER(ORDER BY COUNT(t2.product_name)) AS rank1
FROM product t1
LEFT JOIN product t2
ON t1.sale_price <= t2.sale_price
AND t1.product_id != t2.product_id
GROUP BY t1.product_name

-- 交叉连结，笛卡尔积，在连结去掉ON子句

-- 练习题1：找出 product 和 product2 中售价高于 500 的商品的基本信息。
SELECT *
FROM product
WHERE sale_price > 500
UNION ALL
SELECT *
FROM product2
WHERE sale_price > 500;
-- 练习题2：借助对称差的实现方式, 求product和product2的交集。
select *
from 
(SELECT *
FROM product
UNION
SELECT *
FROM product2
)t
WHERE product_id NOT IN(
												SELECT product_id
												FROM product
												WHERE product_id NOT IN (SELECT product_id
																									 FROM product2
																							 GROUP BY product_id)
												UNION
												SELECT product_id
												FROM product2
												WHERE product_id NOT IN (SELECT product_id
																									 FROM product
																							 GROUP BY product_id)
										    );
/*
select *
from TABLE1
UNION
SELECT *
from TABLE2
where xxx
where条件在此处筛选影响的是table2还是table1 union table2的综合结果
*/
-- 练习题3：每类商品中售价最高的商品都在哪些商店有售 ？
-- 每类商品 GROUP BY product.product_type
-- 售价最高的商品 MAX(product.sale_price)
-- 商店 LEFT JOIN

select t1.*,
			 t2.max_sale_price,
			 t3.shop_name
from product t1
left join shopproduct t3
on t1.product_id = t3.product_id
inner JOIN(
					select product_type,
								 max(sale_price) as max_sale_price
					from product
					group by product_type
					)t2
on t1.product_type = t2.product_type
and t1.sale_price = t2.max_sale_price

-- 开窗函数
SELECT *
FROM(
SELECT p1.product_id,
       p1.product_name,
			 p1.product_type,
			 p1.sale_price,
			 MAX(p1.sale_price) OVER (PARTITION BY p1.product_type) as max_sale_price,
			 p2.shop_name
FROM product p1
LEFT JOIN shopproduct p2
ON p1.product_id = p2.product_id
)t
WHERE t.sale_price = t.max_sale_price

-- 参考答案
-- 取出想要的字段
SELECT sp.shop_id, sp.shop_name, sp.product_id ,p.product_type
    FROM shopproduct sp
JOIN product p
  ON sp.product_id=p.product_id
 WHERE sp.product_id in
-- 过滤每个类型售价最高的商品
(SELECT product_id 
     FROM product p1
 JOIN (SELECT product_type,
              MAX(sale_price) as max_price 
           FROM product 
       GROUP BY product_type) p2 
             ON p1.product_type=p2.product_type AND p1.sale_price=p2.max_price);

-- 练习题4：分别使用内连结和关联子查询每一类商品中售价最高的商品。

-- 内连结
select t1.*,
			 t2.max_sale_price
from product t1
inner JOIN(
					select product_type,
								 max(sale_price) as max_sale_price
					from product
					group by product_type
					)t2
on t1.product_type = t2.product_type
and t1.sale_price = t2.max_sale_price

-- 关联子查询
select *
from product t1
WHERE sale_price in (SELECT max(sale_price) as max_sale_price
                       from product t2
										 where t1.product_type = t2.product_type
										 GROUP BY product_type)


-- 练习题5：用关联子查询实现：在 product 表中，取出 product_id, product_name, sale_price, 并按照商品的售价从低到高进行排序、对售价进行累计求和。
select product_id,
       product_name,
			 sale_price,
			 (select sum(sale_price) as sum_sale_price
			   from  product t2
				 where t1.sale_price > t2.sale_price
				  or (t1.sale_price = t2.sale_price  and  t1.product_id >= t2.product_id)) as sum_sale_price
 from product t1
 ORDER BY t1.sale_price,t1.product_id















