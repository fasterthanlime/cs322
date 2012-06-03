-- List the best 10 schools for each of the following categories: scorers,
-- rebounders, blockers. Each school’s category ranking is computed as the
-- average of the statistical value for 5 best players that went to that
-- school. Use player’s career average for inputs.

CREATE OR REPLACE VIEW location_stats AS
    SELECT d.person_id, d.location_id loc, p.reb reb, p.blocks blk, p.pts pts
    FROM 
      (drafts d
          -- One person has many drafts, take only one.
          RIGHT JOIN (SELECT DISTINCT person_id FROM drafts) d2
                              ON d2.person_id = d.person_id
          JOIN players p      ON d.person_id = p.person_id
          JOIN player_season_types pst
                              ON pst.id = p.player_season_type_id
          )
    WHERE pst.name = 'Regular';

CREATE OR REPLACE VIEW reb_per_location AS
    SELECT loc, SUM(reb) location_score
    FROM (
      SELECT loc, reb, ROW_NUMBER() OVER (PARTITION BY loc ORDER BY
                    reb DESC) r
        FROM player_location
    )
    WHERE r <= 5
    GROUP BY loc;
  
CREATE OR REPLACE VIEW pts_per_location AS
    SELECT loc, SUM(pts) location_score
    FROM (
  	    SELECT loc, pts, ROW_NUMBER() OVER (PARTITION BY loc ORDER BY
				  pts DESC) r
		FROM player_location
    )
	  WHERE r <= 5
	  GROUP BY loc;
    
CREATE OR REPLACE VIEW blk_per_location AS
    SELECT loc, SUM(blk) location_score
    FROM (
    SELECT loc, blk, ROW_NUMBER() OVER (PARTITION BY loc ORDER BY
            blk DESC) r
      FROM player_location
    )
    WHERE r <= 5
    GROUP BY loc;

SELECT *
FROM (
    SELECT l.name, location_score
    FROM blk_per_location
        JOIN locations l ON
      l.id = loc
    ORDER BY location_score DESC
    )
WHERE ROWNUM <=10

    

