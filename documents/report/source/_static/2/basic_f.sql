-- Print the names of oldest and youngest player that have participated in the
-- playoffs for each season.

CREATE OR REPLACE VIEW youngest_players AS

SELECT
    id youngest_id, firstname youngest_firstname, lastname youngest_lastname,
    birthdate youngest_birthdate, year
FROM (
    SELECT
        id, lastname, firstname, year, birthdate,
        RANK() OVER (PARTITION BY year ORDER BY birthdate DESC) r
    FROM (
        SELECT
            pl.id, p.lastname, p.firstname, psea.year, pl.birthdate
        FROM
            players pl
            JOIN player_seasons psea      ON psea.player_id = pl.id
            JOIN player_stats psta        ON psta.player_season_id = psea.id
            JOIN player_season_types psty ON psta.player_season_type_id = psty.id
            JOIN people p ON p.id = pl.person_id
        WHERE
            psty.name = 'Playoff'
    )
)
WHERE r = 1;


CREATE OR REPLACE VIEW oldest_players AS

SELECT
    id oldest_id, firstname oldest_firstname, lastname oldest_lastname,
    birthdate oldest_birthdate, year
FROM (
    SELECT
        id, lastname, firstname, year, birthdate,
        RANK() OVER (PARTITION BY year ORDER BY birthdate ASC) r
    FROM (
        SELECT
            pl.id, p.lastname, p.firstname, psea.year, pl.birthdate
        FROM
            players pl
            JOIN player_seasons psea      ON psea.player_id = pl.id
            JOIN player_stats psta        ON psta.player_season_id = psea.id
            JOIN player_season_types psty ON psta.player_season_type_id = psty.id
            JOIN people p                 ON p.id = pl.person_id
        WHERE
            psty.name = 'Playoff'
    )
)
WHERE r = 1;


CREATE OR REPLACE VIEW youngest_players_unique AS

SELECT *
FROM youngest_players
WHERE ROWID IN (
    SELECT MAX(ROWID)
    FROM youngest_players
    GROUP BY year
);


CREATE OR REPLACE VIEW oldest_players_unique AS

SELECT *
FROM oldest_players
WHERE ROWID IN (
    SELECT MAX(ROWID)
    FROM oldest_players
    GROUP BY year
);


CREATE OR REPLACE VIEW query_f AS

SELECT
    yp.year,
    yp.youngest_id, yp.youngest_firstname, yp.youngest_lastname,
    yp.youngest_birthdate,
    op.oldest_id, op.oldest_firstname, op.oldest_lastname, op.oldest_birthdate
FROM
    youngest_players yp
    JOIN oldest_players op ON op.year = yp.year
ORDER BY
    year ASC;

