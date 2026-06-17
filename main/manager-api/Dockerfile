FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /build

COPY pom.xml ./
COPY src ./src

RUN mvn -B -DskipTests clean package

FROM eclipse-temurin:21-jre-jammy

ENV TZ=UTC \
    SPRING_PROFILES_ACTIVE=dev

WORKDIR /opt/manager-api

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /uploadfile

COPY --from=build /build/target/xiaozhi-esp32-api.jar ./app.jar

EXPOSE 8002

VOLUME ["/uploadfile"]

ENTRYPOINT ["java", "-jar", "/opt/manager-api/app.jar"]
