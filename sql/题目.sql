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
					from (select id,
					             ROW_NUMBER() over(order by id) as real_id,
											 num
					        from table_num
								)b
-- 					order by real_id
					)t
			)a
where count_num = 4

-- 5.判断树节点的类型
select a.id,
			 case when a.p_id is null then 'Root'
			      when a.p_id is not null and b.mid_id is null then 'Leaf'
					  else 'Inner' end as Type	
from tree a
left join (select DISTINCT p_id as mid_id
             from tree)b
on a.id = b.mid_id


select a.id,
			 case when a.p_id is null then 'Root'
			      when a.p_id is not null and b.mid_id is null then 'Leaf'
					  else 'Inner' end as Type	
from tree a
left join (select DISTINCT p_id as mid_id
             from tree)b
on a.id = b.mid_id;


-- 6.写一条SQL语句找出有5个下属的主管
select a.name
from employee_manager a
left join(
					select distinct 
								 managerid,
								 count(managerid) over(partition by managerid) as employee_count
					from employee_manager
					)b
on a.id = b.managerid
where b.employee_count = 5

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
where answer_rate_order = 1

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
			select a.x,
						 a.y,
						 b.x as x_1,
						 b.y as y_1,
						 power((a.x-b.x),2)+power((a.y-b.y),2) as dis,
						 rank() over (order by (power((a.x-b.x),2)+power((a.y-b.y),2))) as rank_
						 
			 from(
						select x,
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

-- 10.查出2013年10月1日至2013年10月3日期间非禁止用户的取消率。基于上表，你的 SQL 语句应返回如下结果，取消率（Cancellation Rate）保留两位小数。
select request_at,
       round(sum(case when status != 'completed' then 1 else 0 end)/count(status),2) as completed_rate
from(
			select a.*,
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

-- s

