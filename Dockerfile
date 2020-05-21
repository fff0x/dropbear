##
## PRE BUILD
##

ARG REGISTRY
FROM ${REGISTRY}/base:0.0.1

##
## MAIN
##

LABEL maintainer="Max Woelfing (ff0x@this-is-fine.io)"
LABEL name="dropbear" version="0.0.1"
LABEL description="Alpine Linux running dropbear ssh daemon"

##
## CONFIGURATION
##

ARG ARCH

# Dropbear args:
# -R  Create hostkeys as required
# -E  Log to stderr rather than syslog
# -s  Disable password logins
# -g  Disable password logins for root
# -w  Disallow root logins
# -F  Don't fork into background
# -p  Listen on Port

ENV DROPBEAR_OPTIONS="-REsg -F -p 22"

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
## PORTS
##

EXPOSE 22

##
## INIT
##

ENTRYPOINT ["/sbin/tini", "--", "/init"]
