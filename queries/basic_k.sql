-- List the last and first name of the players who played for a Chicago team
-- and Houston team.

CREATE OR REPLACE VIEW played_in_chicago AS
    SELECT
        person_id
    FROM
        player_seasons ps
        JOIN teams t on ps.team_id = t.id AND t.trigram IN ('CHI', 'CH1', 'CH2')
;

CREATE OR REPLACE VIEW played_in_houston AS
    SELECT
        person_id
    FROM
        player_seasons ps
        JOIN teams t on ps.team_id = t.id AND t.trigram IN ('HOU', 'HMV')
;

SELECT
    p.id, firstname, lastname
FROM
    (
        SELECT
            *
        FROM
            played_in_chicago
        INTERSECT
        SELECT
            *
        FROM
            played_in_houston
    )
    JOIN people p on p.id = person_id
ORDER BY
    lastname, firstname
;

