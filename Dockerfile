##
## PRE BUILD
##

ARG REGISTRY
ARG BASE_ARCH
FROM ${REGISTRY}/base${BASE_ARCH}:0.1.0

##
## MAIN
##

LABEL maintainer="Max Buelte <ff0x@tif.cat>"
LABEL name="dropbear" version="0.0.10"
LABEL description="Alpine Linux running dropbear ssh daemon"

##
## CONFIGURATION
##

ENV DAEMON_USR="root" \
    DAEMON_GRP="root"

# Dropbear args:
# -R  Create hostkeys as required
# -E  Log to stderr rather than syslog
# -s  Disable password logins
# -g  Disable password logins for root
# -w  Disallow root logins
# -F  Don't fork into background
# -K Send keepalive packets in seconds
# -p  Listen on Port

ENV DROPBEAR_OPTIONS="-REsg -F -K 30 -p 22"

##
## ROOTFS
##

COPY ["rootfs", "/"]

##
## PREPARATION
##

RUN apk add --update --no-cache dropbear openssh-client \
&& mkdir -p /etc/dropbear \
&& touch /var/log/lastlog

##
## ENVIRONMENT
##

#USER "${DAEMON_USR}"
WORKDIR "/var/lib/${DAEMON_USR}"

##
## PORTS
##

EXPOSE 22

##
## INIT
##

ENTRYPOINT [ "/init" ]
