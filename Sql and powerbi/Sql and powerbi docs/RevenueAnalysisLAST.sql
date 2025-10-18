'''
---- Calculate Total Revenue -------
select r.event_time as payment_date, sum(r.revenue) as total_revenue 
from revenue r
group by r.event_time


------ DAU --------
select s.event_date as ses_date, count(distinct (s.user_id)) as dau 
from session s
group by s.event_date
'''


---- ARPDAU -----
With revenue_by_day as (
	select r.event_time as payment_date, sum(r.revenue) as total_revenue 
	from revenue r
	group by r.event_time
),

	dau_by_day as (
	select s.event_date as session_date, count(distinct (s.user_id)) as dau 
	from session s
	group by s.event_date
)

select 
	r.payment_date,
	r.total_revenue,
	s.dau, 
	CAST(1.0 * r.total_revenue / Nullif(s.dau,0) as Decimal(10,2)) as arp_dau		

From revenue_by_day r
join dau_by_day s on r.payment_date = s.session_date;



--------- Liftime Value -----------


with total_revenue  as(
	Select sum(r.revenue) as tot_revenue 
	from revenue r

), 
	total_user  as (
	Select count(distinct i.user_id) as tot_user
	from install i
)

select 
	tr.tot_revenue,
	tu.tot_user,
	CAST(1.0* tr.tot_revenue / tu.tot_user as decimal(10,2)) as LTV
from total_revenue tr, total_user tu 

--------------- Revenue per Network -------------

with joined_data as(
	select 
		i.user_id, 
		i.network, 
		r.revenue

	from install i
	join revenue r on i.user_id = r.user_id
)

select 
	network,
	sum(revenue) as total_revenue
from joined_data 
group by 
	network;



------------ Revenue Cohort (total revenusuz) ---------------------

WITH revenue_cohort AS (
    SELECT 
        r.user_id,
        r.event_time AS revenue_date,
        CAST(r.revenue AS FLOAT) / 100.0 AS revenue,
        i.event_time AS install_date,
        DATEDIFF(DAY, i.event_time, r.event_time) AS day_number
    FROM revenue r
    LEFT JOIN install i ON r.user_id = i.user_id
)

SELECT 
    install_date,
    day_number,
    SUM(revenue) AS revenue
FROM 
    revenue_cohort
WHERE 
    day_number BETWEEN 0 AND 30  -- Sadece install sonrasý ilk 31 gün
GROUP BY 
    install_date, day_number
ORDER BY 
    install_date, day_number;

------------------------- total_revenue ----------------------------------------
WITH revenue_cohort AS (
    SELECT 
        r.user_id,
        r.event_time AS revenue_date,
        CAST(r.revenue AS FLOAT) / 100.0 AS revenue,
        i.event_time AS install_date,
        DATEDIFF(DAY, i.event_time, r.event_time) AS day_number
    FROM revenue r
    LEFT JOIN install i ON r.user_id = i.user_id
)

SELECT 
    SUM(revenue) AS total_revenue_all_users
FROM 
    revenue_cohort;


