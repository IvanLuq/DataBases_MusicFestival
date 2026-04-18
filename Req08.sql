USE G61_challange2_music_festival;

DELIMITER //
DROP PROCEDURE IF EXISTS req08_extend_conversion_table//
CREATE PROCEDURE req08_extend_conversion_table()
BEGIN
  
    DECLARE v_last_date DATE;
    DECLARE v_insert_date DATE;  
    DECLARE v_end_date DATE;  
    DECLARE v_start_window DATE;  
    DECLARE v_last_value DECIMAL(12,6);
    DECLARE v_new_value DECIMAL(12,6);
    DECLARE v_col_name VARCHAR(64);
    DECLARE done INT DEFAULT 0;

    DECLARE cur_cols CURSOR FOR
        SELECT column_name
        FROM information_schema.COLUMNS
        WHERE table_schema = DATABASE()
          AND table_name   = 'eurofxref_hist'
          AND column_name <> 'date'
        ORDER BY ordinal_position;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT MAX(date) INTO v_last_date
    FROM eurofxref_hist;

    SET v_end_date    = DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY);
    SET v_insert_date = DATE_ADD(v_last_date,   INTERVAL 1 DAY);

    IF v_insert_date <= v_end_date THEN
        WHILE v_insert_date <= v_end_date DO
            SET v_start_window = DATE_SUB(v_insert_date, INTERVAL 30 DAY);
            SET @sql_insert_head   = 'INSERT INTO eurofxref_hist(`date`';
            SET @sql_insert_values = CONCAT('VALUES (''', v_insert_date, '''');

            OPEN cur_cols;
            SET done = 0;

            read_cols: LOOP
                FETCH cur_cols INTO v_col_name;
                IF done = 1 THEN
                    LEAVE read_cols;
                END IF;

                SET @sql_insert_head =
                    CONCAT(@sql_insert_head, ', `', v_col_name, '`');

                SET @sql_last = CONCAT(
                    'SELECT `', v_col_name, '` INTO @last_value',
                    ' FROM eurofxref_hist',
                    ' WHERE date < ?',
                    ' ORDER BY date DESC LIMIT 1'
                );
                PREPARE stmt_last FROM @sql_last;
                SET @p_date = v_insert_date;
                EXECUTE stmt_last USING @p_date;
                DEALLOCATE PREPARE stmt_last;

                SET v_last_value = @last_value;

                IF v_last_value IS NULL OR v_last_value = 0 THEN
                    SET v_new_value = 0;
                ELSE
                    SET @sql_rand = CONCAT(
                        'SELECT `', v_col_name, '` INTO @rand_value',
                        ' FROM eurofxref_hist',
                        ' WHERE date >= ? AND date < ?',
                        '   AND `', v_col_name, '` > 0',
                        ' ORDER BY RAND() LIMIT 1'
                    );
                    PREPARE stmt_rand FROM @sql_rand;
                    SET @p_start = v_start_window;
                    SET @p_end   = v_insert_date;
                    EXECUTE stmt_rand USING @p_start, @p_end;
                    DEALLOCATE PREPARE stmt_rand;

                    SET v_new_value = @rand_value;
                    IF v_new_value IS NULL THEN
                        SET v_new_value = v_last_value;
                    END IF;
                END IF;

                IF v_new_value IS NULL THEN
                    SET @val_str = 'NULL';
                ELSE
                    SET @val_str = CAST(v_new_value AS CHAR);
                END IF;

                SET @sql_insert_values =
                    CONCAT(@sql_insert_values, ', ', @val_str);

            END LOOP read_cols;

            CLOSE cur_cols;

            SET @sql_full =
                CONCAT(@sql_insert_head, ') ', @sql_insert_values, ');');

            PREPARE stmt_ins FROM @sql_full;
            EXECUTE stmt_ins;
            DEALLOCATE PREPARE stmt_ins;

            SET v_insert_date = DATE_ADD(v_insert_date, INTERVAL 1 DAY);
        END WHILE;

    END IF;
END//

-- CALL req08_extend_conversion_table()


DROP EVENT IF EXISTS req08_extend_conversion_table_daily//
CREATE EVENT req08_extend_conversion_table_daily
ON SCHEDULE
    EVERY 1 DAY
    STARTS (
        TIMESTAMP(DATE_FORMAT(CURRENT_DATE, '%Y-%m-%d 22:00:00'))
        + INTERVAL 2 MINUTE
    )
    ENDS (
        TIMESTAMP(CONCAT(YEAR(CURRENT_DATE), '-12-31 23:59:59'))
    )
DO
    CALL req08_extend_conversion_table()//  
DELIMITER ;

