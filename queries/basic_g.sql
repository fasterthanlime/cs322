-- List the name of the schools according to the number of players they sent to
-- the NBA. Sort them in descending order by number of drafted players.

SELECT
    loc.id, loc.name, COUNT(*) counter
FROM
    locations loc, teams t, leagues l,
    (
        SELECT location_id, team_id
        FROM
            drafts d1,
            (
                SELECT person_id, MAX(CONCAT(year, round)) yr
                FROM drafts
                GROUP BY person_id
            ) d2
        WHERE
            d1.person_id = d2.person_id AND
            CONCAT(year, round) = d2.yr
    )
WHERE
    location_id = loc.id AND
    team_id = t.id AND
    t.league_id = l.id AND
    l.name = 'NBA'
GROUP BY
    loc.id, loc.name
ORDER BY
    counter DESC;
