// V003 - Relationships between artists and tracks.

// Guest artists on tracks
LOAD CSV WITH HEADERS FROM 'file:///features.csv' AS row
MATCH (t:Track {id: toInteger(row.trackId)})
MATCH (a:Artist {id: toInteger(row.artistId)})
MERGE (t)-[:FEATURES]->(a);

// Artistic influence (curated, illustrative sample)
LOAD CSV WITH HEADERS FROM 'file:///influences.csv' AS row
MATCH (a:Artist {id: toInteger(row.artistId)})
MATCH (b:Artist {id: toInteger(row.influencedId)})
MERGE (a)-[:INFLUENCED]->(b);
