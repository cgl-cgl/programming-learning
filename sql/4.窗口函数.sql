/*
窗口函数：
1.聚合函数：SUM、MAX、MIN等等
2.排序用的专用窗口函数：RANK、DENSE_RANK等等
专用窗口函数：
数列：80，78，78，78，60，50（按从大到小排序）
- RANK：1，2，2，2，5，6
- DENSE_RANK：1，2，2，2，3，4
- ROW_NUMBER：1，2，3，4，5，6
*/

/* 理解ORDER BY：指定当前所在行及之前所有的行的聚合结果，ORDER BY 子句并不会影响最终结果的排序。其只是用来决定窗口函数按何种顺序计算。

1. 当RANK() OVER() 或者DENSE_RANK() OVER() 时，所得到的结果是每行的排序值都为1，理解：没有分组没有order by进行指定的情况下，只有一个大窗口，在没有限制条件下，排序值都为1
2. 当ROW_NUMBER() over()时，得到的结果就是行数字，在没有限制条件下，自然返回行数字
3. 当SUM(sale_price) OVER() 时，所得到的结果是所有sale_price的总和，在没有限制条件下，只有一个大窗口，此时SUM表示对所有的行进行汇总求和
4. 当SUM(sale_price) OVER(order by product_id) 时，指定行及之前所有的行均为一个窗口，因此可以得到累加的效果
*/

/*指定更加详细的汇总范围，该汇总范围称为框架
<窗口函数> OVER (ORDER BY <排序用列名>
                 ROWS n PRECEDING)
<窗口函数> OVER (ORDER BY <排序用列名>
                 ROWS BETWEEN n PRECEDING AND n FOLLOWING)
PRECEDING：之前，将框架指定为“截止到之前n行”，加上自身行
FOLLOWING：之后，将框架指定为“截止到之后n行”，加上自身行
注意：可以不需要带上order by使用
*/

SELECT product_id,
       product_name,
			 product_type,
			 sale_price,
			 sum(sale_price) over(order by product_id rows BETWEEN 2 preceding and 2 following) as sum_price
 FROM product;
 
 -- ROLLUP 计算合计、小计
 SELECT product_type,
				sum(sale_price) as sum_price
	FROM product
GROUP BY product_type with ROLLUP;
 

-- 练习题：使用product表，计算出按照登记日期（regist_date）升序进行排列的各日期的销售单价（sale_price）的总额。排序是需要将登记日期为NULL 的“运动 T 恤”记录排在第 1 位（也就是将其看作比其他日期都早）

SELECT product_id,
       product_name,
			 product_type,
			 sale_price,
			 regist_date,
			 sum(sale_price) over (ORDER BY regist_date) as sum_sale_price
			 
FROM product

