-- 1.找出每个部门工资最高的员工
/* 先通过聚合函数找到最高or最低的部分
   再通过连结得到最后的结果*/
select department_name,
       name,
	   salary
from(
	 select t2.name as department_name,
			t1.name,
			t1.salary,
			rank() over(PARTITION by t1.departmentid order by t1.salary desc) as salary_rank 
	   from employee t1
  left join department t2
		 on t1.departmentid = t2.id
)t
where salary_rank = 1;
--- 另一种写法：这种写法会更加通用一些，无论是计算最大值还是均值，因为在最外层的连结进行运算比较灵活
select a1.name as department,
       a2.name,
	   a2.salary
from (
	  select t2.id,
			 t2.name,
			 max(t1.salary) as department_max_salary
		from employee t1
   left join department t2
		  on t1.departmentid=t2.id
	group by t2.id,t2.name
     )a1
left join employee a2
       on (a1.id = a2.departmentid
           and a1.department_max_salary = a2.salary)

/* 2.小美是一所中学的信息科技老师，她有一张 seat 座位表，平时用来储存学生名字和与他们相对应的座位 id。
其中纵列的id是连续递增的,小美想改变相邻俩学生的座位同时保持id是连续递增（如果学生的数量为奇数，那么最后一位学生不需要动）*/

select ROW_NUMBER() over(order by t.mid_id) as id,
       t.student
 from(
		select id,
			   student,
			   case when MOD(id,2) = 0 then id-1 else id+1 end as mid_id
		  from seat
	)t;
			
-- 3.用三种专用的窗口排序函数对score表的成绩进行排序
select calss,
       score_avg,
	   rank() over(order by score_avg desc) as rank_,
	   DENSE_RANK() over(order by score_avg desc) as dense_rank_,
	   ROW_NUMBER() over(order by score_avg desc) as row_number_
from score;


-- 4.查找所有至少连续出现三次的数字
/*关键要求：连续出现n次，出现连续说明一般会有一列表示id或者是时间作为限制要求*/
select id,
       num
 from(
		select id,
			   num,
			   count(*) over (PARTITION by num,minus) as count_num
		  from(
				select id,
					   real_id,
					   num,
					   ROW_NUMBER() over(PARTITION BY num ORDER BY real_id) as mid,
					   real_id - (ROW_NUMBER() over(PARTITION BY num ORDER BY id))  as minus 
				  from (select distinct
							   id,
							   ROW_NUMBER() over(order by id) as real_id,
							   num
						  from table_num
					)b
			)t
	)a
where count_num = 3;

-- 5.判断树节点的类型
select a.id,
	   case when a.p_id is null then 'Root'
			when a.p_id is not null and b.mid_id is null then 'Leaf'
			else 'Inner' end as Type	
  from tree a
left join (select DISTINCT p_id as mid_id from tree)b
on a.id = b.mid_id;

-- 答案写法:case when中可以加入子查询，代价：效率低；每执行一行，都可能会执行一次SELECT p_id FROM tree
SELECT id,
       CASE WHEN p_id IS NULL THEN 'Root'
            WHEN id IN (SELECT p_id FROM tree) THEN 'Inner'
            ELSE 'Leaf' END AS Type
FROM tree;

-- 6.写一条SQL语句找出有5个下属的主管
select a.name
from employee_manager a
inner join(
		  select managerid,
		         count(managerid) as employee_count
			from employee_manager
		group by managerid
         )b
    on (a.id = b.managerid
	 and b.employee_count = 5);

-- 答案写法
SELECT
    e1. NAME
FROM employee_manager e1
JOIN (
      SELECT managerid 
        FROM employee_manager
       GROUP BY managerid
      HAVING count(id) = 5
      ) t1 ON e1.id = t1.managerid;

-- 7.查询回答率最高的问题
select question_id
  from(
	   select *,
			  rank() over(order by answer_rate desc) as answer_rate_order
		 from(
			  select question_id,
					 sum(case when action='answer' then 1 else 0 end)/sum(case when action='show' then 1 else 0 end) as answer_rate
				from survey_log
			   group by question_id
			)t
	)a
where answer_rate_order = 1;

-- 答案做法：利用limit
select question_id
  from(
		select question_id,
			   sum(case when action='answer' then 1 else 0 end)/sum(case when action='show' then 1 else 0 end) as answer_rate
		 from survey_log
		group by question_id
		order by answer_rate
		limit 1
	)a;
-- 8.找出每个部门工资前三高的员工
select a.name,
       a.employee_name,
	   a.salary
 from(
		select t2.name,
			   t1.id,
			   t1.name as employee_name,
			   t1.salary,
			   dense_rank() over(partition by t2.name order by t1.salary desc) as department_salary_order
		from employee t1
		left join department t2
		on t1.departmentid = t2.id
		)a
where a.department_salary_order <= 3;


