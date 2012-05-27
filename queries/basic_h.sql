-- List the name of the schools according to the number of players they sent to
-- the ABA. Sort them in descending order by number of drafted players.

SELECT l1.id, l1.name, l2.counter
FROM locations l1
LEFT JOIN (
    SELECT location_id id, COUNT(*) counter
    FROM (
        SELECT
            d.id, year, round, location_id,
            MAX(CONCAT(year, round)) OVER (PARTITION BY person_id) last
        FROM drafts d
        JOIN teams t ON t.id = d.team_id
        JOIN leagues l ON l.id = t.league_id
        WHERE l.name = 'ABA'
    )
    WHERE
        CONCAT(year, round) = last
    GROUP BY
        location_id
) l2 ON l1.id = l2.id
ORDER BY
    counter DESC NULLS LAST, name ASC;
