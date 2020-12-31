# This image is similar to wikidata-query-service.
# However, we keep the duplicate steps to decouple the development steps
# The default CMD should be /bin/bash, not the blazegraph server
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
       git tar wget curl \
       openjdk-8-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Install Maven (we need to keep this postponed to avoid Java 11 to be installed separately)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
       maven \
    && rm -rf /var/lib/apt/lists/*

# Set Java Home ENV variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

# Create working directory
RUN mkdir -p /wikidata
WORKDIR /wikidata

# Clone wikidata query source code
RUN git clone https://github.com/wikimedia/wikidata-query-rdf wikidata-query-rdf
RUN cd ./wikidata-query-rdf && git checkout 209746cb

# Compile files and only extract/keep compiled package
RUN cd ./wikidata-query-rdf && mvn package
RUN mv ./wikidata-query-rdf/dist/target/service-*-dist.tar.gz ./service-dist.tar.gz && \
        rm -rf ./wikidata-query-rdf

# Extract compiled data
RUN mkdir -p "./service_tmp" && tar -C "./service_tmp" -xvf "./service-dist.tar.gz" && \
        mv "./service_tmp/$(ls ./service_tmp)" "./service" && rm -rf "./service_tmp"

# Additional steps for data loading
COPY waitForBlazegraph.sh /wikidata/waitForBlazegraph.sh
RUN mkdir -p /wikidata/data

COPY utils.sh /wikidata/utils.sh
COPY 01-04_runAll.sh /wikidata/01-04_runAll.sh
COPY 01_downloadData.sh /wikidata/01_downloadData.sh
COPY 02_preprocessData.sh /wikidata/02_preprocessData.sh
COPY 03_loadData.sh /wikidata/03_loadData.sh
COPY 04_runUpdate.sh /wikidata/04_runUpdate.sh
