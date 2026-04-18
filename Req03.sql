DELIMITER //
DROP TRIGGER IF EXISTS req03_auto_assign_bartender;
CREATE TRIGGER req03_auto_assign_bartender
BEFORE INSERT ON bartender
FOR EACH ROW
BEGIN
   DECLARE chosen_bar INT;
   -- Only act if the new bartender has no bar assigned (FK is NULL)
   IF NEW.id_bar IS NULL THEN
       -- Find bar with minimum number of bartenders
       SELECT b.id_bar
       INTO chosen_bar
       FROM bar AS b
       LEFT JOIN bartender AS bt
         ON bt.id_bar = b.id_bar
       GROUP BY b.id_bar
       ORDER BY COUNT(bt.id_bartender) ASC, b.id_bar ASC
       LIMIT 1;
       -- assign bar to the new row
       SET NEW.id_bar = chosen_bar;
   END IF;
END //
DELIMITER ;