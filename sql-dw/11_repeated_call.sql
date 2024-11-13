<<<<<<< HEAD
WITH next_previous_call AS (
      SELECT CAST(ivr_calls.ivr_id AS STRING) AS calls_ivr_id
            ,IFNULL(phone_number, 'UNKNOWN') AS calls_phone_number
            ,IFNULL(start_date, '9999-12-31') AS calls_start_date
            ,LEAD(IFNULL(start_date, '9999-12-31')) OVER(PARTITION BY IFNULL(phone_number, 'UNKNOWN') ORDER BY IFNULL(start_date, '9999-12-31')) next_call_start_date
            ,LAG(IFNULL(start_date, '9999-12-31')) OVER(PARTITION BY IFNULL(phone_number, 'UNKNOWN') ORDER BY IFNULL(start_date, '9999-12-31')) previous_call_start_date
      FROM keepcoding.ivr_calls
      WHERE IFNULL(phone_number, 'UNKNOWN')!='UNKNOWN'
      ORDER BY calls_phone_number, calls_start_date
)

SELECT calls_ivr_id
      ,calls_phone_number
      ,CASE WHEN DATE_DIFF(next_call_start_date,calls_start_date,DAY) <= 1 THEN 1 ELSE 0 END AS cause_recall_phone_24h
      ,CASE WHEN DATE_DIFF(calls_start_date,previous_call_start_date,DAY) <= 1 THEN 1 ELSE 0 END AS repeated_phone_24h
FROM next_previous_call
=======
WITH next_previous_call AS (
      SELECT CAST(ivr_calls.ivr_id AS STRING) AS calls_ivr_id
            ,IFNULL(phone_number, 'UNKNOWN') AS calls_phone_number
            ,IFNULL(start_date, '9999-12-31') AS calls_start_date
            ,LEAD(IFNULL(start_date, '9999-12-31')) OVER(PARTITION BY IFNULL(phone_number, 'UNKNOWN') ORDER BY IFNULL(start_date, '9999-12-31')) next_call_start_date
            ,LAG(IFNULL(start_date, '9999-12-31')) OVER(PARTITION BY IFNULL(phone_number, 'UNKNOWN') ORDER BY IFNULL(start_date, '9999-12-31')) previous_call_start_date
      FROM keepcoding.ivr_calls
      WHERE IFNULL(phone_number, 'UNKNOWN')!='UNKNOWN'
      ORDER BY calls_phone_number, calls_start_date
)

SELECT calls_ivr_id
      ,calls_phone_number
      ,CASE WHEN DATE_DIFF(next_call_start_date,calls_start_date,DAY) <= 1 THEN 1 ELSE 0 END AS cause_recall_phone_24h
      ,CASE WHEN DATE_DIFF(calls_start_date,previous_call_start_date,DAY) <= 1 THEN 1 ELSE 0 END AS repeated_phone_24h
FROM next_previous_call
>>>>>>> 036ddaab8269a07ca23be39ae5811b52db80f250
ORDER BY calls_phone_number,calls_start_date;