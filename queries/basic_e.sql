-- Compute the highest scoring and lowest scoring player for each season.

CREATE OR REPLACE VIEW best_players AS
SELECT player_id best_player_id, year
FROM (
    SELECT player_id, year, pts, RANK() OVER (PARTITION BY year ORDER BY pts DESC) r
    FROM (
        SELECT pl.id player_id, psea.year year, stat.pts pts
        FROM players pl
        JOIN player_seasons psea ON psea.player_id = pl.id
         JOIN player_stats psta ON psta.player_season_id = psea.id
          JOIN stats stat ON psta.stat_id = stat.id
    )
)
WHERE r = 1;

CREATE OR REPLACE VIEW worst_players AS
SELECT player_id worst_player_id, year
FROM (
    SELECT player_id, year, pts, RANK() OVER (PARTITION BY year ORDER BY pts ASC) r
    FROM (
        SELECT pl.id player_id, psea.year year, stat.pts pts
        FROM players pl
        JOIN player_seasons psea ON psea.player_id = pl.id
         JOIN player_stats psta ON psta.player_season_id = psea.id
          JOIN stats stat ON psta.stat_id = stat.id
    )
)
WHERE r = 1;

CREATE OR REPLACE VIEW query_e AS
SELECT bp.year, bp.best_player_id, wp.worst_player_id
FROM best_players bp
  JOIN worst_players wp ON wp.year = bp.year
;

