// ---------------------------------------------------------------------------
// Q1. What are the most played tracks overall?
// ---------------------------------------------------------------------------
MATCH (:User)-[l:LISTENED]->(t:Track)<-[:CONTAINS]-(al:Album)<-[:RELEASED]-(a:Artist)
RETURN t.title AS track, a.name AS artist, sum(l.plays) AS totalPlays
ORDER BY totalPlays DESC
LIMIT 5;

// ---------------------------------------------------------------------------
// Q2. Which genres are best rated, and by how many listeners?
// ---------------------------------------------------------------------------
MATCH (u:User)-[l:LISTENED]->(:Track)-[:HAS_GENRE]->(g:Genre)
RETURN g.name AS genre, round(avg(l.rating), 2) AS avgRating,
       count(DISTINCT u) AS listeners, sum(l.plays) AS plays
ORDER BY avgRating DESC, plays DESC;

// ---------------------------------------------------------------------------
// Q3. Recommendation (collaborative filtering): what should Ana hear next?
// Tracks loved (rating >= 4) by users who share loved tracks with Ana,
// excluding what Ana already heard.
// ---------------------------------------------------------------------------
MATCH (me:User {name: 'Ana'})-[:LISTENED]->(:Track)<-[:LISTENED]-(peer:User)
WHERE peer <> me
WITH me, peer, count(*) AS sharedTracks
MATCH (peer)-[l:LISTENED]->(rec:Track)
WHERE l.rating >= 4 AND NOT (me)-[:LISTENED]->(rec)
RETURN rec.title AS recommendation, sum(sharedTracks) AS score,
       collect(DISTINCT peer.name) AS recommendedBy
ORDER BY score DESC, recommendation
LIMIT 5;

// ---------------------------------------------------------------------------
// Q4. Influence chains: whom did Pink Floyd influence, directly or indirectly?
// ---------------------------------------------------------------------------
MATCH path = (:Artist {name: 'Pink Floyd'})-[:INFLUENCED*1..3]->(b:Artist)
RETURN b.name AS influenced, length(path) AS hops,
       [n IN nodes(path) | n.name] AS chain
ORDER BY hops, influenced;

// ---------------------------------------------------------------------------
// Q5. Which artists are genre bridges (tracks in more than one genre)?
// ---------------------------------------------------------------------------
MATCH (a:Artist)-[:RELEASED]->(:Album)-[:CONTAINS]->(:Track)-[:HAS_GENRE]->(g:Genre)
WITH a, collect(DISTINCT g.name) AS genres
WHERE size(genres) > 1
RETURN a.name AS artist, genres
ORDER BY size(genres) DESC, artist;

// ---------------------------------------------------------------------------
// Q6. Collaboration map: which tracks have guest artists?
// ---------------------------------------------------------------------------
MATCH (main:Artist)-[:RELEASED]->(:Album)-[:CONTAINS]->(t:Track)-[:FEATURES]->(guest:Artist)
RETURN t.title AS track, main.name AS mainArtist, guest.name AS guest
ORDER BY track;

// ---------------------------------------------------------------------------
// Q7. Discovery by influence: artists influenced by someone a user follows
// that the user does not follow yet (example: Carla).
// ---------------------------------------------------------------------------
MATCH (u:User {name: 'Carla'})-[:FOLLOWS]->(src:Artist)-[:INFLUENCED]->(suggested:Artist)
WHERE NOT (u)-[:FOLLOWS]->(suggested)
RETURN suggested.name AS suggestedArtist, collect(src.name) AS because;

// ---------------------------------------------------------------------------
// Q8. Which artist origin countries does each listener country play most?
// ---------------------------------------------------------------------------
MATCH (u:User)-[l:LISTENED]->(:Track)<-[:CONTAINS]-(:Album)<-[:RELEASED]-(a:Artist)
RETURN u.country AS listenerCountry, a.country AS artistCountry, sum(l.plays) AS plays
ORDER BY listenerCountry, plays DESC;

// ---------------------------------------------------------------------------
// Q9. Total listening time (hours) per user.
// ---------------------------------------------------------------------------
MATCH (u:User)-[l:LISTENED]->(t:Track)
RETURN u.name AS user, round(sum(l.plays * t.durationSec) / 3600.0, 1) AS hours
ORDER BY hours DESC;

// ---------------------------------------------------------------------------
// Q10. Whole-graph view for screenshots (Neo4j Browser).
// ---------------------------------------------------------------------------
MATCH p = (:Artist)-[:RELEASED]->(:Album)-[:CONTAINS]->(:Track)-[:HAS_GENRE]->(:Genre)
RETURN p LIMIT 60;

