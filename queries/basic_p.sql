-- Compute the least successful draft year – the year when the largest
-- percentage of drafted players never played in any of the leagues.

SELECT
    year, total
FROM (
    SELECT
        d.year, COUNT(DISTINCT d.person_id) total,
        RANK() OVER (ORDER BY COUNT(d.person_id) DESC) r
    FROM
        drafts d
        LEFT JOIN player_seasons ps ON ps.person_id = d.person_id
    WHERE
        ps.person_id IS NULL
    GROUP BY d.year
)
WHERE r = 1;
