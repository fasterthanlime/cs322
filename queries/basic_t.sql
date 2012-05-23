-- List all players which never played for the team that drafted them.

CREATE OR REPLACE VIEW those_who_played AS
SELECT DISTINCT
    pse.person_id
FROM
    drafts dr
    JOIN player_seasons pse ON pse.person_id = dr.person_id
    AND pse.team_id = dr.team_id
;

SELECT
    p.id, firstname, lastname
FROM (
    SELECT DISTINCT person_id FROM drafts
    MINUS
    SELECT person_ID FROM those_who_played
)
    JOIN people p ON p.id = person_id
;

