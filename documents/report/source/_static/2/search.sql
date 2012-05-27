-- The search

(SELECT
    'teams' tname, id, concat(concat(trigram, ' '), name) str
FROM teams
WHERE
    concat(concat(trigram, ' '), name) LIKE ?

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
    concat(concat(concat(concat(ilkid, ' '), firstname), ' '), lastname) LIKE ?

) UNION (

SELECT
    'leagues' tname, id, name str
FROM leagues
WHERE name LIKE ?

) UNION (

SELECT 'conferences' tname, id, name str
FROM conferences
WHERE name LIKE ?)
