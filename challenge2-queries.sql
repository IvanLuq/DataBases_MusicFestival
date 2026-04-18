USE G61_challange2_music_festival;

DROP VIEW IF EXISTS query_01;
CREATE VIEW query_01 AS
SELECT CEIL(COUNT(*)/2) AS Required_Squirrels
FROM G61_challange2_music_festival.festivalgoer
WHERE owns_glass = 0;
-- Total: 1 Row


DROP VIEW IF EXISTS query_02;
CREATE VIEW query_02 AS
SELECT p.nationality, COUNT(*) AS num_festivalgoers
FROM festivalgoer fg
JOIN person p ON fg.id_festivalgoer = p.id_person
GROUP BY p.nationality
ORDER BY p.nationality ASC;
-- Total: 243 Rows


DROP VIEW IF EXISTS query_03;
CREATE VIEW query_03 AS
SELECT DISTINCT
     p.*,       
     fsg.*      
FROM festivalgoer AS fsg
JOIN person AS p
   ON p.id_person = fsg.id_festivalgoer
JOIN festivalgoer_consumes AS fc
   ON fc.id_festivalgoer = fsg.id_festivalgoer
JOIN product AS pr
   ON pr.id_product = fc.id_product
JOIN food AS fd
   ON fd.id_food = pr.id_product
WHERE fsg.is_spicy_tolerant = 0  
AND fd.is_spicy = 1 
AND fsg.health_status = 'dizzy'
ORDER BY p.id_person ASC;
-- Total: 8825 Rows


DROP VIEW IF EXISTS query_04;
CREATE VIEW query_04 AS
SELECT P.id_person, P.name, P.surname, P.nationality,P.birth_date
FROM person P
JOIN festivalgoer_show FS
ON P.id_person = FS.id_festivalgoer
LEFT JOIN ticket T
ON FS.id_festivalgoer = T.id_festivalgoer
WHERE T.id_festivalgoer IS NULL
GROUP BY P.id_person
ORDER BY P.id_person;
-- Total: 10423 Rows


DROP VIEW IF EXISTS query_05;
CREATE VIEW query_05 AS
SELECT * FROM band WHERE name IN (SELECT name FROM band GROUP BY name HAVING COUNT(*) > 1);
-- Total: 69 Rows


DROP VIEW IF EXISTS query_06;
CREATE VIEW query_06 AS
SELECT
   p.*,
   st.*
FROM festivalgoer AS fsg
JOIN person AS p
 	ON p.id_person = fsg.id_festivalgoer
JOIN festivalgoer_show AS fs
 	ON fs.id_festivalgoer = fsg.id_festivalgoer
JOIN `show` AS s
 	ON s.id_show = fs.id_show
JOIN stage AS st
 	ON st.id_stage         = s.id_stage
AND st.festival_name    = s.festival_name
AND st.festival_edition = s.festival_edition
WHERE fsg.is_gluten_free  = 1
 	AND fsg.is_alcohol_free = 1
 	AND fsg.health_status   = 'wasted'
ORDER BY p.id_person ASC;
-- Total: 2806 Rows


DROP VIEW IF EXISTS query_07;
CREATE VIEW query_07 AS
SELECT P.id_person, P.name, P.surname, P.nationality,P.birth_date,A.platform_name, A.followers
FROM person P
JOIN cm_account_festival CMA
	ON P.id_person = CMA.id_community_manager
JOIN community_manager CM
	ON CMA.id_community_manager = CM.id_community_manager
JOIN account A
	ON CMA.platform_name = A.platform_name AND CMA.account_name = A.account_name
WHERE CM.is_freelance = 1 AND CMA.festival_name = 'Creamfields' AND A.followers BETWEEN 500000 AND 700000
ORDER BY P.id_person ASC;
-- Total: 6 Rows


DROP VIEW IF EXISTS query_08;
CREATE VIEW query_08 AS
SELECT
   b.id_beerman,
   p.name,
   p.surname,
   p.nationality,
   p.birth_date,
   bs_counts.num_beers,
   bs_counts.num_beers * 0.33 AS total_litres
