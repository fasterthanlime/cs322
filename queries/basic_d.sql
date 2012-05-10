-- Print the names of coaches who participated in both leagues (NBA and ABA).

SELECT DISTINCT
    p.id, p.lastname, p.firstname
FROM
    (
        SELECT *
        FROM
            coaches c
            JOIN coach_seasons cs ON cs.coach_id = c.id
            JOIN teams t          ON t.id = cs.team_id
            JOIN leagues l        ON l.id = t.league_id
        WHERE l.name = 'NBA'
    ) -- Sub-query: all coaches who participated in NBA
    JOIN coach_seasons cs ON cs.coach_id = id
    JOIN teams t          ON t.id = cs.team_id
    JOIN leagues l        ON l.id = t.league_id
    JOIN people p         ON p.id = person_id
WHERE
    l.name = 'ABA'
ORDER BY
    p.lastname, p.firstname;

