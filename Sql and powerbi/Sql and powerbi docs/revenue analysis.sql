WITH revenue_agg AS (
    SELECT
        user_id,
        SUM(revenue) AS total_revenue
    FROM revenue
    GROUP BY user_id
)

SELECT
    ua.user_id,
	ua.campaign_type,
    ua.event_time,
    ua.network,
    ua.country,
    SUM(ua_cost) AS cost,
    MAX(r.total_revenue) AS revenue
FROM ua_cost ua
LEFT JOIN revenue_agg r ON r.user_id = ua.user_id
GROUP BY ua.user_id, ua.event_time,	ua.campaign_type, ua.network, ua.country
ORDER BY ua.user_id;


create view tr_revenue as 
	select
		sum(revenue) as total_revenue
	from revenue r
	left join install i on i.user_id = r.user_id
	where country = 'tr'





