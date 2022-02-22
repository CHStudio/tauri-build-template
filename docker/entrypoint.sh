#!/bin/sh

set -e

export PATH=${GOSU_HOME}/.cargo/bin:$PATH

#
# ⚠ All environment vars used here are defined in the Dockerfile.
# ⚠ Refer to the Dockerfile if you want to change them.
#

# Get unix user id for project directory.
uid=$(stat -c %u ${GOSU_WORKDIR})
gid=$(stat -c %g ${GOSU_WORKDIR})

# Force the use of user id in container.
sed -i -r "s/${GOSU_USER}:x:\d+:\d+:/${GOSU_USER}:x:$uid:$gid:/g" /etc/passwd
sed -i -r "s/${GOSU_USER}:x:\d+:/${GOSU_USER}:x:$gid:/g" /etc/group

# Run docker's CMD with configured user
gosu ${GOSU_USER}:${GOSU_USER} $@
