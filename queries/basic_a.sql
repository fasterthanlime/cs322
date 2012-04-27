-- Print the last and first name of players/coaches who participated in NBA
-- both as a player and as a coach.
--
-- Result = 155

CREATE OR REPLACE VIEW query_a AS
SELECT DISTINCT p.lastname, p.firstname
FROM people p
 JOIN players pl ON pl.person_id = p.id
  JOIN player_seasons ps ON ps.player_id = pl.id
   JOIN team_seasons ts ON ts.team_id = ps.team_id AND ts.year = ps.year
    JOIN leagues l ON ts.league_id = l.id
 JOIN coaches c ON c.person_id = p.id
  JOIN coaches_teams ct ON ct.coach_id = c.id
    JOIN team_seasons ts2 ON ts2.team_id = ct.team_id AND ts2.year = ct.year
     JOIN leagues l2 ON ts2.league_id = l2.id
WHERE l.name = 'NBA' AND l2.name = 'NBA';
