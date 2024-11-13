<<<<<<< HEAD
--------------------------------------------
-- 13 clean_integer
--------------------------------------------

CREATE OR REPLACE FUNCTION keepcoding.fnc_clean_integer(p_integer INT64) RETURNS INT64 AS
(( SELECT CASE WHEN p_integer IS NULL THEN -999999 ELSE p_integer END ));

-- TEST: SELECT keepcoding.fnc_clean_integer(NULL)
=======
--------------------------------------------
-- 13 clean_integer
--------------------------------------------

CREATE OR REPLACE FUNCTION keepcoding.fnc_clean_integer(p_integer INT64) RETURNS INT64 AS
(( SELECT CASE WHEN p_integer IS NULL THEN -999999 ELSE p_integer END ));

-- TEST: SELECT keepcoding.fnc_clean_integer(NULL)
>>>>>>> 036ddaab8269a07ca23be39ae5811b52db80f250
