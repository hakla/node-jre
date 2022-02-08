# node-jre

This is a simple merge of the [node](https://hub.docker.com/_/node):16-alpine and the [adoptopenjdk](https://hub.docker.com/_/adoptopenjdk?tab=description):11-jre-hotspot docker images to provide a minimal environment where node and a jre are available.

The following Dockerfiles have been used to create the Dockerfile of this image:

- [node](https://github.com/nodejs/docker-node/blob/6bc7fe5d018f2235cdcd2f7681990cee9d096497/13/alpine3.11/Dockerfile)
- [adoptopenjdk](https://github.com/AdoptOpenJDK/openjdk-docker/blob/6ef982afbdd32a0b2195c9ee0fa36328535a3c64/11/jre/alpine/Dockerfile.hotspot.releases.full)

## Use the pre-built image

The pre-built image can be downloaded using Docker.

docker pull hakla/node-jre

## Build the Docker image yourself

You can also adjust and build the image according to your needs. Just clone the repository and then execute the build command.

docker build -t hakla/node-jre .

## Versions

The following versions are used by this image (as defined in the original images):

- NODE_VERSION=16.13.2
- YARN_VERSION=1.22.15
- JAVA_VERSION=jdk-11.0.6+10
