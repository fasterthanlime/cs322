-- Print the names of coaches who participated in both leagues (NBA and ABA).

CREATE OR REPLACE VIEW nba_coaches AS
SELECT DISTINCT p.id, p.lastname, p.firstname
FROM teams t
JOIN leagues l ON l.id = t.league_id
JOIN coaches_teams ct ON ct.team_id = t.id
  JOIN coaches c ON c.id = ct.coach_id
    JOIN people p ON p.id = c.person_id
WHERE l.name = 'NBA'
ORDER BY p.lastname, p.firstname;

CREATE OR REPLACE VIEW aba_coaches AS
SELECT DISTINCT p.id, p.lastname, p.firstname
FROM teams t
JOIN leagues l ON l.id = t.league_id
JOIN coaches_teams ct ON ct.team_id = t.id
  JOIN coaches c ON c.id = ct.coach_id
    JOIN people p ON p.id = c.person_id
WHERE l.name = 'ABA'
ORDER BY p.lastname, p.firstname;

CREATE OR REPLACE VIEW query_d AS
SELECT * FROM nba_coaches
 INTERSECT
SELECT * FROM aba_coaches;
