# Usage

If **$SSH_USER** is unspecified, root will be used.
If the provided user does not exists in the container, the attached SSH public key is copied to `/tmp/${SSH_USER}.pub`.

You can provide a full `authorized_keys` file for a user:

    docker run --name dropbear -v ~/.ssh/id_rsa.pub:/ssh_authorized_keys \
    --publish=3333:22 -d ff0x/dropbear:latest

    ssh root@localhost -p3333

Or with specified **$SSH_USER**:

    docker run --name dropbear -e SSH_USER="git" -v ~/.ssh/id_rsa.pub:/ssh_authorized_keys \
    --publish=3333:22 -d ff0x/dropbear:latest

    ssh git@localhost -p3333

You can also supply the key directly:

    docker run --name dropbear -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" \
    --publish=3333:22 -d ff0x/dropbear:latest

SSH hostkeys are generated when the first client connects.  
To persist them over the container lifetime, supply an volume for `/etc/dropbear`.

    docker run --name dropbear -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" \
    -v ssh-hostkeys:/etc/dropbear --publish=3333:22 -d reg.infr.cat/dropbear:latest
