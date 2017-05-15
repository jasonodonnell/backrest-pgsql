#!/bin/bash
# Create Bidirectional SSH Keys for pgBackrest and Postgres

set -u

PGSQL='./services/postgres/config'
BACKREST='./services/pgbackrest/config'

if [[ ! -f ${PGSQL?}/postgres ]]
then
    ssh-keygen -b 2048 -t rsa -f ${PGSQL?}/postgres -q -N ""
    cat ${PGSQL?}/postgres.pub > ${BACKREST?}/authorized_keys
fi

if [[ ! -f ${BACKREST?}/backrest ]]
then
    ssh-keygen -b 2048 -t rsa -f ${BACKREST?}/backrest -q -N ""
    cat ${BACKREST?}/backrest.pub > ${PGSQL?}/authorized_keys
fi

exit 0
