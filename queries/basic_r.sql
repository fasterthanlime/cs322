-- List the best 10 schools for each of the following categories: scorers,
-- rebounders, blockers. Each school’s category ranking is computed as the
-- average of the statistical value for 5 best players that went to that
-- school. Use player’s career average for inputs.

CREATE OR REPLACE VIEW player_location AS
	SELECT l.name loc, pe.firstname firstname,
		pe.lastname lastname, p.reb reb, p.blocks blk, p.pts pts
	FROM 
		drafts d JOIN players p ON d.person_id = p.person_id
			JOIN locations l ON d.location_id = l.id
			JOIN people pe ON pe.id = p.person_id
      JOIN player_season_types pst ON
                        pst.id = p.player_season_type_id
  WHERE pst.name = 'Regular';

CREATE OR REPLACE VIEW reb_per_location AS
  SELECT loc, location_score
    FROM (
      SELECT loc, SUM(reb) location_score
      FROM (
        SELECT loc, reb, ROW_NUMBER() OVER (PARTITION BY loc ORDER BY
                      reb DESC) r
          FROM player_location
      )
      WHERE r <= 5
      GROUP BY loc
      ORDER BY location_score DESC
    );
  
CREATE OR REPLACE VIEW pts_per_location AS
  SELECT loc, location_score
    FROM (
      SELECT loc, SUM(pts) location_score
      FROM (
        SELECT loc, pts, ROW_NUMBER() OVER (PARTITION BY loc ORDER BY
                      pts DESC) r
          FROM player_location
      )
      WHERE r <= 5
      GROUP BY loc
      ORDER BY location_score DESC
    );
    
CREATE OR REPLACE VIEW blk_per_location AS
  SELECT loc, location_score
    FROM (
      SELECT loc, SUM(blk) location_score
      FROM (
        SELECT loc, blk, ROW_NUMBER() OVER (PARTITION BY loc ORDER BY
                      blk DESC) r
          FROM player_location
      )
      WHERE r <= 5
      GROUP BY loc
      ORDER BY location_score DESC
    );
