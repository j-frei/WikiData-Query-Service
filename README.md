# Wikidata Query Service as Standalone

The aim is to setup and host a local standalone instance of the Wikidata query interface. The online instance is available at: https://query.wikidata.org/  

The main limitation of the online instance concerns the restrictive request timeout policy. Thus, the online instance makes it impossible to be used for OpenTapioca in case of large entity data queries.  

The steps are based on the official guide from the following webpage: https://www.mediawiki.org/wiki/Wikidata_Query_Service/User_Manual#Standalone_service.

## How to Use

### Using Single Script
**Note: This approach is deprecated!**  
Use the dockerized approach instead!  

Given a Ubuntu 18.04 instance, you need to run the script `main_create_instance.sh` in `single_script`:
```bash
cd single_script
./main_create_instance.sh
```

### Using Docker
Lookup [dockerized/README.md](dockerized/README.md)

Old:  
<details>
Start the server using Docker:
```bash
cd dockerized
# Start the Blazegraph service
docker-compose up -d
# Now, the Blazegraph service should be running...  
```

We can run the loading scripts in a prepared environment (the wikidata-loader container)
```bash
cd dockerized
docker-compose run wikidata-loader bash
# Entering Docker container...
./01-04_runAll.sh
```
</details>

#### Import Existing Wikidata File
```bash
import_file="./wikidata.jnl"
wikidata_container="wikidata_query-service_1"
# Copy file
docker cp $import_file ${wikidata_container}:/wikidata/service/wikidata.jnl
# Restart container
docker restart $wikidata_container
```

#### Export Wikidata File
```bash
export_path="./wikidata.jnl"
wikidata_container="wikidata_query-service_1"
# Copy file
docker cp ${wikidata_container}:/wikidata/service/wikidata.jnl $export_path
```