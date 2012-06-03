-- List the best 10 schools for each of the following categories: scorers,
-- rebounders, blockers. Each school’s category ranking is computed as the
-- average of the statistical value for 5 best players that went to that
-- school. Use player’s career average for inputs.

CREATE OR REPLACE VIEW player_averages AS
    SELECT
        person_id, AVG(d_reb) rebs, AVG(pts) pts, AVG(blocks) blocks
    FROM
        player_seasons ps
        JOIN player_season_types pst ON
            pst.id = ps.player_season_type_id AND
            pst.name = 'Regular'
    GROUP BY person_id;

CREATE OR REPLACE VIEW player_locations AS
    SELECT
        person_id, MAX(location_id) location_id -- arbitrary choice
    FROM
        drafts d
    GROUP BY person_id;

CREATE OR REPLACE VIEW location_rebs AS
    SELECT
        location_id, AVG(rebs) value,
        RANK() OVER (ORDER BY AVG(rebs) DESC) r
    FROM (
        SELECT
            location_id, rebs,
            ROW_NUMBER() OVER (PARTITION BY location_id ORDER BY rebs DESC) r
        FROM
            player_averages pa
            JOIN player_locations pl ON pl.person_id = pa.person_id
    )
    WHERE r <= 5
    GROUP BY location_id;

CREATE OR REPLACE VIEW location_pts AS
    SELECT
        location_id, AVG(pts) value,
        RANK() OVER (ORDER BY AVG(pts) DESC) r
    FROM (
        SELECT
            location_id, pts,
            ROW_NUMBER() OVER (PARTITION BY location_id ORDER BY pts DESC) r
        FROM
            player_averages pa
            JOIN player_locations pl ON pl.person_id = pa.person_id
    )
    WHERE r <= 5
    GROUP BY location_id;

CREATE OR REPLACE VIEW location_blocks AS
    SELECT
        location_id, AVG(blocks) value,
        RANK() OVER (ORDER BY AVG(blocks) DESC) r
    FROM (
        SELECT
            location_id, blocks,
            ROW_NUMBER() OVER (PARTITION BY location_id ORDER BY blocks DESC) r
        FROM
            player_averages pa
            JOIN player_locations pl ON pl.person_id = pa.person_id
    )
    WHERE r <= 5
    GROUP BY location_id;

SELECT
    location_id, name, value
FROM
    location_:TYPE
    JOIN locations l ON l.id = location_id
WHERE r <= 10
ORDER BY r ASC, name ASC;
