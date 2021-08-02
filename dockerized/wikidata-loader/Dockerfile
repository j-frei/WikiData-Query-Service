# This image is similar to wikidata-query-service.
# However, we keep the duplicate steps to decouple the development steps
# The default CMD should be /bin/bash, not the blazegraph server

# Build blazegraph package
FROM maven:3-openjdk-8 as mvn_builder
WORKDIR /wdt

# Remove blocked HTTP mirrors
RUN sed -e '159,165d' $MAVEN_HOME/conf/settings.xml

# Clone source code
RUN git clone https://github.com/wikimedia/wikidata-query-rdf wikidata-query-rdf
# [OPTIONAL] Fix version
#RUN cd ./wikidata-query-rdf && git checkout 209746cb

# Compile files and only extract/keep compiled package
RUN cd ./wikidata-query-rdf && mvn package
RUN mv ./wikidata-query-rdf/dist/target/service-*-dist.tar.gz ./service-dist.tar.gz && \
        rm -rf ./wikidata-query-rdf


# Runtime stage
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
       git tar wget curl \
       openjdk-8-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Prepare
RUN mkdir -p /wikidata
WORKDIR /wikidata

# Import from build
COPY --from=mvn_builder /wdt/service-dist.tar.gz /wikidata/service-dist.tar.gz

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
       git tar wget curl \
       openjdk-8-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Extract compiled data
RUN mkdir -p "./service_tmp" && tar -C "./service_tmp" -xvf "./service-dist.tar.gz" && \
        mv "./service_tmp/$(ls ./service_tmp)" "./service" && rm -rf "./service_tmp"

# Add user scripts
RUN mkdir -p /wikidata/data
COPY scripts/scripts/utils.sh /wikidata/utils.sh
COPY scripts/01-04_runAll.sh /wikidata/01-04_runAll.sh
COPY scripts/01_downloadData.sh /wikidata/01_downloadData.sh
COPY scripts/02_preprocessData.sh /wikidata/02_preprocessData.sh
COPY scripts/03_loadData.sh /wikidata/03_loadData.sh
COPY scripts/04_runUpdate.sh /wikidata/04_runUpdate.sh
COPY scripts/05_enableRunUpdateLoop.sh /wikidata/05_enableRunUpdateLoop.sh

# Additional steps for data loading
COPY waitForBlazegraph.sh /waitForBlazegraph.sh
COPY updateScript.sh /updateScript.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/sleep", "infinity"]
