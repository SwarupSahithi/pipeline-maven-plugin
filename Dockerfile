# Use an OpenJDK base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled JAR file from the host to the container
COPY target/*.jar app.jar

# Expose the port the application will run on
EXPOSE 8080

# Define the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
