-- Print the names of coaches who participated in both leagues (NBA and ABA).

CREATE OR REPLACE VIEW nba_coaches AS SELECT DISTINCT p.id
FROM people p
JOIN coaches c ON c.person_id = p.id
  JOIN coaches_teams ct ON ct.coach_id = c.id
    JOIN team_seasons ts ON ts.team_id = ct.team_id AND ts.year = ct.year
      JOIN leagues l ON ts.league_id = l.id
WHERE l.name = 'NBA';

CREATE OR REPLACE VIEW aba_coaches AS SELECT DISTINCT p.id
FROM people p
JOIN coaches c ON c.person_id = p.id
  JOIN coaches_teams ct ON ct.coach_id = c.id
    JOIN team_seasons ts ON ts.team_id = ct.team_id AND ts.year = ct.year
      JOIN leagues l ON ts.league_id = l.id
WHERE l.name = 'ABA';

CREATE OR REPLACE VIEW query_a AS
SELECT * FROM nba_coaches
  INTERSECT
SELECT * FROM aba_coaches;
