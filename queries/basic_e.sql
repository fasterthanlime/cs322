-- Compute the highest scoring and lowest scoring player for each season.

CREATE OR REPLACE VIEW best_players AS
SELECT player_id best_player_id, player_firstname best_player_firstname, player_lastname best_player_lastname, year
FROM (
    SELECT player_id, player_firstname, player_lastname, year, pts, RANK() OVER (PARTITION BY year ORDER BY pts DESC) r
    FROM (
        SELECT pl.id player_id, p.lastname player_lastname, p.firstname player_firstname, psea.year year, stat.pts pts
        FROM players pl
        JOIN player_seasons psea ON psea.player_id = pl.id
         JOIN player_stats psta ON psta.player_season_id = psea.id
          JOIN stats stat ON psta.stat_id = stat.id
        JOIN people p ON p.id = pl.person_id
    )
)
WHERE r = 1;

CREATE OR REPLACE VIEW worst_players AS
SELECT player_id worst_player_id, player_firstname worst_player_firstname, player_lastname worst_player_lastname, year
FROM (
    SELECT player_id, player_firstname, player_lastname, year, pts, RANK() OVER (PARTITION BY year ORDER BY pts ASC) r
    FROM (
        SELECT pl.id player_id, p.lastname player_lastname, p.firstname player_firstname, psea.year year, stat.pts pts
        FROM players pl
        JOIN player_seasons psea ON psea.player_id = pl.id
         JOIN player_stats psta ON psta.player_season_id = psea.id
          JOIN stats stat ON psta.stat_id = stat.id
        JOIN people p ON p.id = pl.person_id
    )
)
WHERE r = 1;

CREATE OR REPLACE VIEW best_players_unique AS
SELECT * FROM best_players
WHERE ROWID IN (SELECT MAX(ROWID) FROM best_players GROUP BY year);

CREATE OR REPLACE VIEW worst_players_unique AS
SELECT * FROM worst_players
WHERE ROWID IN (SELECT MAX(ROWID) FROM worst_players GROUP BY year);

CREATE OR REPLACE VIEW query_e AS
SELECT bp.year year, bp.best_player_id, bp.best_player_firstname, bp.best_player_lastname, wp.worst_player_id, wp.worst_player_firstname, wp.worst_player_lastname
FROM best_players_unique bp
  JOIN worst_players_unique wp ON wp.year = bp.year  
ORDER BY year ASC;

