-- Print the names of coaches who participated in both leagues (NBA and ABA).

SELECT id, firstname, lastname
FROM people
WHERE id IN (
    SELECT DISTINCT person_id
    FROM coach_seasons cs
    JOIN teams t ON t.id = cs.team_id
    JOIN leagues l ON l.id = t.league_id AND l.name = 'NBA'
INTERSECT
    SELECT DISTINCT person_id
    FROM coach_seasons cs
    JOIN teams t ON t.id = cs.team_id
    JOIN leagues l ON l.id = t.league_id AND l.name = 'ABA'
)
ORDER BY lastname, firstname;