-- 9.求出这些点中的最短距离并保留2位小数
select DISTINCT round(dis,2) as distance
from(
	select  a.x,
			a.y,
			b.x as x_1,
			b.y as y_1,
			power((a.x-b.x),2)+power((a.y-b.y),2) as dis,
			rank() over (order by (power((a.x-b.x),2)+power((a.y-b.y),2))) as rank_	 
		from(
			select  x,
					y,
					row_number() over(order by x,y) as id
				from point_2d
		)a
	left join(select x,
						y,
						row_number() over(order by x,y) as id
				from point_2d
			)b
			on a.id != b.id
)t
where t.rank_ = 1;

-- 答案简便做法
SELECT 
      MIN(ROUND(POW(POW(ABS(p1.x-p2.x),2)+POW(ABS(p1.y-p2.y),2),0.5),2)) AS shortest
  FROM point_2d p1
  JOIN point_2d p2
    ON p1.x!=p2.x 
    OR p1.y!=p2.y;
-- 10.查出2013年10月1日至2013年10月3日期间非禁止用户的取消率。基于上表，你的 SQL 语句应返回如下结果，取消率（Cancellation Rate）保留两位小数。
select request_at,
       round(sum(case when status != 'completed' then 1 else 0 end)/count(status),2) as completed_rate
from(
	  select    a.*,
				b.banned as client_banned,
				c.banned as driver_banned
		from trips a
		left join users b
		on a.client_id = b.users_id
		and b.role = 'client'
		left join users c
		on a.driver_id = c.users_id
		and c.role = 'driver'
			)t1
where (t1.client_banned = 'No'
and t1.driver_banned = 'No')
and request_at between date'20131001' and date'20131003'
group by request_at
order by request_at;

-- section b
-- 1.行转列
select name,
       sum(case when subject='chinese' then score else NULL end) as chinese,
       sum(case when subject='math' then score else NULL end) as math,
       sum(case when subject='english' then score else NULL end) as english	 
from abc_score
group by name

-- 2.列转行
select name,
       'chinese' as subject,
			 chinese as score
from (select name,
						 sum(case when subject='chinese' then score else 0 end) as chinese,
						 sum(case when subject='math' then score else 0 end) as math,
						 sum(case when subject='english' then score else 0 end) as english	 
			from abc_score
			group by name
			)t
union 
select name,
       'math' as subject,
			 math as score
from (select name,
						 sum(case when subject='chinese' then score else 0 end) as chinese,
						 sum(case when subject='math' then score else 0 end) as math,
						 sum(case when subject='english' then score else 0 end) as english	 
			from abc_score
			group by name
			)t
union
select name,
       'english' as subject,
			 english as score
from (select name,
						 sum(case when subject='chinese' then score else 0 end) as chinese,
						 sum(case when subject='math' then score else 0 end) as math,
						 sum(case when subject='english' then score else 0 end) as english	 
			from abc_score
			group by name
			)t;

-- 3.谁是明星带货主播？
-- 定义：如果某主播的某日销售额占比达到该平台当日销售总额的 90% 及以上，则称该主播为明星主播，当天也称为明星主播日。
-- 2021年有多少个明星主播日？
select count(distinct anchor_name) as zhubo_date
from(
	select *,
		   case when sales/(sum(sales) over(partition by date))>= 0.9 then 1 else 0 end as sale_90
	from anchor_sales
	)t
where sale_90>0
and date between date'20210101' and date'20211231';
-- 2021年有多少个明星主播
select count(distinct anchor_name) as zhubo
from(
		select *,
					 case when sales/(sum(sales) over(partition by date))>= 0.9 then 1
								else 0 end as sale_90
		from anchor_sales
		)t
where sale_90>0
and date between date'20210101' and date'20211231';

-- 练习四：MySQL 中如何查看sql语句的执行计划？可以看到哪些信息？
-- 练习五：解释一下 SQL 数据库中 ACID 是指什么

-- section c
-- 练习一：行转列
select cdate as '比赛日期',
       sum(case when result = '胜' then 1 else 0 end) as '胜',
			 sum(case when result = '负' then 1 else 0 end) as '负'
from march
group by cdate

-- 练习二：列转行（答案）
SELECT 
        a.date_time AS cdate
        ,'胜' AS result 
        ,b.help_topic_id
FROM 
        col_row AS a 
INNER JOIN mysql.help_topic AS b ON b.help_topic_id < a.success
UNION ALL 
SELECT 
        a.date_time AS cdate
        ,'负' AS result 
        ,b.help_topic_id
FROM 
        col_row AS a 
INNER JOIN mysql.help_topic AS b ON b.help_topic_id < a.fail 
ORDER BY 
        cdate, 
        result;


