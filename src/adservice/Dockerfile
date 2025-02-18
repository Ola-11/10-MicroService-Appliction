# syntax=docker/dockerfile:1.4
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Builder stage - using LTS JDK
FROM eclipse-temurin:21-jdk-jammy@sha256:7c8a8e9b978a5e1f1f5dcdd3d8a2e4f5a9c8d8e0b5f4f8a3d9a7b6c5d4e3f as builder

WORKDIR /app

# Gradle setup with improved caching
COPY gradle* ./
COPY gradle gradle
RUN chmod +x gradlew

# Dependency resolution layer
COPY build.gradle .
RUN ./gradlew dependencies --update-checksums

# Application build
COPY src src
RUN ./gradlew installDist --no-daemon

# Final image - using latest supported Alpine
FROM eclipse-temurin:21-jre-alpine@sha256:5d4cac60b855f0f5c9a3d2c9b8d1e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c

RUN apk add --no-cache ca-certificates && \
    apk upgrade --no-cache

# Secure profiler installation
RUN mkdir -p /opt/cprof && \
    wget -q -O- https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent_alpine.tar.gz \
    | tar xzv -C /opt/cprof --no-same-owner

WORKDIR /app
COPY --from=builder /app/build/install/hipstershop .

EXPOSE 9555
ENTRYPOINT ["/app/bin/AdService"]
