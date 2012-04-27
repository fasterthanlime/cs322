-- Print the names of coaches who participated in both leagues (NBA and ABA).

CREATE OR REPLACE VIEW nba_coaches AS
SELECT DISTINCT p.id, p.lastname, p.firstname
FROM team_seasons ts
JOIN coaches_teams ct ON ct.team_id = ts.team_id
  JOIN coaches c ON c.id = ct.coach_id
    JOIN people p ON p.id = c.person_id
      JOIN leagues l ON l.id = ts.league_id
WHERE l.name = 'NBA';

CREATE OR REPLACE VIEW aba_coaches AS
SELECT DISTINCT p.id, p.lastname, p.firstname
FROM team_seasons ts
JOIN coaches_teams ct ON ct.team_id = ts.team_id
  JOIN coaches c ON c.id = ct.coach_id
    JOIN people p ON p.id = c.person_id
      JOIN leagues l ON l.id = ts.league_id
WHERE l.name = 'ABA';

CREATE OR REPLACE VIEW query_d AS
SELECT * FROM nba_coaches
 INTERSECT
SELECT * FROM aba_coaches;
