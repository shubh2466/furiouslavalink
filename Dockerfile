FROM eclipse-temurin:21-jre

WORKDIR /app

# Only what's needed to fetch the jar; keeps the image small.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Pin to a known-good release. Check https://github.com/lavalink-devs/Lavalink/releases
# periodically - YouTube playback support depends on staying reasonably current.
ARG LAVALINK_VERSION=4.2.2
RUN curl -fL \
    -o Lavalink.jar \
    "https://github.com/lavalink-devs/Lavalink/releases/download/${LAVALINK_VERSION}/Lavalink.jar"

COPY application.yml /app/application.yml

EXPOSE 2333

# -XX:+UseContainerSupport lets the JVM correctly read the memory limit Railway
# assigns the container instead of assuming the host's full RAM.
CMD ["java", "-XX:+UseContainerSupport", "-jar", "Lavalink.jar"]
