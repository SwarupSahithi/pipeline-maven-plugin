# Stage 1: Build with Maven (has JDK 17 + Maven)
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app

# Add settings.xml to access Jenkins snapshots/incrementals
COPY settings.xml /root/.m2/settings.xml

# Copy project files
COPY pom.xml .
COPY src ./src

# Build plugin, skip tests
RUN mvn clean package -DskipTests

# Stage 2: Extract built artifacts
FROM busybox AS extractor
WORKDIR /out
COPY --from=builder /app/target/*.hpi .
COPY --from=builder /app/target/*.jar .

# Stage 3: Lightweight runtime (list artifacts for verification)
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=extractor /out .
CMD ["sh", "-c", "ls -l /app"]
