-- Compute the highest scoring and lowest scoring player for each season.

CREATE OR REPLACE VIEW best_player AS SELECT id, counter
FROM (
    SELECT id, counter, RANK() OVER (ORDER BY counter DESC) r
    FROM (
        SELECT pl.id, SUM(stat.pts) counter
        FROM players pl
        JOIN player_seasons psea ON psea.player_id = pl.id
         JOIN player_stats psta ON psta.player_season_id = psea.id
          JOIN stats stat ON stat.id = psta.stat_id
        GROUP BY pl.id
    )
)
WHERE r = 1;

SELECT firstname, lastname
FROM best_player bp
JOIN players pl ON pl.id = bp.id
JOIN people p ON p.id = pl.person_id;
