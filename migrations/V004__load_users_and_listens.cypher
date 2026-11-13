// V004 - Listeners, their listening history and the artists they follow.

LOAD CSV WITH HEADERS FROM 'file:///users.csv' AS row
MERGE (u:User {id: toInteger(row.id)})
SET u.name = row.name, u.country = row.country;

LOAD CSV WITH HEADERS FROM 'file:///listens.csv' AS row
MATCH (u:User {id: toInteger(row.userId)})
MATCH (t:Track {id: toInteger(row.trackId)})
MERGE (u)-[l:LISTENED]->(t)
SET l.plays = toInteger(row.plays), l.rating = toInteger(row.rating);

LOAD CSV WITH HEADERS FROM 'file:///follows.csv' AS row
MATCH (u:User {id: toInteger(row.userId)})
MATCH (a:Artist {id: toInteger(row.artistId)})
MERGE (u)-[:FOLLOWS]->(a);