-- 练习三：连续登录
-- 1.计算2021年每个月，每个用户连续登录的最多天数
select month_,max(continue_days) as max_continue_days
from(
			select distinct
			       c1.month_,
						 c1.uid,
						 count(c1.uid) over(PARTITION by c1.month_,c1.uid,c1.minus) as continue_days
			from(
						select b1.month_,
						       b1.date,
									 b1.uid,
									 b1.uid_date_rownum,
									 b1.uid_date_rownum - (row_number() over(partition by b1.month_,b1.uid order by b1.date)) as minus
						from(
									select a1.month_,
									       a1.date,
												 a1.uid,
												 a2.uid as real_uid,
												 row_number() over(partition by a1.month_,a1.uid order by a1.date) as uid_date_rownum
									from(
											select month(date) as month_ ,date,uid
											from date_2021,(select distinct uid from t_act_records) t
											)a1
									left join t_act_records a2
									on a1.date = a2.imp_date
									and a1.uid = a2.uid
								)b1
						where b1.real_uid is not null
			)c1
)d1
group by month_;
-- 计算2021年每个月，连续2天都有登录的用户名单
select month_,uid
from(
			select distinct
			       c1.month_,
						 c1.uid,
						 count(c1.uid) over(PARTITION by c1.month_,c1.uid,c1.minus) as continue_days
			from(
						select b1.month_,
						       b1.date,
									 b1.uid,
									 b1.uid_date_rownum,
									 b1.uid_date_rownum - (row_number() over(partition by b1.month_,b1.uid order by b1.date)) as minus
						from(
									select a1.month_,
									       a1.date,
												 a1.uid,
												 a2.uid as real_uid,
												 row_number() over(partition by a1.month_,a1.uid order by a1.date) as uid_date_rownum
									from(
											select month(date) as month_ ,date,uid
											from date_2021,(select distinct uid from t_act_records) t
											)a1
									left join t_act_records a2
									on a1.date = a2.imp_date
									and a1.uid = a2.uid
								)b1
						where b1.real_uid is not null
			)c1
)d1
where d1.continue_days = 2;
-- 计算2021年每个月，连续5天都有登录的用户名单
select month_,uid
from(
			select distinct
			       c1.month_,
						 c1.uid,
						 count(c1.uid) over(PARTITION by c1.month_,c1.uid,c1.minus) as continue_days
			from(
						select b1.month_,
						       b1.date,
									 b1.uid,
									 b1.uid_date_rownum,
									 b1.uid_date_rownum - (row_number() over(partition by b1.month_,b1.uid order by b1.date)) as minus
						from(
									select a1.month_,
									       a1.date,
												 a1.uid,
												 a2.uid as real_uid,
												 row_number() over(partition by a1.month_,a1.uid order by a1.date) as uid_date_rownum
									from(
											select month(date) as month_ ,date,uid
											from date_2021,(select distinct uid from t_act_records) t
											)a1
									left join t_act_records a2
									on a1.date = a2.imp_date
									and a1.uid = a2.uid
								)b1
						where b1.real_uid is not null
			)c1
)d1
where d1.continue_days = 5;

------- 参考教程后的写法
select distinct
       year_month_,
       uid,
	     count(*) over(PARTITION by year_month_,uid,uid_date_order) as continue_days
 from(
			-- 2.对uid组内的日期进行排序，并计算日期减去排序值的结果，如果日期连续，则相减后的结果相等
			select year_month_,
			       uid,
						 imp_date,
						 date_sub(imp_date,interval (row_number() over(PARTITION by year_month_,uid order by imp_date)) day) as uid_date_order
			 from(
						-- 1.去重
						select DATE_FORMAT(imp_date,'%Y-%m') as year_month_,uid,imp_date from t_act_records group by year_month_,uid,imp_date
						)a
			)b

-- 用户购买商品推荐
select c1.user_id,c3.product_id
from(
			-- 找出我没吃过的东西
			select b.user_id,b.all_product as not_product_id
			from(
					select a1.user_id, a1.product_id as all_product, a2.product_id
					from(
							select t1.user_id, t2.product_id
							from (select distinct user_id from orders) t1,
							(select distinct product_id from orders) t2
							)a1
					left join (select distinct user_id, product_id from orders) a2
					on a1.user_id = a2.user_id
					and a1.product_id = a2.product_id
				)b
			where b.product_id is null
)c1
inner join (
						-- 找出我的兄弟
						select a.user_id,a.maybe_my_brother as my_brother
						from(
									select distinct
												 t1.user_id,
												 t2.user_id as maybe_my_brother,
												 count(t2.user_id) over (PARTITION by t1.user_id,t2.user_id) as  maybe_my_brother_count
									from orders t1
									left join orders t2
									on (t1.product_id = t2.product_id
									and t1.user_id <> t2.user_id)
						)a
						where maybe_my_brother_count >= 2
)c2
on c1.user_id = c2.user_id
inner join orders c3
on c1.not_product_id = c3.product_id
AND c2.my_brother = c3.user_id
order by c1.user_id;