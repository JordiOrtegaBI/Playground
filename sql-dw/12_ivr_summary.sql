--------------------------------------------
-- 12 ivr_summary
--------------------------------------------

CREATE OR REPLACE TABLE keepcoding.ivr_summary AS (
WITH document AS (
SELECT calls_ivr_id
      ,step_document_type
      ,step_document_identification
FROM keepcoding.ivr_detail
QUALIFY ROW_NUMBER() OVER( PARTITION BY calls_ivr_id ORDER BY 
            CASE  WHEN step_document_type != 'UNKNOWN' AND step_document_identification != 'UNKNOWN' THEN 1
                  WHEN step_document_type != 'UNKNOWN' THEN 2
                  WHEN step_document_identification != 'UNKNOWN' THEN 3
                  ELSE 4 END, step_document_type) = 1
)
, phone_number AS(
      SELECT calls_ivr_id
      ,CASE WHEN calls_phone_number != 'UNKNOWN' THEN calls_phone_number ELSE step_customer_phone END AS customer_phone
FROM keepcoding.ivr_detail
QUALIFY ROW_NUMBER() OVER( PARTITION BY calls_ivr_id ORDER BY 
            CASE  WHEN customer_phone != 'UNKNOWN' THEN 1
                  ELSE 2 END, calls_start_date) = 1
)
, billingaccount AS(
SELECT calls_ivr_id
      ,step_billing_account_id
FROM keepcoding.ivr_detail
QUALIFY ROW_NUMBER() OVER( PARTITION BY calls_ivr_id ORDER BY 
            CASE  WHEN step_billing_account_id != 'UNKNOWN' THEN 1
                  ELSE 2 END, calls_start_date) = 1
)

, next_previous_call AS (
      SELECT CAST(ivr_calls.ivr_id AS STRING) AS calls_ivr_id
            ,IFNULL(phone_number, 'UNKNOWN') AS calls_phone_number
            ,IFNULL(start_date, '9999-12-31') AS calls_start_date
            ,LEAD(IFNULL(start_date, '9999-12-31')) OVER(PARTITION BY IFNULL(phone_number, 'UNKNOWN') ORDER BY IFNULL(start_date, '9999-12-31')) next_call_start_date
            ,LAG(IFNULL(start_date, '9999-12-31')) OVER(PARTITION BY IFNULL(phone_number, 'UNKNOWN') ORDER BY IFNULL(start_date, '9999-12-31')) previous_call_start_date
      FROM keepcoding.ivr_calls
      WHERE IFNULL(phone_number, 'UNKNOWN')!='UNKNOWN'
      ORDER BY calls_phone_number, calls_start_date
)

SELECT ivr_detail.calls_ivr_id AS ivr_id
      ,ivr_detail.calls_phone_number AS phone_number
      ,ivr_detail.calls_ivr_result AS ivr_result
      ,CASE WHEN STARTS_WITH(ivr_detail.calls_vdn_label,'ATC') THEN 'FRONT' 
            WHEN STARTS_WITH(ivr_detail.calls_vdn_label,'TECH') THEN 'TECH'
            WHEN ivr_detail.calls_vdn_label='ABSORPTION' THEN 'ABSORPTION'
            ELSE 'RESTO' END AS vdn_aggregation
      ,ivr_detail.calls_start_date AS start_date
      ,ivr_detail.calls_end_date AS end_date
      ,ivr_detail.calls_total_duration AS total_duration
      ,ivr_detail.calls_customer_segment AS customer_segment
      ,ivr_detail.calls_ivr_language AS ivr_language
      ,ivr_detail.calls_steps_module AS steps_module
      ,ivr_detail.calls_module_aggregation AS module_aggregation
      ,document.step_document_type AS document_type
      ,document.step_document_identification AS document_identification
      ,phone_number.customer_phone AS customer_phone
      ,billingaccount.step_billing_account_id AS billing_account_id
      ,MAX(CASE WHEN ivr_detail.module_name='AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
      ,MAX(CASE WHEN ivr_detail.step_name='CUSTOMERINFOBYPHONE.TX' AND ivr_detail.step_result='OK' THEN 1 ELSE 0 END) AS info_by_phone_lg
      ,MAX(CASE WHEN ivr_detail.step_name='CUSTOMERINFOBYDNI.TX' AND ivr_detail.step_result='OK' THEN 1 ELSE 0 END) AS info_by_dni_lg
      ,CASE WHEN DATE_DIFF(next_previous_call.calls_start_date,previous_call_start_date,DAY) <= 1 THEN 1 ELSE 0 END AS repeated_phone_24h
      ,CASE WHEN DATE_DIFF(next_call_start_date,next_previous_call.calls_start_date,DAY) <= 1 THEN 1 ELSE 0 END AS cause_recall_phone_24h
FROM keepcoding.ivr_detail
LEFT JOIN document
ON ivr_detail.calls_ivr_id = document.calls_ivr_id
LEFT JOIN phone_number
ON ivr_detail.calls_ivr_id = phone_number.calls_ivr_id
LEFT JOIN billingaccount
ON ivr_detail.calls_ivr_id=billingaccount.calls_ivr_id
LEFT JOIN next_previous_call
ON ivr_detail.calls_ivr_id=next_previous_call.calls_ivr_id
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,19,20
);