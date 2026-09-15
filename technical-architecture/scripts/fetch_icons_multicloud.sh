#!/usr/bin/env sh
# Icons for the non-AWS clouds and the data platforms, fetched into examples/icons/.
#
# Three sources, because the vendors publish very differently:
#
#   azure/  Microsoft's official Azure Architecture Icons package. One zip, ~670 service
#           SVGs named `NNNNN-icon-service-<Name>.svg`. The URL carries a version (V19 at the
#           time of writing); pass a newer one as $1 when Microsoft publishes it.
#   gcp/    Google gates its own zip behind a click-through, so these come from the diagrams
#           project's mirror of the official set (PNG, transparent, ~1000px).
#   root    Product marks (Snowflake, Airflow, dbt, Kafka...) from Simple Icons, which is
#           where the AWS-era script already gets Grafana, Docker and the rest.
#
# Simple Icons dropped every Microsoft-owned mark over trademark policy, so there is no
# `azure.svg` brand glyph here; use a service icon from azure/ instead.
#
# SAP publishes no architecture icon set at all — only the corporate mark (sap.svg) and a UI
# icon font (Fiori), which is not the same thing. Draw SAP systems as labelled boxes with the
# brand mark, never an invented per-product glyph.
set -eu
cd "$(dirname "$0")/../examples/icons"

# Capture the optional Azure pack URL now: the GCP section below uses `set --`, which
# overwrites the positional parameters.
AZURE_PACK="${1:-https://arch-center.azureedge.net/icons/Azure_Public_Service_Icons_V24.zip}"

echo "product marks (Simple Icons)"
for s in snowflake apacheairflow databricks apachespark apachekafka apacheflink apachehadoop \
         kubernetes terraform looker mongodb redis elasticsearch mysql duckdb clickhouse neo4j \
         googlecloud sap; do
  curl -sfL -m 30 -o "$s.svg" "https://cdn.simpleicons.org/$s" || echo "  MISSING $s"
done

echo "google cloud service icons (official set, mirrored)"
mkdir -p gcp
GCP_BASE="https://raw.githubusercontent.com/mingrammer/diagrams/master/resources/gcp"
# category/name  ->  gcp/<short>.png
set -- \
  "analytics/bigquery:bigquery" "analytics/dataflow:dataflow" "analytics/pubsub:pubsub" \
  "analytics/composer:composer" "analytics/dataproc:dataproc" "analytics/data-fusion:datafusion" \
  "analytics/looker:looker" \
  "compute/compute-engine:gce" "compute/kubernetes-engine:gke" "compute/run:cloudrun" \
  "compute/functions:functions" "compute/app-engine:appengine" \
  "database/sql:cloudsql" "database/spanner:spanner" "database/firestore:firestore" \
  "database/bigtable:bigtable" "database/memorystore:memorystore" \
  "storage/storage:gcs" "storage/filestore:filestore" \
  "ml/vertex-ai:vertexai" "ml/ai-platform:aiplatform" "ml/automl:automl" \
  "network/load-balancing:lb" "network/virtual-private-cloud:vpc" "network/nat:nat" \
  "network/dns:dns" "network/cdn:cdn" "network/armor:armor" \
  "security/iam:iam" "security/secret-manager:secretmanager" \
  "security/key-management-service:kms" "security/security-command-center:scc" \
  "operations/logging:logging" "operations/monitoring:monitoring" \
  "devtools/build:cloudbuild" "devtools/scheduler:scheduler" "devtools/tasks:tasks" \
  "devtools/container-registry:gcr" "api/api-gateway:apigateway" "api/apigee:apigee" \
  "management/billing:billing"
