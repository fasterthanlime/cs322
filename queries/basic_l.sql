-- List the top 20 career scorers of NBA.

SELECT
    p.id, firstname, lastname, pts
FROM (
        SELECT
            person_id, SUM(pts) pts,
            RANK() OVER (ORDER BY SUM(pts) DESC) r
        FROM
            players pl
            JOIN leagues l ON
                l.id = pl.league_id AND
                l.name = 'NBA'
        GROUP BY person_id
        ORDER BY pts DESC
    )
    JOIN people p ON p.id = person_id
WHERE
    r <= 20
ORDER BY
    r ASC, lastname ASC, firstname ASC;
