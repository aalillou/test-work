ARG APP_IMAGE=jenkins/inbound-agent:latest
FROM $APP_IMAGE

USER root
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
    jq \
    zip \
    curl \
    netcat \
    python3 \
    python3-pip \
    less \
    groff && \
    pip3 install --upgrade pip &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip --no-cache-dir install --upgrade awscli anchorecli


COPY anchore-report /home/jenkins/anchore-report
RUN chown -R jenkins: /home/jenkins/anchore-report

COPY config/ssh_config  /etc/ssh/ssh_config

USER jenkins

RUN cd /home/jenkins/anchore-report && \
    python3 -m pip --no-cache-dir install -r requirements.txt
ENV TZ=Europe/Brussels
