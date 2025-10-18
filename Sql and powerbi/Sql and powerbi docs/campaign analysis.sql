WITH revenue_agg AS (
    SELECT
        user_id,
        SUM(revenue) AS total_revenue
    FROM revenue
    GROUP BY user_id
)

SELECT
    ua.network,
	ua.campaign_type,
    ua.country,
    CAST(ua.event_time AS DATE) AS install_date,
    COUNT(DISTINCT ua.user_id) AS total_users_acquired,
    SUM(ua.ua_cost) AS total_cost,
    SUM(COALESCE(r.total_revenue, 0)) AS total_revenue,
    COUNT(DISTINCT CASE WHEN r.total_revenue > 0 THEN ua.user_id END) AS paying_users
FROM ua_cost ua
LEFT JOIN revenue_agg r
    ON ua.user_id = r.user_id
GROUP BY
    ua.network,
	ua.campaign_type,
    ua.country,
    CAST(ua.event_time AS DATE)
ORDER BY
    install_date, ua.network, ua.country;


-- Total cost by country and network
Create procedure total_cost @Country varchar(50), @network varchar(50) as
Begin
	select 
		sum(ua_cost) as total_cost
	from ua_cost
	where country = @country and network=@network
end;



--daily cost from specific country

Create view daily_cost as 
	select
		sum(ua_cost)
	from ua_cost
	where country ='FR' and event_time = GETDATE();


