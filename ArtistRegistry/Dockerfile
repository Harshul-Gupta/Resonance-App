FROM openjdk:28-ea-jdk
WORKDIR /resonance
COPY target/ArtistRegistry-0.0.1-SNAPSHOT.war Resonance.war
ENTRYPOINT [ "java", "-jar", "Resonance.war", "--server.port=8080" ]