# == STAGE 1: Build with Maven ==
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# Add Maven settings to access Jenkins releases/snapshots
COPY settings.xml /root/.m2/settings.xml

# Copy project POM and fetch all dependencies (including missing jenkins-war)
COPY pom.xml ./
RUN mvn dependency:go-offline -B

# Copy source and compile/plugin package
COPY src ./src
RUN mvn clean package -DskipTests -B

# == STAGE 2: Extract artifacts ==
FROM busybox AS extractor
WORKDIR /out
COPY --from=builder /app/target/*.hpi . || true
COPY --from=builder /app/target/*.jar . || true

# == STAGE 3: Production runtime image (optional) ==
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=extractor /out/ ./
CMD ["java", "-jar", "pipeline-maven-plugin.hpi"]
