--------------------------------------------
-- 5 document_type y document_identification
--------------------------------------------

-- se prioriza disponer de la información completa, si más de un registro con distinto document_type se prioriza document_type ASC
SELECT calls_ivr_id
      ,step_document_type
      ,step_document_identification
FROM keepcoding.ivr_detail
QUALIFY ROW_NUMBER() OVER( PARTITION BY calls_ivr_id ORDER BY 
            CASE  WHEN step_document_type != 'UNKNOWN' AND step_document_identification != 'UNKNOWN' THEN 1
                  WHEN step_document_type != 'UNKNOWN' THEN 2
                  WHEN step_document_identification != 'UNKNOWN' THEN 3
                  ELSE 4 END, step_document_type) = 1;