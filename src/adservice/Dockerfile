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

# Use latest LTS version with supported base OS
FROM eclipse-temurin:21-jdk-jammy@sha256:cc459b5c2e48f6b6d5e24eefddb43b23235405b20a53c7d2a0a73fd3d4a1c1d6 as builder

WORKDIR /app

# Copy gradle files first for better caching
COPY ["build.gradle", "gradlew", "gradle.properties", "./"]
COPY gradle gradle
RUN chmod +x gradlew

# Update dependencies first
RUN ./gradlew dependencies --update-checksums

COPY . .
RUN chmod +x gradlew
RUN ./gradlew installDist --refresh-dependencies

# Use non-EOL base image with supported Alpine version
FROM eclipse-temurin:21-jre-alpine@sha256:7a7a0ab6233d03c6dc23d07f6c7c50d5a8f6a7a1d5b8d3e7e8e9c2d8f3e4c5a5

RUN apk add --no-cache ca-certificates && \
    # Add security updates
    apk upgrade --no-cache

# Download Stackdriver Profiler Java agent securely
RUN mkdir -p /opt/cprof && \
    wget -q -O- https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent_alpine.tar.gz \
    | tar xzv -C /opt/cprof --no-same-owner && \
    rm -rf profiler_java_agent.tar.gz

WORKDIR /app
COPY --from=builder /app .

EXPOSE 9555
ENTRYPOINT ["/app/build/install/hipstershop/bin/AdService"]
