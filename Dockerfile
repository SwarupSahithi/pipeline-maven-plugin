# Stage 1: build
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app

# Ensure Jenkins releases are accessible
COPY settings.xml /root/.m2/settings.xml

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: extract artifact
FROM openjdk:17-jdk-slim AS extractor
WORKDIR /out
COPY --from=builder /app/target/*.hpi . || true
COPY --from=builder /app/target/*.jar . || true

# Final runtime image
FROM busybox:latest
WORKDIR /plugin
COPY --from=extractor /out/* . 
