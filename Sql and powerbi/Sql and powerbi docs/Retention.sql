WITH calendar AS (
    SELECT 0 AS day_number
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
    UNION ALL SELECT 11
    UNION ALL SELECT 12
    UNION ALL SELECT 13
    UNION ALL SELECT 14
    UNION ALL SELECT 15
    UNION ALL SELECT 16
    UNION ALL SELECT 17
    UNION ALL SELECT 18
    UNION ALL SELECT 19
    UNION ALL SELECT 20
    UNION ALL SELECT 21
    UNION ALL SELECT 22
    UNION ALL SELECT 23
    UNION ALL SELECT 24
    UNION ALL SELECT 25
    UNION ALL SELECT 26
    UNION ALL SELECT 27
    UNION ALL SELECT 28
    UNION ALL SELECT 29
    UNION ALL SELECT 30
),
cohort AS (
    SELECT user_id, event_time AS install_date, country, network
    FROM install
),
sessions AS (
    SELECT user_id, CAST(event_time AS DATE) AS session_date
    FROM session
),
cohort_base AS (
    SELECT DISTINCT user_id, install_date, country, network
    FROM cohort
),
cohort_days AS (
    SELECT 
        cb.user_id,
        cb.install_date,
        cb.country,
        cb.network,
        cal.day_number,
        DATEADD(DAY, cal.day_number, cb.install_date) AS session_date
    FROM cohort_base cb
    CROSS JOIN calendar cal
),
user_retention_flags AS (
    SELECT DISTINCT user_id, CAST(event_time AS DATE) AS session_date
    FROM session
),
retention_joined AS (
    SELECT 
        cd.install_date,
        cd.country,
        cd.network,
        cd.day_number,
        COUNT(DISTINCT urf.user_id) AS retained_users
    FROM cohort_days cd
    LEFT JOIN user_retention_flags urf
      ON cd.user_id = urf.user_id
     AND cd.session_date = urf.session_date
    GROUP BY cd.install_date, cd.country, cd.network, cd.day_number
),
cohort_sizes AS (
    SELECT install_date, country, network, COUNT(DISTINCT user_id) AS total_users
    FROM cohort
    GROUP BY install_date, country, network
)
SELECT 
    rj.install_date,
    rj.country,
    rj.network,
    rj.day_number,
    rj.retained_users,
    cs.total_users,
    CAST(rj.retained_users AS FLOAT) / cs.total_users AS retention_rate
FROM retention_joined rj
JOIN cohort_sizes cs
  ON rj.install_date = cs.install_date
 AND rj.country = cs.country
 AND rj.network = cs.network
ORDER BY rj.install_date, rj.country, rj.network, rj.day_number;







