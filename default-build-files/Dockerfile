FROM openjdk:11
RUN mkdir -p ~/java-app
ADD /java-vm-deploy /java-app
WORKDIR /java-app
ENTRYPOINT ["sh", "-c"]
RUN chmod +x ./build/libs/spring-boot-app.jar
RUN ls .
