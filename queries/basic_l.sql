-- List the top 20 career scorers of NBA.

SELECT p.id, p.firstname, p.lastname, pts, r
FROM (
    SELECT person_id, pts, row_number() over (ORDER BY pts DESC) r
    FROM players
    JOIN player_season_types pst ON pst.id = player_season_type_id
    WHERE pst.name = 'Regular'
  ) pl
  JOIN people p ON p.id = pl.person_id
WHERE r <= 20
ORDER BY r ASC;