for pair in "$@"; do
  src=${pair%%:*}; dst=${pair##*:}
  curl -sfL -m 30 -o "gcp/$dst.png" "$GCP_BASE/$src.png" || echo "  MISSING gcp/$dst"
done

echo "azure service icons (official package)"
PACK="$AZURE_PACK"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
if curl -sfL -m 600 -o "$tmp/azure.zip" "$PACK"; then
  unzip -q "$tmp/azure.zip" -d "$tmp/az"
  mkdir -p azure
  # The package names files `NNNNN-icon-service-<Name>.svg`; match on the <Name> part so a
  # renumbered release still resolves.
  az() { # <Name in package> <short name>
    f=$(find "$tmp/az" -name "*icon-service-$1.svg" | head -1)
    [ -n "$f" ] && cp "$f" "azure/$2.svg" || echo "  MISSING azure/$2 ($1)"
  }
  az "Virtual-Machine" vm;               az "App-Services" appservice
  az "Function-Apps" functions;          az "Kubernetes-Services" aks
  az "Container-Instances" aci;          az "Container-Registries" acr
  az "SQL-Database" sqldb;               az "Azure-Cosmos-DB" cosmosdb
  az "Azure-Database-PostgreSQL-Server" postgres
  az "Storage-Accounts" storage;         az "Data-Lake-Storage-Gen1" datalake
  az "Data-Factories" datafactory;   az "Azure-Synapse-Analytics" synapse
  az "Azure-Databricks" databricks;      az "Event-Hubs" eventhubs
  az "Azure-Service-Bus" servicebus;           az "Machine-Learning" ml
  az "Azure-OpenAI" openai;              az "Cognitive-Services" cognitive
  az "Virtual-Networks" vnet;            az "Load-Balancers" lb
  az "Application-Gateways" appgateway;  az "Firewalls" firewall
  az "Front-Door-and-CDN-Profiles" frontdoor
  az "Key-Vaults" keyvault;              az "Entra-Connect" entra
  az "Monitor" monitor;                  az "Log-Analytics-Workspaces" loganalytics
  az "Application-Insights" appinsights; az "API-Management-Services" apim
  az "Logic-Apps" logicapps;             az "Azure-Data-Explorer-Clusters" dataexplorer
else
  echo "  azure pack unavailable at $PACK (pass a current URL as \$1)"
fi

echo "databricks product icons (official artwork, community-packaged)"
mkdir -p databricks
DB_BASE="https://raw.githubusercontent.com/oieduardorabelo/databricks-architecture-icons/main/icons/svg"
for i in unity-catalog delta-lake ai-functions model-serving mlflow feature-store \
         spark-declarative-pipelines lakeflow lakeflow-jobs databricks-sql sql-warehouse notebooks \
         genie ai-bi-dashboards agent-bricks lakebase \
         clean-rooms marketplace delta-sharing partner-connect \
         auto-loader lakehouse-federation unity-catalog-semantics; do
  curl -sfL -m 30 -o "databricks/$i.svg" "$DB_BASE/$i.svg" || echo "  MISSING databricks/$i"
done

echo "snowflake product icons (Snowflake artwork, unlicensed repo -- see SKILL.md)"
mkdir -p snowflake
SF_BASE="https://raw.githubusercontent.com/sfc-gh-jcrittenden/snowflake-icons/main"
# Data_Engineering is deliberately absent: it is a 411 KB Illustrator illustration, not an icon.
for i in Snowpark Snowpark_Containers Streamlit_in_Snowflake Cortex Horizon \
         Iceberg_Tables Dynamic_Tables Marketplace Native_App \
         Warehouse_Data Warehouse_Gen2 Warehouse_Adaptive Warehouse_Snowpark \
         Security_Governance Sharing_Collaboration Copilot \
         Simplify_Pipelines Snowflake_Trail \
         Security Cloud Analytics; do
  out=$(echo "$i" | tr 'A-Z' 'a-z')
  curl -sfL -m 30 -o "snowflake/$out.svg" "$SF_BASE/Snowflake_ICON_$i.svg" || echo "  MISSING snowflake/$out"
done

echo "done: $(ls *.svg 2>/dev/null | wc -l | tr -d ' ') marks, $(ls gcp/*.png 2>/dev/null | wc -l | tr -d ' ') gcp, $(ls azure/*.svg 2>/dev/null | wc -l | tr -d ' ') azure, $(ls databricks/*.svg 2>/dev/null | wc -l | tr -d ' ') databricks, $(ls snowflake/*.svg 2>/dev/null | wc -l | tr -d ' ') snowflake"
