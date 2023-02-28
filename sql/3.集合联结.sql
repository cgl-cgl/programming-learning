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








