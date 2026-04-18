DELIMITER //
DROP EVENT IF EXISTS req02_update_staff_experience_monthly //

CREATE EVENT req02_update_staff_experience_monthly
ON SCHEDULE
		EVERY 1 MONTH
		STARTS (TIMESTAMP(DATE_FORMAT(CURRENT_DATE, '%Y-%m-01 08:00:00')))
DO
   		CALL req01_update_staff_experience();
//
DELIMITER ;