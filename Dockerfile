# Base image
FROM openjdk:8

# Base system dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y \
    curl \
    git \
    tar \
  && rm -rf /var/lib/apt/lists/*

# Application server
RUN mkdir /application
WORKDIR /application
RUN curl --output /application/dynamodb.tar.gz https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz \
  && tar --extract --gzip --verbose --file /application/dynamodb.tar.gz

# Expose ports
EXPOSE 8000

# Healthcheck
ADD ./docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck
HEALTHCHECK CMD docker-healthcheck

# Startup
ENTRYPOINT ["java"]
CMD ["-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar", "-dbPath", "/data", "-sharedDb"]
