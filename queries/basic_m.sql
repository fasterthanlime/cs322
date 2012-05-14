-- For coaches who coached at most 7 seasons but more than 1 season, who are
-- the three more successful?
-- 
-- Success rate is season win percentage:
--   season_win / (season_win + season_loss))
--
-- Be sure to count all seasons when computing the percentage.

SELECT id, firstname, lastname, rate
FROM (
    SELECT person_id, rate, RANK() OVER (ORDER BY rate DESC) rank
    FROM (
        SELECT person_id, season_win / (season_win + season_loss) rate
        FROM coaches
        WHERE season_count BETWEEN 2 AND 7 -- BETWEEN includes boundaries
    )
)
JOIN people pl ON pl.id = person_id
WHERE rank <= 3
ORDER BY rank ASC;
