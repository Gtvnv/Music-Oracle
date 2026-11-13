# Prints do Neo4j Browser

Capturas usadas no README: `catalogo.png`, `influencias.png`, `recomendacao.png` e `schema.png`.

Foram geradas automaticamente (Playwright + Chromium headless) contra o banco local
criado pelas migrations. Para refazer manualmente, rode no Neo4j Browser
(http://localhost:7474): a Q10 e a Q4 de `queries/business_queries.cypher`,
`CALL db.schema.visualization()` e a variante em caminho da Q3 (`RETURN p`).
