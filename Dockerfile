# Stage 1: build plugin with Maven 3.8.5 + JDK 17
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app

# Optional: include custom settings.xml for Jenkins ext-repos
# COPY settings.xml /root/.m2/settings.xml

# Copy only what's needed to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 2: runtime base (slim JDK)
FROM openjdk:17-jdk-slim AS runtime
WORKDIR /app

# Copy built plugin artifact (HPI or JAR)
COPY --from=builder /app/target/*.hpi . 
# Optionally also copy JAR if your packaging produces one:
# COPY --from=builder /app/target/*.jar .

CMD ["sh", "-c", "echo 'Artifacts in /app:' && ls -1 /app"]
