----------- ################ View Table of User Engagement ################## ----------- 
CREATE VIEW user_engagement_view_tbl AS
	SELECT
		user_id,
		event_date AS session_date,
		COUNT(session_id) AS session_count,
		SUM(time_spent) AS total_time_spent_min
	FROM session
	GROUP BY 
		user_id, event_date;

SELECT * FROM user_engagement_view_tbl




CREATE VIEW user_weekly_engagement_view AS
SELECT
    s.user_id,
    DATEPART(YEAR, s.event_date) AS year,
    DATEPART(WEEK, s.event_date) AS week_number,
    i.country,
    i.platform,
    i.network,
    COUNT(*) AS session_count,
    (
        SELECT COUNT(*) 
        FROM player_action pa 
        WHERE pa.user_id = s.user_id
          AND DATEPART(YEAR, pa.event_time) = DATEPART(YEAR, s.event_date)
          AND DATEPART(WEEK, pa.event_time) = DATEPART(WEEK, s.event_date)
          AND pa.action_type = 'booster'
    ) AS booster_usage
FROM session s
JOIN install i ON s.user_id = i.user_id
GROUP BY 
    s.user_id,
    DATEPART(YEAR, s.event_date),
    DATEPART(WEEK, s.event_date),
    i.country, i.platform, i.network;


Select * from user_weekly_engagement_view


----------- ########### Calculate the Daily Active User ########################-----------
SELECT	
	event_date,
	COUNT(DISTINCT user_id) AS DAU
FROM session
GROUP BY event_date
ORDER BY event_date

----------- ############### country, network, platform bazýnda ayýr ############### ----------- 

SELECT
    s.event_date,
    i.country,
    i.network,
    i.platform,
    COUNT(DISTINCT s.user_id) AS dau
FROM session s
JOIN install i ON s.user_id = i.user_id
GROUP BY 
    s.event_date,
    i.country,
    i.network,
    i.platform
ORDER BY 
    s.event_date, i.country, i.network, i.platform;

-- ########## 1 user günlük ve haftalýk ortalama kaç session yapýyor gibi bir çýktýyý hesaplamalýyýz ######### -------


-- Günlük session ortalamasý
WITH daily_sessions AS (
    SELECT user_id, event_date, COUNT(*) AS sessions_per_day
    FROM session
    GROUP BY user_id, event_date
),
-- Haftalýk session ortalamasý
weekly_sessions AS (
    SELECT user_id, DATEPART(WEEK, event_date) AS week_number, COUNT(*) AS sessions_per_week
    FROM session
    GROUP BY user_id, DATEPART(WEEK, event_date)
),
-- Günlük booster ortalamasý
daily_boosters AS (
    SELECT user_id, CAST(event_time AS DATE) AS action_date, COUNT(*) AS booster_count
    FROM player_action
    WHERE action_type = 'booster'
    GROUP BY user_id, CAST(event_time AS DATE)
),
-- Haftalýk booster ortalamasý
weekly_boosters AS (
    SELECT user_id, DATEPART(WEEK, event_time) AS week_number, COUNT(*) AS booster_count
    FROM player_action
    WHERE action_type = 'booster'
    GROUP BY user_id, DATEPART(WEEK, event_time)
)

SELECT 
    -- Sessionlar
    (SELECT AVG(CAST(sessions_per_day AS FLOAT)) FROM daily_sessions) AS avg_daily_sessions_per_user,
    (SELECT AVG(CAST(sessions_per_week AS FLOAT)) FROM weekly_sessions) AS avg_weekly_sessions_per_user,

    -- Boosterlar
    (SELECT AVG(CAST(booster_count AS FLOAT)) FROM daily_boosters) AS avg_daily_boosters_per_user,
    (SELECT AVG(CAST(booster_count AS FLOAT)) FROM weekly_boosters) AS avg_weekly_boosters_per_user;




----------- ###################### Churn Rate ##################### -----------

----------- day1, day7, day15'in retetion_rate'ini hesapla sonrasýnda da churn_rate hesapla, churn_rate = 1- retention_rate
WITH installs AS (
    SELECT user_id, CAST(event_time AS DATE) AS install_date
    FROM install
),
sessions AS (
    SELECT user_id, CAST(event_time AS DATE) AS session_date
    FROM session
),
cohort_sessions AS (
    SELECT 
        i.user_id,
        i.install_date,
        s.session_date,
        DATEDIFF(DAY, i.install_date, s.session_date) AS day_offset
    FROM installs i
    JOIN sessions s ON i.user_id = s.user_id
),
day_check AS (
    SELECT install_date,
        COUNT(DISTINCT CASE WHEN day_offset = 1 THEN user_id END) AS retained_day1,
        COUNT(DISTINCT CASE WHEN day_offset = 7 THEN user_id END) AS retained_day7,
        COUNT(DISTINCT CASE WHEN day_offset = 15 THEN user_id END) AS retained_day15
    FROM cohort_sessions
    GROUP BY install_date
),
install_counts AS (
    SELECT install_date, COUNT(DISTINCT user_id) AS total_installs
    FROM installs
    GROUP BY install_date
)

SELECT 
    ic.install_date,
    ic.total_installs,
    dc.retained_day1,
    dc.retained_day7,
    dc.retained_day15,
    
    CAST(dc.retained_day1 AS FLOAT) / ic.total_installs AS retention_day1,
    CAST(dc.retained_day7 AS FLOAT) / ic.total_installs AS retention_day7,
    CAST(dc.retained_day15 AS FLOAT) / ic.total_installs AS retention_day15,

    1 - CAST(dc.retained_day1 AS FLOAT) / ic.total_installs AS churn_day1,
    1 - CAST(dc.retained_day7 AS FLOAT) / ic.total_installs AS churn_day7,
    1 - CAST(dc.retained_day15 AS FLOAT) / ic.total_installs AS churn_day15
FROM install_counts ic
LEFT JOIN day_check dc ON ic.install_date = dc.install_date
ORDER BY ic.install_date;

----- Procedure Table ------------------

CREATE PROCEDURE get_user_weekly_engagement
    @year INT,
    @week_number INT
AS
BEGIN
    SELECT
        s.user_id,
        DATEPART(YEAR, s.event_date) AS year,
        DATEPART(WEEK, s.event_date) AS week_number,
        i.country,
        i.platform,
        i.network,
        COUNT(*) AS session_count,
        (
            SELECT COUNT(*) 
            FROM player_action pa 
            WHERE pa.user_id = s.user_id
              AND DATEPART(YEAR, pa.event_time) = @year
              AND DATEPART(WEEK, pa.event_time) = @week_number
              AND pa.action_type = 'booster'
        ) AS booster_usage
    FROM session s
    JOIN install i ON s.user_id = i.user_id
    WHERE 
        DATEPART(YEAR, s.event_date) = @year
        AND DATEPART(WEEK, s.event_date) = @week_number
    GROUP BY 
        s.user_id,
        DATEPART(YEAR, s.event_date),
        DATEPART(WEEK, s.event_date),
        i.country, i.platform, i.network;
END;

EXEC get_user_weekly_engagement @year = 2025, @week_number = 14;
