-- Print the last and first name of players/coaches who participated in NBA
-- both as a player and as a coach.

SELECT DISTINCT
    p.id, p.firstname, p.lastname
FROM
    people p
    JOIN player_seasons ps ON ps.person_id = p.id
    JOIN teams t           ON t.id = ps.team_id
    JOIN leagues l         ON l.id = t.league_id
    JOIN coach_seasons cs  ON cs.person_id = p.id
    JOIN teams t2          ON t2.id = cs.team_id
WHERE
    l.name = 'NBA' AND t2.league_id = l.id
ORDER BY
    p.lastname, p.firstname;
