-- List the top 20 career scorers of NBA.

CREATE OR REPLACE VIEW nba_players AS
SELECT
    pse.person_id, SUM(pst.pts) career_pts
FROM
    player_seasons pse
    JOIN teams t ON t.id = pse.team_id
    JOIN leagues l ON l.id = t.league_id AND l.name = 'NBA'
    JOIN player_stats pst ON pst.player_season_id = pse.id
    JOIN player_season_types pstype ON pstype.id = pst.player_season_type_id AND pstype.name = 'Regular'
GROUP BY
    person_id
;

SELECT
    person_id, firstname, lastname, career_pts
FROM (
    SELECT
        *
    FROM
        nba_players
    ORDER BY
        career_pts DESC
)
    JOIN people p ON p.id = person_id
WHERE
    rownum <= 20
;

