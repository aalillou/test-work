ARG APP_IMAGE=node:18.7.0-alpine3.16
FROM $APP_IMAGE

USER root

RUN apk -U upgrade

RUN adduser -h /home/jenkins -D -u 1001 jenkins 
RUN mkdir -p /home/jenkins/.config
RUN mkdir -p /home/jenkins/.npm
RUN chown -R jenkins:jenkins /home/jenkins/.config
RUN chown -R jenkins:jenkins /home/jenkins/.npm
    
USER jenkins

CMD [ "npm", "start" ]

ENV TZ=Europe/Brussels
EXPOSE 80