FROM beerman b
JOIN staff s ON b.id_beerman = s.id_staff
JOIN person p ON p.id_person = s.id_staff
JOIN (
   SELECT id_beerman, COUNT(*) AS num_beers
   FROM beerman_sells
   WHERE festival_name = "Primavera Sound"
   GROUP BY id_beerman
) bs_counts ON b.id_beerman = bs_counts.id_beerman
ORDER BY total_litres DESC;
-- Total: 2000 Rows


DROP VIEW IF EXISTS query_09;
CREATE VIEW query_09 AS
SELECT
   sh.band_name,
   st.*,
   sh_s.title,
   sh_s.ordinality,
   COUNT(*)   OVER ()  AS total_songs,
   SUM(so.duration) OVER () AS total_duration
FROM `show` AS sh
JOIN stage AS st
 ON sh.festival_name    = st.festival_name
AND sh.festival_edition = st.festival_edition
AND sh.id_stage         = st.id_stage
JOIN show_song AS sh_s
 	ON sh.id_show = sh_s.id_show
JOIN song AS so
 	ON sh_s.title      = so.title
AND sh_s.version    = so.version
AND sh_s.written_by = so.written_by
WHERE sh.band_name = 'Rosalia';
-- Total: 129 Rows


CREATE VIEW query_10 AS
SELECT DISTINCT P.id_provider, P.name, P.address, P.phone,P.email,P.base_country
FROM provider P
JOIN product_provider_bar PPB
	ON P.id_provider = PPB.id_provider
JOIN product AS PR
   ON PPB.id_product = PR.id_product
JOIN food AS F
   ON PR.id_product = F.id_food
JOIN bar_product BP
	ON PR.id_product = BP.id_product
JOIN bar B
	ON B.id_bar = BP.id_bar
JOIN festivalgoer_consumes FC
	ON PPB.id_product = FC.id_product AND B.id_bar = FC.id_bar
JOIN ticket T
	ON FC.id_festivalgoer = T.id_festivalgoer
WHERE T.festival_name = 'Tomorrowland' AND F.is_veggie_friendly = 1
ORDER BY P.id_provider ASC;
-- Total: 42 Rows


DROP VIEW IF EXISTS query_11;
CREATE VIEW query_11 AS
SELECT
   ss.id_show,
   SUM(s.duration) AS total_duration
FROM show_song ss
JOIN song s
     ON ss.title = s.title
    AND ss.version = s.version
    AND ss.written_by = s.written_by
GROUP BY ss.id_show
ORDER BY total_duration DESC;
-- Total: 1620 Rows


DROP VIEW IF EXISTS query_12;
CREATE VIEW query_12 AS
SELECT
st.festival_name,
st.festival_edition,
st.id_stage,
st.common_name,
   	100.0 * COUNT(DISTINCT tck.id_festivalgoer) / st.capacity AS percent_capacity
FROM stage AS st
JOIN ticket AS tck
ON  tck.festival_name    = st.festival_name
AND tck.festival_edition = st.festival_edition
GROUP BY
st.festival_name,
st.festival_edition,
st.id_stage,
st.common_name,
st.capacity;
-- Total: 186 Rows


DROP VIEW IF EXISTS query_13;
CREATE VIEW query_13 AS
SELECT P.name, P.surname
FROM person P
JOIN ticket T
   ON P.id_person = T.id_festivalgoer
WHERE T.festival_name = 'Primavera Sound'
GROUP BY P.id_person, P.name, P.surname
HAVING COUNT(DISTINCT T.festival_edition) = (
   SELECT COUNT(DISTINCT FE.edition)
   FROM festival FE
   WHERE FE.name = 'Primavera Sound'
);
-- Total: 0 Rows


