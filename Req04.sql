USE G61_challange2_music_festival;
DELIMITER //
DROP PROCEDURE IF EXISTS req04_update_type_of_music //

CREATE PROCEDURE req04_update_type_of_music()
BEGIN
   DECLARE v_name VARCHAR(255);
   DECLARE v_country VARCHAR(255);
   DECLARE done INT DEFAULT 0;
   DECLARE cur CURSOR FOR
		SELECT b.name, b.country
		FROM band b
		LEFT JOIN song s
			ON b.type_of_music = s.type_of_music
		GROUP BY b.name, b.country, b.type_of_music
		HAVING COUNT(s.title) = 0;
  
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
   OPEN cur;
  
   read_loop: LOOP
       FETCH cur INTO v_name, v_country;
       IF done = 1 THEN
           LEAVE read_loop;
       END IF;
       UPDATE band
       SET type_of_music  = (
       	SELECT s.type_of_music FROM song s
			WHERE s.written_by = v_name
			GROUP BY s.type_of_music
			ORDER BY COUNT(*) DESC, RAND()
			LIMIT 1
   	)
       WHERE name = v_name AND country = v_country;
       END LOOP;
       CLOSE cur;
	
END //
DELIMITER ;

CALL req04_update_type_of_music();