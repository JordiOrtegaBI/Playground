<<<<<<< HEAD
--------------------------------------------
-- 4 vdn_aggregation
--------------------------------------------

SELECT calls_ivr_id
,CASE WHEN STARTS_WITH(calls_vdn_label,'ATC') THEN 'FRONT' 
            WHEN STARTS_WITH(calls_vdn_label,'TECH') THEN 'TECH'
            WHEN calls_vdn_label='ABSORPTION' THEN 'ABSORPTION'
            ELSE 'RESTO' END AS vdn_aggregation
FROM keepcoding.ivr_detail
=======
--------------------------------------------
-- 4 vdn_aggregation
--------------------------------------------

SELECT calls_ivr_id
,CASE WHEN STARTS_WITH(calls_vdn_label,'ATC') THEN 'FRONT' 
            WHEN STARTS_WITH(calls_vdn_label,'TECH') THEN 'TECH'
            WHEN calls_vdn_label='ABSORPTION' THEN 'ABSORPTION'
            ELSE 'RESTO' END AS vdn_aggregation
FROM keepcoding.ivr_detail
>>>>>>> 036ddaab8269a07ca23be39ae5811b52db80f250
GROUP BY 1,2;