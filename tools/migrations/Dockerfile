# Runner image for Neo4j-Migrations (the "Flyway for Neo4j").
# Built locally because no maintained public image is published for recent releases.
FROM eclipse-temurin:21-jre
ARG VERSION=4.2.2
ARG SHA256=8fc04d7eb06ea47230638d13f1625252aa98b414a747bc5fe358a9696c864e43

RUN apt-get update && apt-get install -y --no-install-recommends unzip curl \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL -o /tmp/nm.zip \
      "https://github.com/michael-simons/neo4j-migrations/releases/download/${VERSION}/neo4j-migrations-${VERSION}.zip" \
 && echo "${SHA256}  /tmp/nm.zip" | sha256sum -c - \
 && unzip -q /tmp/nm.zip -d /opt \
 && chmod +x /opt/neo4j-migrations-${VERSION}/bin/neo4j-migrations \
 && chmod +x /opt/neo4j-migrations-${VERSION}/bin/neo4j-migrations \
 && ln -s /opt/neo4j-migrations-${VERSION}/bin/neo4j-migrations /usr/local/bin/neo4j-migrations \
 && rm /tmp/nm.zip

WORKDIR /migrations
ENTRYPOINT ["neo4j-migrations"]

