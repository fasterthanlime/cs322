-- List the average weight, average height and average age, of teams of coaches
-- with more than 'XXX' season career wins and more than 'YYY' win percentage,
-- in each season they coached.
--
-- 'XXX' and 'YYY' are parameters. Try with combinations:
-- XXX   YYY
-- 1000  70%
-- 1000  60%
-- 1000  50%
-- 1000  55%
-- 700   55%
-- 700   45%
--
-- Sort the result by year in ascending order
-- 
-- CREATE OR REPLACE VIEW player_avg AS
-- SELECT
--     AVG(pl.weight) avg_weight, AVG(pl.height) avg_height, AVG(ROUND((SYSDATE - pl.birthdate)/365.24,0)) avg_age
-- FROM
--     players pl
-- END

-- A few utility views

CREATE OR REPLACE VIEW coach_seasons_percentage AS
    SELECT
        person_id, season_win, season_loss, 100 * (season_win / (season_win + season_loss)) win_percentage, year
    FROM
        coach_seasons cs
;

CREATE OR REPLACE VIEW coach_seasons_career AS
    SELECT
        person_id, SUM(season_win) career_wins
    FROM
        coach_seasons cs
    GROUP BY
        person_id
;

CREATE OR REPLACE VIEW best_coaches AS
    SELECT
        cp.person_id, season_win, season_loss, win_percentage, career_wins, cp.year
    FROM
        coach_seasons_percentage cp
        JOIN coach_seasons_career cc ON cp.person_id = cc.person_id
    ORDER BY
        year
;

CREATE OR REPLACE VIEW query_i AS
    SELECT
        *
    FROM
    (
        SELECT
            AVG(weight) avg_weight, AVG(height) avg_height, AVG(ROUND((TO_DATE(year, 'YYYY') - birthdate)/365.24,0)) avg_age, year, win_percentage, career_wins
        FROM
            best_coaches bc
            JOIN people p ON p.id = bc.person_id
        GROUP BY
            year, win_percentage, career_wins
        ORDER BY
            year
    )
    WHERE avg_weight IS NOT NULL
;

