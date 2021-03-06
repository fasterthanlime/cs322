-- Compute the best teams according to statistics: for each season and for each
-- team compute 'TENDEX' values for its best 5 players. Sum these values for
-- each team to compute 'TEAM TENDEX' value. For each season list the team with
-- the best win/loss percentage and the team with the highest 'TEAM TENDEX'
-- value.

CREATE OR REPLACE VIEW team_season_tendices AS
    SELECT id, year, team_tendex
    FROM (
        SELECT
            id, year, team_tendex,
            MAX(team_tendex) OVER (PARTITION BY year) max_team_tendex
        FROM (
            SELECT
                team_id id, year, SUM(tendex) team_tendex
            FROM (
                SELECT
                    team_id, year, d_tendex tendex,
                    ROW_NUMBER() OVER (PARTITION BY team_id, year ORDER BY
                    d_tendex DESC) r
                FROM
                    player_seasons ps
                    JOIN player_season_types pst ON
                        pst.id = ps.player_season_type_id
                WHERE
                    pst.name = 'Regular' AND
                    d_tendex IS NOT NULL
            )
            WHERE r <= 5
            GROUP BY team_id, year
        )
    )
    WHERE team_tendex = max_team_tendex;

CREATE OR REPLACE VIEW team_season_winlosses AS
    SELECT id, year, winloss
    FROM (
        SELECT
            id, year, winloss,
            MAX(winloss) OVER (PARTITION BY year) max_winloss
        FROM (
            SELECT
                team_id id, year,
                SUM(season_win) / (SUM(season_win) + SUM(season_loss)) winloss
            FROM
                coach_seasons cs
            GROUP BY year, team_id
        )
    )
    WHERE winloss = max_winloss;

SELECT
    tst.year,
    tst.id tid, t1.name tname, t1.trigram ttrigram, team_tendex,
    tswl.id wlid, t2.name wlname, t2.trigram wltrigram, winloss
FROM
    team_season_tendices tst
    JOIN teams t1 ON t1.id = tst.id
    JOIN team_season_winlosses tswl ON tswl.year = tst.year
    JOIN teams t2 ON t2.id = tswl.id
ORDER BY
    year ASC;