DROP VIEW IF EXISTS query_14;
CREATE VIEW query_14 AS
	(SELECT 'beerman' AS staff_type,
	       COUNT(*) AS unemployed_count
	FROM beerman b
	LEFT JOIN beerman_sells bs ON b.id_beerman = bs.id_beerman_sells
	WHERE bs.id_beerman IS NULL)
	UNION ALL
	(SELECT 'bartender' AS staff_type,
	       COUNT(*) AS unemployed_count
	FROM bartender b
	WHERE b.id_bar IS NULL)
	UNION ALL
	(SELECT 'security' AS staff_type,
	       COUNT(*) AS unemployed_count
	FROM security s
	WHERE s.festival_name IS NULL)
	UNION ALL
	(SELECT 'community_manager' AS staff_type,
	       COUNT(*) AS unemployed_count
	FROM cm_account_festival caf
	WHERE caf.account_name IS NULL)
	ORDER BY unemployed_count DESC;
-- Total: 4 Rows


DROP VIEW IF EXISTS query_15;
CREATE VIEW query_15 AS
SELECT
   x.festival_name,
   x.festival_edition,
   COUNT(DISTINCT CASE WHEN x.role = 'CM'   THEN x.staff_id END)  AS num_community_managers,
   COUNT(DISTINCT CASE WHEN x.role = 'BEER' THEN x.staff_id END)  AS num_beermans,
   COUNT(DISTINCT CASE WHEN x.role = 'SEC'  THEN x.staff_id END)  AS num_security,
   COUNT(DISTINCT x.staff_id) AS total_staff
FROM (
       -- Community managers in Primavera Sound
       SELECT
           caf.festival_name,
           caf.festival_edition,
           cm.id_community_manager AS staff_id,
           'CM' AS role
       FROM community_manager AS cm
       JOIN cm_account_festival AS caf
             ON caf.id_community_manager = cm.id_community_manager
       WHERE caf.festival_name = 'Primavera Sound'
       UNION ALL
       -- Beermans in Primavera Sound
       SELECT
           bs.festival_name,
           bs.festival_edition,
           b.id_beerman AS staff_id,
           'BEER' AS role
       FROM beerman AS b
       JOIN beerman_sells AS bs
             ON bs.id_beerman = b.id_beerman
       WHERE bs.festival_name = 'Primavera Sound'
       UNION ALL
       -- Security in Primavera Sound
       SELECT
           s.festival_name,
           s.festival_edition,
           s.id_security AS staff_id,
           'SEC' AS role
       FROM security AS s
       WHERE s.festival_name = 'Primavera Sound'
    ) AS x
WHERE x.staff_id NOT IN (
       SELECT bt.id_bartender
       FROM bartender AS bt
    )
GROUP BY
   x.festival_name,
   x.festival_edition
ORDER BY
   x.festival_edition;
-- Total: 10 Rows


DROP VIEW IF EXISTS query_16;
CREATE VIEW query_16 AS
WITH Ticket_Spending AS (
   SELECT
       id_festivalgoer,
       SUM(price) AS ticket_total
   FROM ticket
   GROUP BY id_festivalgoer
),
Beer_Spending AS (
   SELECT
       id_festivalgoer,
       COUNT(*) * 3 AS total_beer
   FROM beerman_sells
   GROUP BY id_festivalgoer
),
Bar_Prices AS (
   SELECT
       id_bar,
       id_product,
       unit_price
   FROM product_provider_bar
   GROUP BY id_bar, id_product
),
Bar_Spending AS (
   SELECT
       FC.id_festivalgoer,
       SUM(BP.unit_price) AS total_bar
   FROM festivalgoer_consumes FC
   JOIN Bar_Prices BP
       ON FC.id_bar = BP.id_bar
       AND FC.id_product = BP.id_product
   GROUP BY FC.id_festivalgoer
)
SELECT
   FG.id_festivalgoer,
   COALESCE(TS.ticket_total, 0) +
   COALESCE(BS.total_beer, 0) +
   COALESCE(BP.total_bar, 0) AS total_spendings
FROM festivalgoer FG
LEFT JOIN Ticket_Spending TS ON FG.id_festivalgoer = TS.id_festivalgoer
LEFT JOIN Beer_Spending BS ON FG.id_festivalgoer = BS.id_festivalgoer
LEFT JOIN Bar_Spending BP ON FG.id_festivalgoer = BP.id_festivalgoer
WHERE FG.id_festivalgoer = 27577;
-- Total: 1 Row