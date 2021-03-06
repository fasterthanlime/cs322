-- List the last and first name of the players who played for a Chicago team
-- and Houston team.

SELECT DISTINCT
    p.id, firstname, lastname
FROM
    player_seasons ps
    JOIN teams t ON
        ps.team_id = t.id AND
        t.city LIKE 'Houston'
    JOIN player_seasons ps2 ON ps2.person_id = ps.person_id
    JOIN teams t2 ON
        ps2.team_id = t2.id AND
        t2.city LIKE 'Chicago'
    JOIN people p ON p.id = ps.person_id
ORDER BY
    lastname, firstname;
