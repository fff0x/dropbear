# Makefile ------+
# Version: 0.0.5 |
# ---------------+
# vim: noai:ts=2

### VARIABLES
# -----------
override REGISTRY = ff0x
override CACHE = true
override SQUASH = true

### INCLUDES
# ----------
include ../@include/default.mk

### CONTAINER
# -----------
run: clean test logs

test:
	docker run --platform linux/${DEF_ARCH} --name ${LABEL} --hostname ${LABEL}.${DOMAIN} -v ssh-hostkeys:/etc/dropbear -v ~/.ssh/id_rsa.pub:/ssh_authorized_keys --publish=3333:22 -d $(NAME)
	@sleep 2

clean:
	docker kill ${LABEL} >/dev/null 2>&1 || true
	docker rm ${LABEL} >/dev/null 2>&1 || true
	docker volume rm ssh-hostkeys >/dev/null 2>&1 || true

debug: clean
	docker run -ti --entrypoint /bin/bash --platform linux/${DEF_ARCH} --name ${LABEL} --hostname ${LABEL}.${DOMAIN} -v ssh-hostkeys:/etc/dropbear -v ~/.ssh/id_rsa.pub:/ssh_authorized_keys --publish=3333:22 -d $(NAME)
	@sleep 2
	docker exec -ti ${LABEL} /bin/bash
