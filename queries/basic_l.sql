-- List the top 20 career scorers of NBA.

SELECT
    p.id, firstname, lastname, pts
FROM (
        SELECT
            person_id, pts
        FROM
            players pl
            JOIN leagues l ON
                l.id = pl.league_id AND
                l.name = 'NBA'
        ORDER BY pts DESC
    )
    JOIN people p ON p.id = person_id
WHERE
    ROWNUM <= 20
ORDER BY
    pts DESC, lastname ASC, firstname ASC;
