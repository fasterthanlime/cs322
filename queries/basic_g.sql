-- List the name of the schools according to the number of players they sent to
-- the NBA. Sort them in descending order by number of drafted players.

SELECT
    l.name, COUNT(l.id) counter
FROM
    locations l
    JOIN drafts d ON d.location_id = l.id
GROUP BY
    l.name
ORDER BY
    counter DESC;
