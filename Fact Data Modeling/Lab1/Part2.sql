SELECT * from fct_game_details gd JOIN teams t  
ON t.team_id = gd.dim_team_id


SELECT dim_player_name, COUNT(CASE WHEN dim_not_with_team THEN 1 END) AS bailed_num
FROM fct_game_details 
GROUP BY 1
ORDER BY 2 DESC

SELECT 
	dim_player_name, 
	dim_is_playing_at_home,
	COUNT(1) AS num_games,
	SUM(m_pts) AS total_pts,
	COUNT(CASE WHEN dim_not_with_team THEN 1 END) AS bailed_num,
	CAST(COUNT(CASE WHEN dim_not_with_team THEN 1 END)AS REAL)/COUNT(1) AS bail_pct
FROM fct_game_details 
GROUP BY 1,2
ORDER BY 6 DESC