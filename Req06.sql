USE G61_challange2_music_festival;
DELIMITER //
DROP FUNCTION IF EXISTS req06_existence_curr_code;
CREATE FUNCTION req06_existence_curr_code(x CHAR(3))
RETURNS BOOL
DETERMINISTIC
BEGIN
   	DECLARE upper_code CHAR(3);
   	DECLARE exists_flag BOOL;
   	SET upper_code = UPPER(x);
   	SELECT (upper_code = 'EUR') OR EXISTS (
           		SELECT 1
           		FROM information_schema.COLUMNS
           		WHERE table_schema = DATABASE()
             	AND table_name   = 'eurofxref_hist'
             	AND column_name  = upper_code
       	)
   	INTO exists_flag;
   	IF exists_flag THEN
       		RETURN TRUE;
   	ELSE
       		RETURN FALSE;
END IF;
END //
DELIMITER ;

--CALL req06_existence_curr_code(curr_code CHAR(3))