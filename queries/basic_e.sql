-- Compute the highest scoring and lowest scoring player for each season.

CREATE OR REPLACE VIEW best_players AS
SELECT
    person_id best_player_id, pts best_player_pts, year
FROM (
    SELECT
        person_id, year, pts,
        RANK() OVER (PARTITION BY year ORDER BY pts DESC) r
    FROM (
        SELECT
            psea.person_id, psea.year year, psta.pts pts
        FROM player_seasons psea
        JOIN player_stats psta ON psta.player_season_id = psea.id
    )
)
WHERE r = 1;


CREATE OR REPLACE VIEW worst_players AS
SELECT
    person_id worst_player_id, pts worst_player_pts, year
FROM (
    SELECT
        person_id, year, pts,
        RANK() OVER (PARTITION BY year ORDER BY pts ASC) r
    FROM (
        SELECT
            psea.person_id, psea.year year, psta.pts pts
        FROM player_seasons psea
        JOIN player_stats psta ON psta.player_season_id = psea.id
    )
)
WHERE r = 1;


CREATE OR REPLACE VIEW best_players_unique AS
SELECT * FROM best_players
WHERE ROWID IN (
    SELECT MAX(ROWID)
    FROM best_players GROUP BY year
);


CREATE OR REPLACE VIEW worst_players_unique AS
SELECT * FROM worst_players
WHERE ROWID IN (
    SELECT MAX(ROWID)
    FROM worst_players
    GROUP BY year
);


SELECT
    bp.year,
    bp.best_player_id, p1.firstname, p1.lastname, bp.best_player_pts,
    wp.worst_player_id, p2.firstname, p2.lastname, wp.worst_player_pts
FROM
    best_players_unique bp
    JOIN worst_players_unique wp ON wp.year = bp.year
    JOIN people p1 ON p1.id = bp.best_player_id
    JOIN people p2 ON p2.id = wp.worst_player_id
ORDER BY
    year ASC;
