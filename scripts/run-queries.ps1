<#
 Runs the business queries against the running container and stores the output
 in docs/query-results.txt (used as evidence in the README).
 The last query (whole-graph view) is skipped: it is meant for Neo4j Browser.
#>
param(
    [string]$Container = 'music-oracle-neo4j',
    [string]$OutFile = "$PSScriptRoot/../docs/query-results.txt"
)

$envFile = Join-Path $PSScriptRoot '../.env'
$cfg = @{}
Get-Content $envFile | Where-Object { $_ -match '^\s*[^#].*=' } | ForEach-Object {
    $k, $v = $_ -split '=', 2; $cfg[$k.Trim()] = $v.Trim()
}

$queries = Get-Content (Join-Path $PSScriptRoot '../queries/business_queries.cypher') -Raw
$queries = ($queries -split '// Q10\.')[0]
$queries = $queries -replace '(?s)// -+\s*$', ''

$queries | docker exec -i $Container cypher-shell -u $cfg.NEO4J_USER -p $cfg.NEO4J_PASSWORD --format plain |
    Out-File $OutFile -Encoding utf8
Write-Host "Saved $OutFile"
