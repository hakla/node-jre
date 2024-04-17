# node-jre

This is a simple merge of the [node](https://hub.docker.com/_/node):20-alpine and the [adoptopenjdk](https://hub.docker.com/_/adoptopenjdk?tab=description):11-jre-hotspot docker images to provide a minimal environment where node and a jre are available.

The following Dockerfiles have been used to create the Dockerfile of this image:

- [node](https://github.com/nodejs/docker-node/blob/d9c01570c0f72a40cbaece69c378d7c8187c56e9/20/alpine3.17/Dockerfile)
- [adoptopenjdk](https://github.com/AdoptOpenJDK/openjdk-docker/blob/828f553e6df0ba9340eb4bcd52a1fbe4dc9499f0/11/jdk/alpine/Dockerfile.hotspot.releases.full)

## Use the pre-built image

The pre-built image can be downloaded using Docker.

docker pull hakla/node-jre

## Build the Docker image yourself

You can also adjust and build the image according to your needs. Just clone the repository and then execute the build command.

docker build -t hakla/node-jre .

## Versions

The following versions are used by this image (as defined in the original images):

- NODE_VERSION=18.16.1
- YARN_VERSION=1.22.19
- JAVA_VERSION=jdk-11.0.11+9
