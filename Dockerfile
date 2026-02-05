# ========================
# Build Stage
# ========================
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /build

# Copy backend Maven project (nested structure)
COPY Backend/todo-summary-assistant/pom.xml ./pom.xml
COPY Backend/todo-summary-assistant/src ./src

# Build plain JAR (no executable main class)
RUN mvn clean package

# ========================
# Runtime Stage
# ========================
FROM eclipse-temurin:17-jre

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy built JAR
COPY --from=builder /build/target/*.jar app.jar

# Set permissions
RUN chown -R appuser:appuser /app

USER appuser

# No executable main class → documented runtime behavior
CMD ["sh", "-c", "echo 'Container built successfully (no executable main class defined)' && sleep infinity"]

