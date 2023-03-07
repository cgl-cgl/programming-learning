/*题型1
*/
select a.*,
       b.*,
			 c.*
 from test_score a,
test_score b,
test_score c
where a.id = b.id-1
and b.id = c.id-1
and a.score=b.score
and b.score=c.score
order by a.id,b.id,c.id