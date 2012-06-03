-- List the last and first names of the top 30 'TENDEX' players, ordered by
-- descending 'TENDEX' value (Use season stats).
-- 
-- TENDEX=(points+reb+asts+stl+blk‐missedFT‐missedFG‐TO)/minutes

SELECT
    p.id, firstname, lastname, tendex, r
FROM (
        SELECT
            id, MAX(tendex) tendex,
            RANK() OVER (ORDER BY MAX(tendex) DESC) r
        FROM (
            SELECT person_id id, year, SUM(d_tendex * minutes) / SUM(minutes) tendex
            FROM
                player_seasons ps
                JOIN player_season_types pst ON
                    pst.id = ps.player_season_type_id AND
                    pst.name = 'Regular'
                WHERE d_tendex IS NOT NULL
                GROUP BY person_id, year
                ORDER BY tendex DESC
            )
        GROUP BY id
    ) t
    JOIN people p ON p.id = t.id
WHERE r <= 30
ORDER BY
    r, lastname, firstname ASC;
