#!/bin/bash

old_cwd=$(pwd)
cd $(dirname "$0")

# Check last command and remove file if given
checkSuccess() {
    if [ $1 -eq 0 ]; then 
        echo "...succeeded."
    else
        echo -n "...but execution FAILED!"
        if [ ! -z $2 ]; then
            if [ -f $2 ]; then
                echo -n " -> delete file: $2"
                rm $2
            fi
            if [ -d $2 ]; then
                echo -n " -> delete directory: $2"
                rm -r $2
            fi
        fi
        echo ""
        exit -1
    fi
}

# Add logs directory
mkdir -p logs

# Set JAVA_HOME
JAVA_HOME_default=$(readlink -m $(which java)/../..)
export JAVA_HOME=${JAVA_HOME:-"$JAVA_HOME_default"}

if [ ! -d ".deps_installed" ]; then
    echo "Ensuring dependencies..."
    ./sub_setup_deps.sh > ./logs/log_dependencies.txt 2>&1
    checkSuccess $?
    touch .deps_installed
fi

if [ ! -d "./wikidata-query-rdf" ]; then
    echo "Cloning wikidata-query-rdf repository..."
    git clone https://github.com/wikimedia/wikidata-query-rdf  > ./logs/log_clone_query_rdf.txt 2>&1
    checkSuccess $?
    cd wikidata-query-rdf
    echo "Selecting commit..."
    git checkout 209746cb42f58ca404bd4e0bd6206940484abd3b
    checkSuccess $?
    cd ..
fi

ls "./wikidata-query-rdf/dist/target/service-*-dist.tar.gz" 1>/dev/null 2>&1
dist_exists=$?
if [ $dist_exists -eq 0 ]; then
    echo "Compiling repository content..."
    cd wikidata-query-rdf
    mvn package  > ./logs/log_maven_package.txt 2>&1
    checkSuccess $?
    cp ./wikidata-query-rdf/dist/target/service-*-dist.tar.gz ./service-dist.tar.gz
    cd ..
fi

if [ ! -d "./service" ]; then
    echo "Extracting dist package..."
    mkdir "./service_tmp"
    tar -C "./service_tmp" -xvf "./service-dist.tar.gz"
    checkSuccess $?
    echo "Rearrange directory data"
    mv "./service_tmp/$(ls ./service_tmp)" "./service"
    checkSuccess $?
    rm -rf "./service_tmp"    
fi

# Download Wikipedia dump 
if [ ! -f ./data/latest-all.ttl.gz ]; then
    mkdir -p ./data
    echo "Downloading Wikipedia RDF dump..."
    dump_url="https://dumps.wikimedia.org/wikidatawiki/entities/latest-all.ttl.gz"
    curl -X HEAD -I -s $dump_url >> ./data/latest-all.ttl.gz.header.txt
    checkSuccess $? ./data/latest-all.ttl.gz.header.txt
    wget --directory-prefix=./data -q --show-progress $dump_url
    checkSuccess $? ./data/latest-all.ttl.gz
else
    echo "Wikipedia dump already downloaded."
fi


# Preprocessing with munge.sh 
if [ ! -d ./data/preprocessed ]; then
    mkdir -p ./data/preprocessed
    echo "Run preprocessing with munge.sh..."
    ./service/munge.sh -f ./data/latest-all.ttl.gz -d ./data/preprocessed -l de  > ./logs/log_munge_preprocessing.txt 2>&1
    checkSuccess $? ./data/preprocessed
else
    echo "Preprocessing with munge.sh already performed."
fi


# check whether server is running...
if curl -Is http://localhost:9999/bigdata 2>/dev/null | grep "HTTP/1.1" 1>/dev/null; then
    # Page is up and running!
    echo "Server 'http://localhost:9999/bigdata' is available"
else
    # Server is not running...
    echo -n "Server is not running... Starting server now..."
    nohup 2>&1 sh -c "HOST=0.0.0.0 ./service/runBlazegraph.sh" &>./service/blazegraph.log &
    echo -n "Server started -> Wait 10 secs until availability check..."
    sleep 10
    echo -n "Checking availability..."
    curl -Is http://localhost:9999/bigdata 2>/dev/null | grep "HTTP/1.1" 1>/dev/null
    checkSuccess $?
fi
 

# Data loading with loadData.sh 
if [ ! -f ./data/.loadingData ]; then
    echo "Run data loading with loadData.sh..."
    ./service/loadData.sh -n wdq -d ./data/preprocessed > ./logs/log_loadData 2>&1
    checkSuccess $?
    touch ./data/.loadingData
else
    echo "Data loading with loadData.sh already performed."
fi