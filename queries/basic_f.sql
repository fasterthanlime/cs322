-- Print the names of oldest and youngest player that have participated in the
-- playoffs for each season.

CREATE OR REPLACE VIEW youngest_players AS
SELECT id youngest_id, firstname youngest_firstname, lastname youngest_lastname, birthdate youngest_birthdate, year
FROM (
    SELECT id, lastname, firstname, year, birthdate, RANK() OVER (PARTITION BY year ORDER BY birthdate DESC) r
    FROM (
        SELECT pl.id, p.lastname, p.firstname, psea.year, pl.birthdate
        FROM players pl
        JOIN player_seasons psea ON psea.player_id = pl.id
          JOIN player_stats psta ON psta.player_season_id = psea.id
            JOIN player_season_types psty ON psty.name = 'Playoff' AND psta.player_season_type_id = psty.id
        JOIN people p ON p.id = pl.person_id
    )
)
WHERE r = 1;

CREATE OR REPLACE VIEW query_f AS
SELECT * FROM youngest_players;

