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

CREATE OR REPLACE VIEW coach_seasons_percentage AS
    SELECT
        person_id, year, team_id,
        100 * SUM(season_win) / (SUM(season_win) + SUM(season_loss)) win_percentage
    FROM
        coach_seasons cs
    GROUP BY
        person_id, year, team_id
;

CREATE OR REPLACE VIEW best_coaches AS
    SELECT
        cp.person_id, cp.win_percentage, c.season_win career_wins, cp.year, cp.team_id
    FROM
        coach_seasons_percentage cp
        JOIN coaches c ON cp.person_id = c.person_id
    ORDER BY
        year
;

CREATE OR REPLACE VIEW query_i AS
    SELECT
        AVG(p.weight) avg_weight, AVG(p.height) avg_height,
        AVG(ROUND((TO_DATE(bc.year, 'YYYY') - p.birthdate)/365.24,0)) avg_age, bc.year,
        bc.win_percentage, bc.career_wins
    FROM
        best_coaches bc
        JOIN player_seasons ps ON ps.team_id = bc.team_id AND ps.year = bc.year
        JOIN people p ON p.id = ps.person_id AND p.weight IS NOT NULL
    GROUP BY
        bc.year, bc.win_percentage, bc.career_wins
    ORDER BY
        bc.year
;
