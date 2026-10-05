FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /build
COPY src ./src
RUN mkdir classes && javac --release 21 -d classes src/pattern/*.java && \
    jar --create --file app.jar --main-class pattern.WelcomeServer -C classes .

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /build/app.jar ./app.jar
USER 10001:10001
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
