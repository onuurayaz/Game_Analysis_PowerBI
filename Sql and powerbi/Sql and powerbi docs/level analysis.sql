--win rate calculation
select
	level_id,
	count(*) total_attempt,
	sum(case when status = 'win' then 1 else 0 end) as win_number,
	CAST(SUM(CASE WHEN status = 'win' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) AS win_rate
from level_attempt
group by level_id
order by level_id
--win rate calculation procedure

Create procedure win_rate @level_id int
as
Begin
	select
		level_id,
		count(*) total_attempt,
		sum(case when status = 'win' then 1 else 0 end) as win_number,
		CAST(SUM(CASE WHEN status = 'win' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) AS win_rate
	from level_attempt
	group by level_id
	order by level_id
end;

--Avg time calculation
select
	level_id,
	count(*) as total_attempt,
	count(distinct la.user_id) as unique_player,
	avg(time_spent) as avg_time
from level_attempt la
left join session s on s.session_id = la.session_id
group by level_id
order by level_id

--Avg time calculation procedure
Create procedure avg_time  @level_id int as 
begin
select
	@level_id,
	count(*) as total_attempt,
	count(distinct la.user_id) as unique_player,
	avg(time_spent) as avg_time
from level_attempt la
left join session s on s.session_id = la.session_id
group by level_id
order by level_id
end;




--level difficulity corelation

select
	l.level_id,
	difficulty_rate,
	Count(*) as total_attempt,
	sum(case when status= 'win' then 1 else 0 end) as win_number,
	cast(sum(case when status= 'win' then 1 else 0 end)as float) /Count(*)  as win_rate
from level_attempt la
left join level l on l.level_id = la.level_id
group by l.level_id, l.difficulty_rate
order by l.level_id




--  lose and quit rate
select
	level_id,
	count(*) as total_attempt,
	cast(sum(case when status = 'lose' then 1 else 0 end) as float) / count(*) as lose_rate,
	cast(sum(case when status = 'quit' then 1 else 0 end) as float) / count(*) as quit_rate,
	1 - (CAST(SUM(CASE WHEN status = 'win' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) AS lose_or_quit_rate
from level_attempt
group by level_id
order by level_id;



--first attempt win rate by level
select
	level_id,
	count(*) as total_attempt,
	sum(case when status= 'win' and attempt_number = 1 then 1 else 0 end) as first_attempt_win,
	cast(sum(case when status= 'win' and attempt_number = 1 then 1 else 0 end) as float) / count(*) as first_attempt_win_ratio
from level_attempt
group by level_id
order by level_id


-- win rate per attempt

select 
	level_id,
	attempt_number,
	count(*) as total_attempt,
	cast(sum(case when status= 'win' then 1 else 0 end) as float) / count(*) as first_attempt_win_ratio
from level_attempt
group by level_id, attempt_number
order by level_id, attempt_number;

-- drop_off rate

with user_level as (
	select
		distinct user_id,
		level_id
	from level_attempt
),
next_level_attempt as (
	select 
		ul1.level_id as current_level,
		count(distinct ul1.user_id) as user_on_current_lvl,
		count(distinct ul2.user_id) as user_on_next_lvl
	from user_level ul1
	left join user_level ul2 on ul1.user_id = ul2.user_id
	and ul2.level_id = ul1.level_id + 1
	group by ul1.level_id
)
select
current_level,
user_on_current_lvl,
user_on_next_lvl,
round(100.0*(user_on_current_lvl-user_on_next_lvl) / user_on_current_lvl,2) as droppoff_rate
from next_level_attempt
order by current_level;






