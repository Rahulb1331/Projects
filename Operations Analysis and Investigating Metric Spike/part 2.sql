/*part1*/
SELECT
  user_id,
  COUNT(DISTINCT DATE(occurred_at) - INTERVAL WEEKDAY(occurred_at) DAY) AS weekly_engagement_count
FROM
  events
GROUP BY
  user_id;

/*Part2*/
SELECT
  DATE(created_at - INTERVAL WEEKDAY(created_at) DAY) AS week_start_date,
  COUNT(DISTINCT user_id) AS user_growth
FROM
  users
WHERE
  created_at < '2023-03-30' -- Replace with the desired end date (exclusive)
GROUP BY
  week_start_date
ORDER BY
  week_start_date;

/*Part3*/
SELECT
  DATE(u.created_at - INTERVAL WEEKDAY(u.created_at) DAY) AS week_start_date,
  COUNT(DISTINCT r.user_id) AS weekly_retention
FROM
  users u
JOIN
  users r ON u.user_id = r.user_id
          AND DATE(r.created_at - INTERVAL WEEKDAY(r.created_at) DAY) = DATE(u.created_at - INTERVAL WEEKDAY(u.created_at) DAY)
          AND r.activated_at IS NOT NULL -- Considering only activated users
WHERE
  u.created_at < '2023-03-30' -- Replace with the desired end date (exclusive)
GROUP BY
  week_start_date
ORDER BY
  week_start_date;

/*Part4*/
SELECT
  DATE(occurred_at - INTERVAL WEEKDAY(occurred_at) DAY) AS week_start_date,
  device,
  COUNT(*) AS weekly_engagement
FROM
  events
WHERE
  occurred_at < '2023-03-30' -- Replace with the desired end date (exclusive)
GROUP BY
  week_start_date,
  device
ORDER BY
  week_start_date,
  device;

/*Part 5*/
SELECT COUNT(*) AS total_emails_sent
FROM email_events
WHERE action = 'sent_weekly_digest'
  AND occurred_at < '2023-03-30'; -- Replace with the desired end date (exclusive)

SELECT COUNT(*) AS total_email_opens
FROM email_events
WHERE action = 'email_open'
  AND occurred_at < '2023-03-30'; -- Replace with the desired end date (exclusive)

SELECT COUNT(*) AS total_email_opens
FROM email_events
WHERE action = 'email_clickthrough'
  AND occurred_at < '2023-03-30'; -- Replace with the desired end date (exclusive)

/*Part 6*/
SELECT DISTINCT(action) FROM email_events;

SELECT action, COUNT(*) AS action_count
FROM email_events
WHERE occurred_at < '2023-03-30' -- Replace with the desired end date (exclusive)
GROUP BY action;

SELECT * FROM events;
