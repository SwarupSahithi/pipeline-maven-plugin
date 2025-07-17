# Stage 1: Builder – compiles the plugin
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app

# Include settings.xml if using snapshots (must exist alongside Dockerfile)
# COPY settings.xml /root/.m2/settings.xml

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Extractor – grabs the built artifacts
FROM busybox AS extractor
WORKDIR /out
COPY --from=builder /app/target/*.hpi .
COPY --from=builder /app/target/*.jar .

# Stage 3: Final – minimal runtime image
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=extractor /out .
CMD ["sh", "-c", "ls -l /app"]
