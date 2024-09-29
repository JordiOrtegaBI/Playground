--------------------------------------------
-- 6 customer_phone
--------------------------------------------

-- usamos calls_start_date por si hipotéticamente hubiera un ivr_id que identifique 2 números distintos en calls_phone_number y/o step_customer_phone y así siempre devolver el mismo
SELECT calls_ivr_id
      ,CASE WHEN calls_phone_number != 'UNKNOWN' THEN calls_phone_number ELSE step_customer_phone END AS customer_phone
FROM keepcoding.ivr_detail
QUALIFY ROW_NUMBER() OVER( PARTITION BY calls_ivr_id ORDER BY 
            CASE  WHEN customer_phone != 'UNKNOWN' THEN 1
                  ELSE 2 END, calls_start_date) = 1;