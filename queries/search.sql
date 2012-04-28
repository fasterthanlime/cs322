-- The searich
(
    SELECT
        'teams' tname, id, concat(concat(trigram, ' '), name) str
    FROM teams
    WHERE
        name LIKE ? OR
        trigram LIKE ?
) UNION (
    SELECT
        'locations' tname, id,  name str
    FROM locations
    WHERE name LIKE ?
) UNION (
    SELECT
        'people' tname,
        id,
        concat(concat(concat(concat(ilkid, ' '), firstname), ' '), lastname) str
    FROM people
    WHERE
        ilkid LIKE ? OR
        firstname LIKE ? OR
        lastname LIKE ?
) UNION (
    SELECT
        'leagues' tname, id, name str
        FROM leagues
        WHERE name LIKE ?
) UNION (
    SELECT 'conferences' tname, id, name str
    FROM conferences
    WHERE name LIKE ?
)
