ARG APP_IMAGE=amazoncorretto:17-alpine-jdk
FROM $APP_IMAGE

USER root

RUN apk -U upgrade && \
    adduser -h /home/jenkins -D -u 1000 jenkins


USER jenkins
WORKDIR /home/jenkins

ENV TZ=Europe/Brussels
