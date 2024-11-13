--------------------------------------------
-- 7 billing_account_id
--------------------------------------------

SELECT calls_ivr_id
      ,step_billing_account_id
FROM keepcoding.ivr_detail
QUALIFY ROW_NUMBER() OVER( PARTITION BY calls_ivr_id ORDER BY 
            CASE  WHEN step_billing_account_id != 'UNKNOWN' THEN 1
                  ELSE 2 END, calls_start_date) = 1;