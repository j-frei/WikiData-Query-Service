# Build blazegraph package
FROM maven:3-openjdk-8 as mvn_builder
WORKDIR /wdt

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

CMD ["sh", "-c", "HOST=0.0.0.0 ./service/runBlazegraph.sh"]
EXPOSE 9999
