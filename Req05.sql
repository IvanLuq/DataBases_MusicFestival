USE G61_challange2_music_festival;
DELIMITER //
DROP FUNCTION IF EXISTS req05_rounded_decimal;
CREATE FUNCTION req05_rounded_decimal(x FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
	-- our approach here was to declare a variable
	-- that its purpose was to check if the input variable
	-- had 2 decimals or less so to return it without modification
	-- if not then it is rounded
	DECLARE x_times_100 FLOAT;
   	SET x_times_100 = x * 100;
   	IF x_times_100 = ROUND(x_times_100) THEN
       		RETURN x;
   	ELSE
       		RETURN ROUND(x, 2);
   	END IF;
END //
DELIMITER ;

--CALL req05_rounded_decimal(72.89234)