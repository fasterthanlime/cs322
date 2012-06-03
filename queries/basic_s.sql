-- Compute which was the team with most wins in regular season during which it
-- changed 2, 3 and 4 coaches.

SELECT
    team_id, name, trigram, num_coaches, total_wins, year
FROM (
        SELECT
            team_id, year, d_coach_counter num_coaches, d_season_win total_wins,
            RANK() OVER (ORDER BY d_season_win DESC) r
        FROM team_seasons
        WHERE d_coach_counter BETWEEN 2 AND 6
    ) ts
    JOIN teams t ON t.id = ts.team_id
WHERE
    r = 1;
