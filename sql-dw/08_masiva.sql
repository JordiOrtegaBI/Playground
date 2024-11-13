<<<<<<< HEAD
--------------------------------------------
-- 8 masiva_lg
--------------------------------------------

SELECT calls_ivr_id
      ,MAX(CASE WHEN module_name='AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
FROM keepcoding.ivr_detail
=======
--------------------------------------------
-- 8 masiva_lg
--------------------------------------------

SELECT calls_ivr_id
      ,MAX(CASE WHEN module_name='AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
FROM keepcoding.ivr_detail
>>>>>>> 036ddaab8269a07ca23be39ae5811b52db80f250
GROUP BY 1;