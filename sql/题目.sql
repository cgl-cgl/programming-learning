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





