-- List the last and first name of the players which are shorter than the
-- average height of players who have at least 10,000 rebounds and have no more
-- than 12,000 rebounds (if any).

CREATE OR REPLACE VIEW player_total_rebounds AS
    SELECT person_id, SUM(reb) total_reb
        FROM
            players pl
            JOIN player_season_types pst ON
                pst.id = pl.player_season_type_id AND
                pst.name = 'Regular'
        GROUP BY person_id;

SELECT p.id, firstname, lastname, height, total_reb
FROM people p
JOIN player_total_rebounds ptr ON ptr.person_id = p.id
WHERE
    height IS NOT NULL AND
    height < (
        SELECT AVG(height)
        FROM
            people p
            JOIN player_total_rebounds ptr ON ptr.person_id = p.id
        WHERE
            height IS NOT NULL AND
            total_reb >= 10000
    ) AND
    total_reb > 12000
ORDER BY lastname, firstname;
