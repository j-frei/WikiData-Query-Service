# WikiData Blazegraph Query Endpoint

This `docker-compose`-setup provides an WikiData Blazegraph query endpoint service including the preparation and update scripts.

## How to Run
Launch the docker-compose project with a given prefix:
```bash
# Run containers with "wikidata_" prefix
docker-compose -p "wikidata" up -d

# [Choice 1] Trigger scripts
docker-compose exec "./01-04_runAll.sh"

# [Choice 2] Trigger scripts manually
docker-compose exec "./01_downloadData.sh"
docker-compose exec "./02_preprocessData.sh"
docker-compose exec "./03_loadData.sh"
docker-compose exec "./04_runUpdate.sh"

# Enable update loop
docker-compose exec "./05_enablerunUpdateLoop.sh"