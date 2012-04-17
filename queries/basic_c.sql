-- Print the name of the school with the highest number of players sent to the
-- NBA

SELECT name
FROM ( 
    SELECT name, counter, RANK() OVER (ORDER BY counter DESC) r
    FROM (
        SELECT il.name, COUNT(il.id) counter
        FROM locations il
        JOIN drafts d ON d.location_id = il.id
         JOIN team_seasons ts ON ts.team_id = d.team_id AND ts.year = d.year
          JOIN leagues l ON l.id = ts.league_id
        WHERE l.name = 'NBA'
        GROUP BY il.name
    )
)
WHERE r = 1;
