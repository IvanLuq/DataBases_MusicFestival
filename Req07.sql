USE G61_challange2_music_festival;
DELIMITER //
DROP PROCEDURE IF EXISTS req07_convert_currency //
CREATE PROCEDURE req07_convert_currency(
  IN Origin_Cur VARCHAR(3),
  IN Dest_Cur VARCHAR(3),
  IN Convert_Date DATE,
  INOUT Amount_To_Convert DECIMAL(10,2),
  OUT Error_Msg VARCHAR(100)
)
req07_convert_currency: BEGIN
	
	DECLARE Origin_Conversion FLOAT;
	DECLARE Dest_Conversion FLOAT;
	DECLARE query VARCHAR(250);
	
	SET @Dest_Conversion_Rate = NULL;
  SET @Origin_Conversion_Rate = NULL;
	
	SET Origin_Cur = UPPER(Origin_Cur);
	SET Dest_Cur = UPPER(Dest_Cur);
	SET Error_Msg = NULL;
	
 	IF Amount_To_Convert <= 0 THEN
		SET Error_Msg = "Amount to convert can not be lower than or equal to 0.";
		SET Amount_To_Convert = NULL;
		LEAVE req07_convert_currency;
	END IF;
	
	IF Convert_Date > CURRENT_DATE THEN
		SET Error_Msg = "Conversion date must be today or in the past (not a future date).";
		SET Amount_To_Convert = NULL;	
		LEAVE req07_convert_currency;
	END IF;
	
	IF Origin_Cur = Dest_Cur THEN
		SET Error_Msg = "Currencies involved must be different from each other (no conversion to self).";
     	SET Amount_To_Convert = NULL;
		LEAVE req07_convert_currency;
	END IF;
	
  IF Origin_Cur != 'EUR' AND Dest_Cur != 'EUR' THEN
		SET Error_Msg = "The currency conversion has to always involve EUR (from or to).";
		SET Amount_To_Convert = NULL;
		LEAVE req07_convert_currency;
	END IF;
	
	IF req06_existence_curr_code(Origin_Cur) = FALSE OR req06_existence_curr_code(Dest_Cur) = FALSE THEN
		SET Error_Msg = "One or both of the currency codes involved are not valid (not EUR and not in table).";
		SET Amount_To_Convert = NULL;
		LEAVE req07_convert_currency;
	END IF;
		
	
	IF Origin_Cur = 'EUR' THEN
		SET Origin_Conversion = 1.0; 		
		SET query = CONCAT(
	    'SELECT `', LOWER(Dest_Cur), '`',
	    ' INTO @Dest_Conversion_Rate
	    FROM eurofxref_hist
	    WHERE date = ?'
		);
		
		PREPARE state FROM query;
		EXECUTE state USING Convert_Date;
		DEALLOCATE PREPARE state;
		
		SET Dest_Conversion = @Dest_Conversion_Rate;
		
	ELSE
		SET Dest_Conversion = 1.0;
		
		SET query = CONCAT(
	    'SELECT `', LOWER(Origin_Cur), '`',
	    ' INTO @Origin_Conversion_Rate
	    FROM eurofxref_hist
	    WHERE date = ?'
		);
		
		PREPARE state FROM query;
		EXECUTE state USING Convert_Date;
		DEALLOCATE PREPARE state;
		
		SET Origin_Conversion = @Origin_Conversion_Rate;
	END IF;
	
	IF Origin_Conversion IS NULL OR Origin_Conversion <= 0 OR Dest_Conversion IS NULL OR Dest_Conversion <= 0 THEN
     SET Error_Msg = "Conversion rate does not exist or is non-positive for the given date.";
     SET Amount_To_Convert = NULL;
     LEAVE req07_convert_currency;
 END IF;
	
	
	IF Dest_Cur = 'EUR' THEN
     SET Amount_To_Convert = Amount_To_Convert / Origin_Conversion;
	ELSE
     SET Amount_To_Convert = Amount_To_Convert * Dest_Conversion;
 	END IF;
	
	SET Amount_To_Convert = (SELECT req05_rounded_decimal(Amount_To_Convert));
	
END//
DELIMITER ;

--SET @amount_to_convert = 100;
--SET @error_message = NULL;
--CALL req07_convert_currency('eur', 'usd', '2024-05-10', @amount_to_convert, @error_message);