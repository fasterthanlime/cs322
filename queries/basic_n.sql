-- List the last and first names of the top 30 'TENDEX' players, ordered by
-- descending 'TENDEX' value (Use season stats).
-- 
-- TENDEX=(points+reb+asts+stl+blk‐missedFT‐missedFG‐TO)/minutes

CREATE OR REPLACE VIEW player_tendeses AS
    SELECT
        person_id id,
        MAX((pts+reb+asts+steals+blocks-ftm-fgm-turnovers)/minutes) tendex
    FROM
        player_stats s
        JOIN player_seasons ps ON ps.id = s.player_season_id
        JOIN player_season_types pst ON pst.id = s.player_season_type_id
    WHERE
        pst.name = 'Regular' AND
        minutes > 0
    GROUP BY
        person_id;

SELECT
    p.id, firstname, lastname, tendex, r
FROM
    (
        SELECT id, tendex, RANK() OVER (ORDER BY tendex DESC) r
        FROM player_tendeses
        WHERE tendex IS NOT NULL
    ) t,
    people p
WHERE p.id = t.id AND r <= 30
ORDER BY
    r, lastname, firstname ASC;
