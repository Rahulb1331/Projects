/*find the amount of jobs reviewed over time, for which I have to calculate the number of jobs reviewed per hour per day */
SELECT DATE_FORMAT(ds, '%Y-%m-%d %H:00:00') AS date_hour,
       COUNT(job_id) AS num_jobs_reviewed
FROM Project1
WHERE ds LIKE '2020-11-%'
GROUP BY DATE_FORMAT(ds, '%Y-%m-%d %H:00:00');

/*7 day rolling average of throughput, which can be defined as the number of events happening per second*/
SELECT ds, 
  AVG(count(*) / 86400.0) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as throughput_avg 
FROM job_data 
GROUP BY ds 
ORDER BY ds ASC;

/*Percentage share of each language*/
SELECT language, 
  COUNT(*) / total_jobs * 100 AS percentage_share 
  FROM job_data 
CROSS JOIN 
  (SELECT COUNT(*) AS total_jobs FROM job_data WHERE ds >= '2020-11-01' AND ds < '2020-12-01') t 
WHERE 
  ds >= '2020-11-01' AND ds < '2020-12-01' 
GROUP BY 
  language 
ORDER BY 
  percentage_share DESC; 

/*Repeating Language*/
SELECT language, COUNT(*) as count 
  FROM job_data
  GROUP BY language
  HAVING COUNT(*)>1
  ORDER BY count DESC;
