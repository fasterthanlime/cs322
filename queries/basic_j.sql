-- List the last and first name of the players which are shorter than the
-- average height of players who have at least 10,000 rebounds and have no more
-- than 12,000 rebounds (if any).

SELECT p.id, firstname, lastname, height, reb
FROM people p
JOIN players pl ON pl.person_id = p.id
JOIN player_season_types pst ON pst.id = pl.player_season_type_id
WHERE
    height IS NOT NULL AND
    height < (
        SELECT AVG(height)
        FROM
            people p
            JOIN players pl ON pl.person_id = p.id
            JOIN player_season_types pst ON pst.id = pl.player_season_type_id
        WHERE
            height IS NOT NULL AND
            pst.name = 'Regular' AND
            reb < 12000 AND reb >= 10000
    ) AND
    pst.name = 'Regular' AND
    reb < 12000 AND reb >= 10000
ORDER BY lastname, firstname;
