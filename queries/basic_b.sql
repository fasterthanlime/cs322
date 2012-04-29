-- Print the last and first name of those who participated in NBA as both a
-- player and a coach in the same season.

CREATE OR REPLACE VIEW query_b AS

SELECT DISTINCT
    p.id, p.firstname, p.lastname
FROM
    people p
    JOIN players pl        ON pl.person_id = p.id
    JOIN player_seasons ps ON ps.player_id = pl.id
    JOIN teams t           ON t.id = ps.team_id
    JOIN leagues l         ON l.id = t.league_id
    JOIN coaches c         ON c.person_id = p.id
    JOIN coach_seasons cs  ON cs.coach_id = c.id
    JOIN teams t2          ON t2.id = cs.team_id
WHERE
    l.name = 'NBA' AND
    l.id = t2.league_id AND
    ps.year = cs.year
ORDER BY
    p.lastname, p.firstname;
