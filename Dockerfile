# Stage 1: Build the Jenkins plugin with Maven + JDK 17
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy POM and source code
COPY pom.xml .
COPY src ./src

# Build the plugin without tests
RUN mvn clean package -DskipTests

# Stage 2: (Optional) Extract only the JAR if needed for other uses
FROM busybox:1.36.1-glibc AS extractor
WORKDIR /out
COPY --from=build /app/target/*.hpi .
COPY --from=build /app/target/*.jar .  # include any additional artifacts

# Stage 3: Runtime environment (if you're using this plugin in an application container)
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy plugin artifact
# Adjust this as needed depending on where/how you deploy your plugin
COPY --from=extractor *.hpi ./*.jar ./

# Example entrypoint; modify based on your actual usage:
CMD ["sh", "-c", "ls -l /app"]
