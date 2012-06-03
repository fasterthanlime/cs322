-- List all players which never played for the team that drafted them.

SELECT
    p.id, firstname, lastname
FROM
    drafts d
    LEFT JOIN player_seasons ps ON
        ps.team_id = d.team_id
    JOIN people p ON p.id = d.person_id
WHERE
    ps.team_id IS NULL
ORDER BY
    lastname, firstname;
