# WikiData Blazegraph Query Endpoint

This `docker-compose`-setup provides a WikiData Blazegraph query endpoint service including the preparation and update scripts.

## How to Run
Launch the docker-compose project with a given prefix:
```bash
# Run containers with "wikidata_" prefix
docker-compose -p "wikidata" up -d

# [Choice 1] Trigger scripts
docker-compose -p "wikidata" exec loader "./01-04_runAll.sh"

# [Choice 2] Trigger scripts manually
# Service is available after ./03_loadData.sh
docker-compose -p "wikidata" exec loader "./01_downloadData.sh"
docker-compose -p "wikidata" exec loader "./02_preprocessData.sh"
docker-compose -p "wikidata" exec loader "./03_loadData.sh"
docker-compose -p "wikidata" exec loader "./04_runUpdate.sh"

# Enable update loop
docker-compose -p "wikidata" exec loader "./05_enablerunUpdateLoop.sh"
docker-compose -p "wikidata" restart loader