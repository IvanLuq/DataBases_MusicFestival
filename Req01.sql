USE G61_challange2_music_festival;
DELIMITER //
DROP PROCEDURE IF EXISTS req01_update_staff_experience //

CREATE PROCEDURE req01_update_staff_experience()
BEGIN
   UPDATE staff
   SET years_experience = TIMESTAMPDIFF(YEAR, hire_date, CURRENT_DATE())
   WHERE years_experience IS NULL
      OR years_experience <> TIMESTAMPDIFF(YEAR, hire_date, CURRENT_DATE());
END //
DELIMITER ;

--CALL req01_update_staff_experience();