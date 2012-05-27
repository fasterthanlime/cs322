-- Print the name of the school with the highest number of players sent to the
-- NBA

SELECT l.id, l.name, lc.counter
FROM (
    SELECT id, counter, RANK() OVER (ORDER BY counter DESC) r
    FROM (
        SELECT location_id id, COUNT(*) counter
        FROM (
            SELECT
                d.id, CONCAT(year, round) yr, location_id,
                MAX(CONCAT(year, round)) OVER (PARTITION BY person_id) last_yr
            FROM drafts d
            JOIN teams t ON t.id = d.team_id
            JOIN leagues l ON l.id = t.league_id
            WHERE l.name = 'NBA'
        )
        WHERE
            yr = last_yr
        GROUP BY
            location_id
    )
) lc
JOIN locations l ON l.id = lc.id
WHERE r = 1
ORDER BY name ASC;
