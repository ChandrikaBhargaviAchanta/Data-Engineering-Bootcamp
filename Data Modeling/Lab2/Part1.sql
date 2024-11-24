Create Table players_scd(
player_name TEXT,
scorer_class scoring_class,
is_active BOOLEAN,
start_season INTEGER,
end_season INTEGER,
current_season INTEGER,
PRIMARY KEY(player_name, start_season, end_season, current_season)
);


INSERT INTO players_scd
WITH with_previous AS(
select 
   player_name,
   current_season,
   scorer_class,
   is_active,
   LAG(scorer_class, 1) OVER (PARTITION BY player_name ORDER BY current_season) as previous_scorer_class,
   LAG(is_active, 1) OVER (PARTITION BY player_name ORDER BY current_season)as previous_is_active
FROM players
WHERE current_season <= 2021
),


with_indicators AS(
Select *,
CASE 
   WHEN scorer_class <> previous_scorer_class THEN 1
   WHEN is_active <> previous_is_active THEN 1 
  ELSE 0
  END AS change_indicator
from with_previous   
),


 with_streaks AS(
 SELECT *,
     SUM(change_indicator)
       OVER(PARTITION BY  player_name ORDER BY current_season) AS streak_identifier
 FROM with_indicators
),


 aggregated AS (
         SELECT
            player_name,
            scorer_class,
            is_active,
            MIN(current_season) AS start_season,
			MAX(current_season) AS end_season,
            2021 AS current_season
         FROM with_streaks
         GROUP BY 1,2,3
     )
     SELECT player_name, scorer_class, is_active, start_season, end_season, current_season
     FROM aggregated






