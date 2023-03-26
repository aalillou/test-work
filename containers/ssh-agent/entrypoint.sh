#!/bin/sh
set -xe
RUNUID="$(id -u)"
RUNUSER="ssh-agent"
WORKDIR="/home/ssh-agent"

echo "[entrypoint] preparing system"
[ ${RUNUID} -gt 10000 ] && echo "${RUNUSER}:x:${RUNUID}:0::${WORKDIR}:/bin/sh" >> /etc/passwd ; echo "[entrypoint] added run user to passwd"
mkdir -p ${WORKDIR}/ssh
ssh-keygen -f ${WORKDIR}/ssh/ssh_host_rsa_key -q -N '' -t rsa
ssh-keygen -f ${WORKDIR}/ssh/ssh_host_dsa_key -q -N '' -t dsa
ssh-keygen -f ${WORKDIR}/ssh/ssh_host_ecdsa_key -q -N '' -t ecdsa
ssh-keygen -f ${WORKDIR}/ssh/ssh_host_ed25519_key -q -N '' -t ed25519
chmod 600 ${WORKDIR}/ssh/*

# Execute the CMD from the Dockerfile
# /usr/sbin/sshd -D -e -p 2222
exec "$@"
