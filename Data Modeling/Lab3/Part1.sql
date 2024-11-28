--DROP TYPE vertex_type CASCADE;

CREATE TYPE vertex_type
AS ENUM('player', 'team', 'game');


--DROP TABLE vertices;

CREATE TABLE vertices(
identifier TEXT, 
type vertex_type,
properties JSON, 
PRIMARY KEY (identifier, type)
)

--DROP TYPE edge_type CASCADE;

CREATE TYPE edge_type AS
ENUM('players_against', 
     'shares_team',
	 'plays_in',
	 'plays_on'
	) 


--DROP TABLE edges;

CREATE TABLE edges(
subject_identifier TEXT,
subject_type vertex_type,
object_identifier TEXT,
object_type vertex_type,
edge_type edge_type,
properties JSON,
PRIMARY KEY (subject_identifier, 
			subject_type,
			object_identifier,
			object_type,
			edge_type))
