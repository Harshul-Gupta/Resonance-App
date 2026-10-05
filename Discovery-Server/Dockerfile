FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /resonance
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Ultra-lightweight runtime environment
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app
COPY --from=build /resonance/target/*.jar Resonance.jar
EXPOSE 8080 8761 9092
ENTRYPOINT [ "java", "-jar", "Resonance.jar"]
