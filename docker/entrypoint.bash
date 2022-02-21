#!/bin/bash

set -e

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

# Force running user home to be owned by user.
# This can help in case runtime cache is stored in home dir.
chown -R ${GOSU_USER} ${GOSU_HOME}

# Force application directory to be owned by running user
chown -R ${GOSU_USER}:${GOSU_USER} ${GOSU_WORKDIR}

# Run docker's CMD with configured user
exec gosu $GOSU_USER "$@"