-- Compute the highest scoring and lowest scoring player for each season.

CREATE OR REPLACE VIEW best_players_unique AS
SELECT
    person_id best_player_id, pts best_player_pts, year
FROM (
    SELECT
        person_id, year, pts,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY pts DESC) r
    FROM (
        SELECT
            person_id, year, SUM(pts) pts
        FROM
            player_seasons ps
            JOIN player_season_types pst ON
                pst.id = ps.player_season_type_id AND
                pst.name = 'Regular'
        GROUP BY person_id, year
    )
)
WHERE r = 1;


CREATE OR REPLACE VIEW worst_players_unique AS
SELECT
    person_id worst_player_id, pts worst_player_pts, year
FROM (
    SELECT
        person_id, year, pts,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY pts ASC) r
    FROM (
        SELECT
            person_id, year, SUM(pts) pts
        FROM
            player_seasons ps
            JOIN player_season_types pst ON
                pst.id = ps.player_season_type_id AND
                pst.name = 'Regular'
        GROUP BY person_id, year
    )
)
WHERE r = 1;

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
