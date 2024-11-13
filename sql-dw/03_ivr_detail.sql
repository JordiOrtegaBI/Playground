--------------------------------------------
-- 3 creamos la tabla ivr_detail
--------------------------------------------

-- Comprobamos si hay ivr_id que, por algún error, no esten reflejados en la tabla calls_ivr y si lo están en steps o module
SELECT CAST(ivr_calls.ivr_id AS STRING) AS calls_ivr_id
      ,CAST(ivr_steps.ivr_id AS STRING) AS steps_ivr_id
      ,CAST(ivr_modules.ivr_id AS STRING) AS modules_ivr_id
FROM keepcoding.ivr_calls
FULL JOIN keepcoding.ivr_steps
ON ivr_calls.ivr_id=ivr_steps.ivr_id
FULL JOIN keepcoding.ivr_modules
ON ivr_calls.ivr_id=ivr_modules.ivr_id
WHERE ivr_calls.ivr_id IS NULL OR
      ivr_steps.ivr_id IS NULL OR
      ivr_modules.ivr_id IS NULL;

-- Centrándonos en la tabla ivr_calls validamos sus valores:
-- Comprobamos que no tiene duplicados en su primary key
SELECT ivr_id
      ,COUNT(1) reg
FROM keepcoding.ivr_calls
GROUP BY 1
ORDER BY 2 DESC;

-- buscamos valores érroneos tipo NULL o valores que contengan una letra (ejemplo 'DS' o 'DESCONOCIDO')
SELECT COUNT(IF(ivr_id IS NULL, 1, NULL)) AS count_nulls
      ,REGEXP_CONTAINS(CAST(ivr_id AS STRING), r'[A-Za-z]') AS contiene_letra
FROM keepcoding.ivr_calls
GROUP BY 2;

-- Revisamos valores de la variable phone_number. Para la revisión del resto de variables se aplican queries similares
SELECT COUNT(IF(phone_number IS NULL, 1, NULL)) AS count_nulls
      ,REGEXP_CONTAINS(CAST(phone_number AS STRING), r'[A-Za-z]') AS contiene_letra
      ,length(phone_number)
FROM keepcoding.ivr_calls
GROUP BY 2,3;

-- Creamos ivr_detail.
CREATE OR REPLACE TABLE keepcoding.ivr_detail AS (
      SELECT CAST(ivr_calls.ivr_id AS STRING) AS calls_ivr_id
            ,IFNULL(phone_number, 'UNKNOWN') AS calls_phone_number
            ,IFNULL(ivr_result, 'UNKNOWN') AS calls_ivr_result
            ,IFNULL(vdn_label, 'UNKNOWN') AS calls_vdn_label
            ,IFNULL(start_date, '9999-12-31') AS calls_start_date
            ,FORMAT_DATE('%Y%m%d',start_date) AS calls_start_date_id
            ,IFNULL(end_date, '9999-12-31') AS calls_end_date
            ,FORMAT_DATE('%Y%m%d',end_date) AS calls_end_date_id
            ,IFNULL(total_duration, -999999999) AS calls_total_duration
            ,IFNULL(customer_segment, 'UNKNOWN') AS calls_customer_segment
            ,IFNULL(ivr_language, 'UNKNOWN') AS calls_ivr_language -- se desconoce el significado de STANDARD
            ,IFNULL(steps_module, -999999999) AS calls_steps_module
            ,IFNULL(module_aggregation, 'UNKNOWN') AS calls_module_aggregation
            ,IFNULL(ivr_modules.module_sequece, -999999999) AS module_sequence
            ,IFNULL(module_name, 'UNKNOWN' ) AS module_name
            ,IFNULL(module_duration, -999999999) AS module_duration
            ,IFNULL(module_result, 'UNKNOWN' ) AS module_result
            ,IFNULL(step_sequence, -999999999) AS step_sequence
            ,IFNULL(step_name, 'UNKNOWN') AS step_name
            ,IFNULL(step_result, 'UNKNOWN') AS step_result
            ,IFNULL(step_description_error, 'UNKNOWN') AS step_description_error -- se asume que UNKNOWN ERROR es un resultado óptimo
            ,IFNULL(CASE WHEN document_type='DESCONOCIDO' THEN 'UNKNOWN' ELSE document_type END, 'UNKNOWN') AS step_document_type
            ,IFNULL(document_identification, 'UNKNOWN') AS step_document_identification
            ,IFNULL(customer_phone, 'UNKNOWN') AS step_customer_phone
            ,IFNULL(billing_account_id, 'UNKNOWN') AS step_billing_account_id
      FROM keepcoding.ivr_calls
      LEFT JOIN keepcoding.ivr_modules
      ON ivr_calls.ivr_id = ivr_modules.ivr_id
      LEFT JOIN keepcoding.ivr_steps
      ON ivr_modules.ivr_id = ivr_steps.ivr_id AND ivr_modules.module_sequece = ivr_steps.module_sequece
      ORDER BY ivr_modules.module_sequece, step_sequence);