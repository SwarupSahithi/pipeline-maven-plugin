FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app

# Copy the settings.xml so Maven can access snapshot repos
COPY settings.xml /root/.m2/settings.xml

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM busybox AS extractor
WORKDIR /out
COPY --from=builder /app/target/*.hpi .
COPY --from=builder /app/target/*.jar .

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=extractor /out .
CMD ["sh", "-c", "ls -l /app"]
