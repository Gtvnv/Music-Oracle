// V002 - Music catalog: Genre, Artist, Album, Track.
// Files are read from Neo4j's import directory (./data is mounted there).

// Genres
LOAD CSV WITH HEADERS FROM 'file:///genres.csv' AS row
MERGE (g:Genre {id: toInteger(row.id)})
SET g.name = row.name;

// Artists
LOAD CSV WITH HEADERS FROM 'file:///artists.csv' AS row
MERGE (a:Artist {id: toInteger(row.id)})
SET a.name = row.name, a.country = row.country, a.formed = toInteger(row.formed);

// Albums and (Artist)-[:RELEASED]->(Album)
LOAD CSV WITH HEADERS FROM 'file:///albums.csv' AS row
MATCH (a:Artist {id: toInteger(row.artistId)})
MERGE (al:Album {id: toInteger(row.id)})
SET al.title = row.title, al.year = toInteger(row.year)
MERGE (a)-[:RELEASED]->(al);

// Tracks, (Album)-[:CONTAINS]->(Track) and (Track)-[:HAS_GENRE]->(Genre)
LOAD CSV WITH HEADERS FROM 'file:///tracks.csv' AS row
MATCH (al:Album {id: toInteger(row.albumId)})
MATCH (g:Genre {id: toInteger(row.genreId)})
MERGE (t:Track {id: toInteger(row.id)})
SET t.title = row.title, t.durationSec = toInteger(row.durationSec)
MERGE (al)-[:CONTAINS]->(t)
MERGE (t)-[:HAS_GENRE]->(g);
