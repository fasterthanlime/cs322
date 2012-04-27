-- Print the last and first name of those who participated in NBA as both a
-- player and a coach in the same season.
--
-- Result = 38

CREATE OR REPLACE VIEW query_b AS
SELECT DISTINCT p.lastname, p.firstname
FROM people p
 JOIN players pl ON pl.person_id = p.id
  JOIN player_seasons ps ON ps.player_id = pl.id
 JOIN coaches c ON c.person_id = p.id
  JOIN coaches_teams ct ON ct.coach_id = c.id
    JOIN team_seasons ts ON ts.team_id = ct.team_id AND ts.year = ct.year AND ps.year = ct.year
     JOIN leagues l ON ts.league_id = l.id
WHERE l.name = 'NBA';
