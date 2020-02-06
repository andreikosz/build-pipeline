FROM openjdk:11
RUN mkdir -p ~/java-app
ADD /java-vm-deploy /java-app
WORKDIR /java-app
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar ./build/libs/spring-boot-app.jar"]
