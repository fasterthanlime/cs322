-- Compute which was the team with most wins in regular season during which it
-- changed 2, 3 and 4 coaches.

SELECT
    t.id, name, trigram, num_coaches, total_wins, year
FROM 
    (
        SELECT
            team_id, COUNT(person_id) num_coaches, SUM(season_win) total_wins, year,
            RANK() OVER (PARTITION BY year ORDER BY SUM(season_win) DESC) r
        FROM
            coach_seasons
        GROUP BY
            team_id, year
        HAVING COUNT(*) BETWEEN 2 AND 4
    )
    JOIN teams t ON t.id = team_id
WHERE r = 1
ORDER BY year, name;
