-- List the last and first names of the top 30 'TENDEX' players, ordered by descending
-- 'TENDEX' value (Use season stats).
-- 
-- TENDEX=(points+reb+ass+st+blk‐missedFT‐missedFG‐TO)/minutes

SELECT p.firstname, p.lastname -- TOP 30
FROM (
	SELECT p.firstname, p.lastname, (points+reb+asts+st+blk‐missedFT‐missedFG‐to_)/minutes AS tendex
	FROM (
		SELECT 
			p.firstname,
			p.lastname,
			SUM(pstats.points) AS points,
			SUM(pstats.reb) AS reb,
			SUM(pstats.asts) AS asts,
			SUM(pstats.steals) AS st,
			SUM(pstats.blocks) AS blk,
			SUM(pstats.ftm) AS missedFT,
			SUM(pstats.fgm) AS missedFG,
			SUM(pstats.points) AS to_, --TO?
			SUM(pstats.minutes) AS minutes,
		FROM
			people p
				LEFT OUTER JOIN Players player ON player.person_id = p.id
				LEFT OUTER JOIN Player_Season pseason ON pseason.player_id = player.id
				LEFT OUTER JOIN Player_Stats pstats ON pstats.player_season_id = pseason.id
		GROUP BY p.id
	)
	ORDER BY tendex
)
WHERE ROWNUM <= 30



