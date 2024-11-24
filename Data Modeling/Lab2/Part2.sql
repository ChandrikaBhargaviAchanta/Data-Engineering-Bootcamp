CREATE TYPE scd_type AS(
scorer_class scoring_class,
is_active boolean,
start_season INTEGER,
end_season INTEGER) 


with last_season_scd AS (
	SELECT * FROM players_scd
	WHERE current_season = 2021
	AND end_season = 2021
),
historical_scd AS(
	SELECT player_name,
			scorer_class,
			is_active,
			start_season,
			end_season
	 from players_scd
     WHERE current_season = 2021
     AND end_season < 2021
),
this_season_data AS (
    SELECT * FROM players
    WHERE current_season = 2022
),

unchanged_records AS(
SELECT ts.player_name, 
       ts.scorer_class,
	   ts.is_active,
       ls.start_season,
       ts.current_season as end_season
FROM  this_season_data ts JOIN last_season_scd ls ON ls.player_name = ts.player_name
WHERE ts.scorer_class = ls.scorer_class
AND ts.is_active = ls.is_active
),

changed_records AS(
SELECT ts.player_name,  
       UNNEST(ARRAY[
            ROW(ls.scorer_class,
				ls.is_active, 
				ls.start_season,
				ls.end_season
				):: scd_type,
			ROW(ts.scorer_class,
				ts.is_active, 
				ts.current_season,
				ts.current_season
				):: scd_type
            ])AS records
FROM  this_season_data ts LEFT JOIN last_season_scd ls ON ls.player_name = ts.player_name
WHERE (ts.scorer_class <> ls.scorer_class
OR ts.is_active = ls.is_active)
OR ls.player_name IS NULL
),

unnested_changed_records AS(
select player_name,
		(records::scd_type).scorer_class,
        (records::scd_type).is_active,
		(records::scd_type).start_season,
        (records::scd_type).end_season
        FROM changed_records
),

new_records AS(
SELECT ts.player_name, 
ts.scorer_class,
ts.is_active,
ts.current_season as start_season,
ts.current_season as end_season FROM this_season_data ts
LEFT JOIN last_season_scd ls
ON ts.player_name = ls.player_name
WHERE ls.player_name IS NULL
)


SELECT * from historical_scd

UNION ALL 

SELECT * from unchanged_records

UNION ALL 

SELECT * from unnested_changed_records

UNION ALL 

SELECT * from new_records