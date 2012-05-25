-- List the name of the schools according to the number of players they sent to
-- the NBA. Sort them in descending order by number of drafted players.

SELECT l1.id, l1.name, l2.counter
FROM locations l1
LEFT JOIN (
    SELECT location_id id, COUNT(*) counter
    FROM
        drafts d1,
        (
            SELECT person_id, MAX(CONCAT(year, round)) yr
            FROM drafts d3
            JOIN teams t ON t.id = d3.team_id
            JOIN leagues l ON l.id = t.league_id
            WHERE l.name = 'NBA'
            GROUP BY person_id
        ) d2
    WHERE
        d1.person_id = d2.person_id AND
        CONCAT(year, round) = d2.yr
    GROUP BY
        location_id
) l2 ON l1.id = l2.id
ORDER BY
    counter DESC NULLS LAST;
