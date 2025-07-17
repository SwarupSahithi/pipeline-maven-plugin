# === Stage 1: Builder ===
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build plugin (skip tests)
RUN mvn clean package -DskipTests

# === Stage 2: Artifact extractor ===
FROM busybox AS extractor
WORKDIR /out
COPY --from=builder /app/target/*.hpi .
COPY --from=builder /app/target/*.jar .

# === Stage 3: Final runner (optional) ===
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=extractor /out .
CMD ["sh", "-c", "ls -l /app"]
