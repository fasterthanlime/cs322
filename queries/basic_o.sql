-- List the last and first names of the top 10 'TENDEX' players, ordered by
-- descending 'TENDEX' value (Use playoff stats).
-- 
-- TENDEX=(points+reb+ass+st+blk‐missedFT‐missedFG‐TO)/minutes

CREATE OR REPLACE VIEW player_best_playoff_tendices AS
    SELECT
        person_id id, MAX(d_tendex) tendex
    FROM
        player_seasons ps
        JOIN player_season_types pst ON pst.id = ps.player_season_type_id
    WHERE
        pst.name = 'Playoff' AND
        d_tendex IS NOT NULL
    GROUP BY
        person_id;

SELECT
    p.id, firstname, lastname, tendex, r
FROM
    (
        SELECT id, tendex, RANK() OVER (ORDER BY tendex DESC) r
        FROM player_best_playoff_tendices
        WHERE tendex IS NOT NULL
    ) t
    JOIN people p ON p.id = t.id
WHERE r <= 10
ORDER BY
    r, lastname, firstname ASC;
