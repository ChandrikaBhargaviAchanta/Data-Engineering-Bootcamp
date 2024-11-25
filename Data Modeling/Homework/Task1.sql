--DROP TYPE IF EXISTS films_data CASCADE;

CREATE TYPE films_data AS (
film TEXT, 
votes INTEGER,
rating REAL,
filmid TEXT
);


--DROP TYPE IF EXISTS quality_class CASCADE;

CREATE TYPE quality_class_type AS ENUM('star','good','average', 'bad');


-- DROP TABLE IF EXISTS Actors;

CREATE TABLE Actors(
			actor TEXT,
			actorid TEXT, 
			year INTEGER,
      ilmsdata films_data[],
		  quality_class quality_class_type,
    	is_active BOOLEAN,
	    PRIMARY KEY(actor, actorid, year)
 );

