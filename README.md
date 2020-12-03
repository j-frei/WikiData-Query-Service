# Wikidata Query Service as Standalone

The aim is to setup and host a local standalone instance of the Wikidata query interface. The online instance is available at: https://query.wikidata.org/  

The main limitation of the online instance concerns the restrictive request timeout policy. Thus, the online instance makes it impossible to be used for OpenTapioca in case of large entity data queries.  

The steps are based on the official guide from the following webpage: https://www.mediawiki.org/wiki/Wikidata_Query_Service/User_Manual#Standalone_service.

## How to Use

Given a Ubuntu 18.04 instance, you need to run the script `main_create_instance.sh`:
```bash
./main_create_instance.sh
```  

