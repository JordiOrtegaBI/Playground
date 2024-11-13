<<<<<<< HEAD
--------------------------------------------
-- 9 info_by_phone_lg
--------------------------------------------

SELECT calls_ivr_id
      ,MAX(CASE WHEN step_name='CUSTOMERINFOBYPHONE.TX' AND step_result='OK' THEN 1 ELSE 0 END) AS info_by_phone_lg
FROM keepcoding.ivr_detail
=======
--------------------------------------------
-- 9 info_by_phone_lg
--------------------------------------------

SELECT calls_ivr_id
      ,MAX(CASE WHEN step_name='CUSTOMERINFOBYPHONE.TX' AND step_result='OK' THEN 1 ELSE 0 END) AS info_by_phone_lg
FROM keepcoding.ivr_detail
>>>>>>> 036ddaab8269a07ca23be39ae5811b52db80f250
GROUP BY 1;