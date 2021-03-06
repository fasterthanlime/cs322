-- Print the name of the school with the highest number of players sent to the
-- NBA

CREATE OR REPLACE VIEW query_c AS

SELECT
    id, name, counter
FROM ( 
    SELECT
        id, name, counter, RANK() OVER (ORDER BY counter DESC) rank
    FROM (
        SELECT
            il.id, il.name, COUNT(il.id) counter
        FROM
            locations il
            JOIN drafts d  ON d.location_id = il.id
            JOIN teams t  ON t.id = d.team_id
            JOIN leagues l ON l.id = t.league_id
        WHERE
            l.name = 'NBA'
        GROUP BY
            il.id, il.name
    )
)
WHERE
    rank = 1;
