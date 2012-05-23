-- Compute the least successful draft year – the year when the largest
-- percentage of drafted players never played in any of the leagues.

CREATE OR REPLACE VIEW those_who_played_with_year AS
SELECT DISTINCT
    pse.person_id, dr.year
FROM
    drafts dr
    JOIN player_seasons pse ON pse.person_id = dr.person_id
    AND pse.team_id = dr.team_id 
    AND pse.year = dr.year
;

CREATE OR REPLACE VIEW those_who_didnt_play_with_year AS
SELECT DISTINCT year, person_id FROM drafts
MINUS
SELECT DISTINCT year, person_id FROM those_who_played_with_year
;

SELECT
    year, num_nonplayers
FROM (
    SELECT
        year, num_nonplayers,
        RANK() OVER (ORDER BY num_nonplayers DESC) r
    FROM (
        SELECT
            year, COUNT(person_id) num_nonplayers
        FROM
            those_who_didnt_play_with_year
        GROUP BY
            year
    )
)
WHERE r = 1
;

