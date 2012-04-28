-- Print the last and first name of players/coaches who participated in NBA
-- both as a player and as a coach.

CREATE OR REPLACE VIEW query_a AS

SELECT DISTINCT
    p.id, p.firstname, p.lastname
FROM
    people p
    JOIN players pl        ON pl.person_id = p.id
    JOIN player_seasons ps ON ps.player_id = pl.id
    JOIN teams t           ON t.id = ps.team_id
    JOIN leagues l         ON l.id = t.league_id
    JOIN coaches c         ON c.person_id = p.id
    JOIN coaches_teams ct  ON ct.coach_id = c.id
    JOIN teams t2          ON t2.id = ct.team_id
WHERE
    l.name = 'NBA' AND t2.league_id = l.id
ORDER BY
    p.lastname, p.firstname;
