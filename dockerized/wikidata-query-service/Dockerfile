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

# Set Java Home Env
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

# Create working directory
RUN mkdir -p /wikidata
WORKDIR /wikidata

# Clone wikidata query source code
RUN git clone https://github.com/wikimedia/wikidata-query-rdf wikidata-query-rdf
RUN cd ./wikidata-query-rdf && git checkout b7ea4f1

# Compile files and only extract/keep compiled package
RUN cd ./wikidata-query-rdf && mvn package

RUN mv ./wikidata-query-rdf/dist/target/service-*-dist.tar.gz ../service-dist.tar.gz && \
        cd .. && rm -rf ./wikidata-query-rdf

# Extract compiled data
RUN tar -C "./service_tmp" -xvf "./service-dist.tar.gz" && \
        mv "./service_tmp/$(ls ./service_tmp)" "./service" && rm -rf "./service_tmp"

CMD ["sh", "-c", "HOST=0.0.0.0 ./service/Blazegraph.sh"]
EXPOSE 9999
