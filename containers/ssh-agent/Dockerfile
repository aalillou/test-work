FROM ubuntu:focal

ARG newuser=ssh-agent
ARG HELM_VERSION="v3.10.0"

USER root

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install \
    jq wget curl netcat python3 python3-pip \
    docker less sudo vim \
    openssh-server openjdk-17-jdk openjdk-17-jre &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install Helm
RUN wget -c  https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz --no-check-certificate -O - | tar -xz  &&\
    mv linux-amd64/helm /usr/local/bin/helm &&\
    chmod 755 /usr/local/bin/helm &&\
    rm -rf linux-amd64 

# install oc CLI
RUN curl -LO "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.1.0/openshift-client-linux-4.1.0.tar.gz" && \
    tar -zxvf openshift-client-linux-4.1.0.tar.gz &&\ 
    mv oc /usr/local/bin/oc &&\
    chmod 755 /usr/local/bin/oc &&\
    mv kubectl /usr/local/bin/kubectl &&\
    chmod 755 /usr/local/bin/kubectl &&\
    rm *.tar.gz &&\
    python3 -m pip --no-cache-dir install --upgrade awscli anchorecli

# add user for local testing:
# RUN useradd -u 1000 -p "$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)" -g root -d /home/ssh-agent -s /bin/sh ${newuser} &&\

RUN mkdir -p /home/ssh-agent/run &&\
    mkdir -p /home/ssh-agent/.ssh &&\
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcXvdpDSipHRXObAgPJSOjnp/p2V1ioPpo/xM4/oCfSRRDVvUcjulObk2H1QLsrGf/mpmgvjqsYp80UvL3NaTlsrDl8bWIWMVhOkQpmoAt4WpJqO8nWEWomjnuAr7j2sGFzqZnrJeqrWu9Mvu5kzHRrkqoFHB+9d+0unLbJBteVdE81827zNcd9iho0gm4e5LOCFp1EqFeVE27tcgIbue4scmc2NUxJ16Y24unq5IQzqqCrnAqfcx0bKlVhJzTu62A7lr+2g0H7/I0hDltvbKFfqA0P3lKboyNXFx+a0bbRBNxrs32EVCa8KCUx+Geb3qpANnnUP8jzj2w0qQ94TNV+F7fQkRyRq92AYnO0WeKlKt95wba3Q0RhOGA4jhaVfyFKWFUf6MltihSsEXbjgNRwQmP5OQ4+5iraUb8aBlNCPyqVpu+WLOG9I0n4ACKTqjrpDBuynalIwvl44zQMfaICaEfC8IVjbwZVnEMwnW3OgXtHAbo0RpnjojyJGHeArk= ${newuser}@jenkins" >> /home/ssh-agent/.ssh/authorized_keys &&\
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPrHJ9KYDfa9c1qNs+bhj1vvALQSIhdPw0fOXCMLwsb ${newuser}@jenkins-agent" >> /home/ssh-agent/.ssh/authorized_keys &&\
    touch /home/ssh-agent/run/sshd.pid &&\
    touch /home/ssh-agent/run/supervisord.pid &&\
    python3 -m pip install supervisor supervisord-dependent-startup

COPY entrypoint.sh sshd_config supervisord.conf /home/ssh-agent/run/

RUN chmod 660 /etc/passwd &&\
# add user for local testing:
#    chown -R ${newuser}:root /home/ssh-agent/ &&\
    chgrp -R root /home/ssh-agent/ &&\
    find /home/ssh-agent -type d -exec chmod 770 {} \; &&\
    find /home/ssh-agent -type f -exec chmod 660 {} \; &&\
    chmod 644 /home/ssh-agent/run/sshd_config /home/ssh-agent/.ssh/authorized_keys &&\
    chmod 755 /home/ssh-agent/run/entrypoint.sh

EXPOSE 2222

ENTRYPOINT [ "/home/ssh-agent/run/entrypoint.sh" ]
CMD ["supervisord", "-c", "/home/ssh-agent/run/supervisord.conf"]

USER ${newuser}
WORKDIR /home/ssh-agent

ENV TZ=Europe/Brussels
