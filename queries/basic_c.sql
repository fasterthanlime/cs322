-- Print the name of the school with the highest number of players sent to the
-- NBA

SELECT
    id, name, counter
FROM ( 
    SELECT
        id, name, counter, RANK() OVER (ORDER BY counter DESC) rank
    FROM (
        SELECT
            il.id, il.name, COUNT(il.id) counter
        FROM
            locations il,
            (
                SELECT location_id, team_id
                FROM
                    drafts d1,
                    (
                        SELECT person_id, MAX(CONCAT(year, round)) yr
                        FROM drafts d3
                        JOIN teams t ON t.id = d3.team_id
                        JOIN leagues l ON l.id = t.league_id
                        WHERE l.name = 'NBA'
                        GROUP BY person_id
                    ) d2
                WHERE
                    d1.person_id = d2.person_id AND
                    CONCAT(year, round) = d2.yr
            )
        WHERE
            il.id = location_id
        GROUP BY
            il.id, il.name
    )
)
WHERE
    rank = 1;
