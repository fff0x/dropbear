# Makefile ------+
# Version: 0.0.7 |
# ---------------+
# vim: noai:ts=2

### VARIABLES
# -----------

### INCLUDES
# ----------
include ../@include/default.mk

### CONTAINER
# -----------
run: clean test logs

test1:
	docker run --platform linux/${DEF_ARCH} --name ${LABEL} --hostname ${LABEL}.${DOMAIN} -v ssh-hostkeys:/etc/dropbear -v ~/.ssh/id_rsa.pub:/ssh_authorized_keys --publish=3333:22 -d $(NAME)
	@sleep 2
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 3333 root@localhost

test2:
	docker run --platform linux/${DEF_ARCH} --name ${LABEL} --hostname ${LABEL}.${DOMAIN} -v ssh-hostkeys:/etc/dropbear -v ~/.ssh/id_rsa.pub:/ssh_authorized_keys -e SSH_USER="$(USER)" --publish=3333:22 -d $(NAME)
	@sleep 2
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 3333 $(USER)@localhost

test3:
	docker run --platform linux/${DEF_ARCH} --name ${LABEL} --hostname ${LABEL}.${DOMAIN} -v ssh-hostkeys:/etc/dropbear -e SSH_USER="$(USER)" -e SSH_KEY="$(shell cat ~/.ssh/id_rsa.pub)" --publish=3333:22 -d $(NAME)
	@sleep 2
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 3333 $(USER)@localhost

clean:
	docker kill ${LABEL} >/dev/null 2>&1 || true
	docker rm ${LABEL} >/dev/null 2>&1 || true
	docker volume rm ssh-hostkeys >/dev/null 2>&1 || true

debug: clean
	docker run -ti --entrypoint /bin/sh --platform linux/${DEF_ARCH} --name ${LABEL} --hostname ${LABEL}.${DOMAIN} -v ssh-hostkeys:/etc/dropbear -v ~/.ssh/id_rsa.pub:/ssh_authorized_keys --publish=3333:22 -d $(NAME)
	@sleep 2
	docker exec -ti ${LABEL} /bin/sh
