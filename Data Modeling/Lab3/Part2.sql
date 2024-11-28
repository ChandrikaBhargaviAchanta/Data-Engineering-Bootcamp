INSERT INTO vertices
select
game_id AS identifier,
'game':: vertex_type AS type,
json_build_object('pts_home', pts_home,
				'pts_away', pts_away,
				'winning_team', CASE WHEN home_team_wins =1 THEN home_team_id ELSE visitor_team_id END
) AS properties
from games;



INSERT INTO vertices
with players_agg AS(
SELECT 
	player_id AS identifier,
	MAX(player_name) as player_name,
	count(1) AS number_of_games,
	sum(pts) AS total_points,
	ARRAY_AGG(DISTINCT team_id) AS teams
FROM game_details
GROUP BY player_id 
)

SELECT identifier, 'player'::vertex_type,
	json_build_object(
		'player_name', player_name,
		'number_of_games', number_of_games,
		'total_points', total_points,
		'teams', teams
		)
FROM players_agg;


INSERT INTO vertices
with teams_deduped AS(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY team_id) as row_num
	FROM teams
)
SELECT 
	team_id AS identifier,
	'team':: vertex_type AS type,
	json_build_object(
		'abbreviation', abbreviation,
		'nickname', nickname,
		'city', city,
		'arena', arena,
		'year_founded', yearfounded)
from teams_deduped
where row_num = 1