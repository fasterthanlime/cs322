-- Compute which was the team with most wins in regular season during which it
-- changed 2, 3 and 4 coaches.

SELECT
    team_id, team.name team_name, num_coaches, total_wins, year
FROM (
    SELECT
        team_id, num_coaches, total_wins, year
    FROM (
        SELECT
            team_id, num_coaches, total_wins, year,
            RANK() OVER (PARTITION BY year ORDER BY total_wins DESC) r
        FROM (
            SELECT
                team_id, COUNT(person_id) num_coaches, SUM(season_win) total_wins, year
            FROM
                coach_seasons
            GROUP BY
                team_id, year
        )
        WHERE
            num_coaches >= 2 AND num_coaches <= 4
    )
    WHERE r = 1
)
    JOIN teams team ON team.id = team_id
;
