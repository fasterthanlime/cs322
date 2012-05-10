-- List the name of the schools according to the number of players they sent to
-- the ABA. Sort them in descending order by number of drafted players.

SELECT
    l.name, COUNT(l.id) counter
FROM
    locations l
    JOIN drafts d   ON d.location_id = l.id
    JOIN teams t    ON t.id = d.team_id
    JOIN leagues le ON le.id = t.league_id
WHERE
    le.name = 'ABA'
GROUP BY
    l.name
ORDER BY
    counter DESC;

-- STUB
