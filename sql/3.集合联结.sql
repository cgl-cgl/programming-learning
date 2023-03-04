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









