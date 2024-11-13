<<<<<<< HEAD
--------------------------------------------
-- 10 info_by_dni_lg
--------------------------------------------

SELECT calls_ivr_id
      ,MAX(CASE WHEN step_name='CUSTOMERINFOBYDNI.TX' AND step_result='OK' THEN 1 ELSE 0 END) AS info_by_dni_lg
FROM keepcoding.ivr_detail
GROUP BY 1;
=======
--------------------------------------------
-- 10 info_by_dni_lg
--------------------------------------------

SELECT calls_ivr_id
      ,MAX(CASE WHEN step_name='CUSTOMERINFOBYDNI.TX' AND step_result='OK' THEN 1 ELSE 0 END) AS info_by_dni_lg
FROM keepcoding.ivr_detail
GROUP BY 1;
>>>>>>> 036ddaab8269a07ca23be39ae5811b52db80f250
