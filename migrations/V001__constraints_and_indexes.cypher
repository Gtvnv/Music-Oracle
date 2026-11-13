// V001 - Unicity constraints (also create backing indexes) and extra indexes.
// Constraints make every later LOAD CSV idempotent through MERGE.
CREATE CONSTRAINT artist_id IF NOT EXISTS FOR (n:Artist) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT album_id  IF NOT EXISTS FOR (n:Album)  REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT track_id  IF NOT EXISTS FOR (n:Track)  REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT genre_id  IF NOT EXISTS FOR (n:Genre)  REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT user_id   IF NOT EXISTS FOR (n:User)   REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT genre_name IF NOT EXISTS FOR (n:Genre) REQUIRE n.name IS UNIQUE;
CREATE INDEX artist_name IF NOT EXISTS FOR (n:Artist) ON (n.name);
CREATE INDEX track_title IF NOT EXISTS FOR (n:Track) ON (n.title);
