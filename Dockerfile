
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /build
COPY Backend/todo-summary-assistant/pom.xml ./pom.xml
COPY Backend/todo-summary-assistant/src ./src
RUN mvn clean package
FROM eclipse-temurin:17-jre
RUN useradd -m appuser
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
RUN chown -R appuser:appuser /app
USER appuser
CMD ["sh", "-c", "echo 'Container built successfully (no executable main class defined)' && sleep infinity"]

