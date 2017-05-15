#!/bin/bash

USER='postgres'
GROUP='postgres'
PASSWORD='test123'
PGSQL_VER='9.6'
PGSQL_SRC_DIR='/tmp/postgres'
PGSQL_DIR='/var/lib/pgsql'
COMMON_DIR='/tmp/common'
BIN_DIR="/usr/pgsql-${PGSQL_VER?}/bin"
MASTER_HOST='orc-postgres-0.dev'
PORT=5432
PGPASS="${MASTER_HOST?}:${PORT?}:replication:replicator:${PASSWORD?}"
PGDG="https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm"

function apply_postgres_configs {
    chown -R ${USER?}:${GROUP?} ${PGSQL_DIR?}
    if [[ $1 == 'primary' ]]
    then
        cp ${PGSQL_SRC_DIR?}/config/postgresql.conf ${PGSQL_DIR?}/${PGSQL_VER?}/data
    else
        cp ${PGSQL_SRC_DIR?}/config/replica.conf ${PGSQL_DIR?}/${PGSQL_VER?}/data/postgresql.conf
    fi
    cp ${PGSQL_SRC_DIR?}/config/pg_hba.conf ${PGSQL_DIR?}/${PGSQL_VER?}/data
    chmod 600 ${PGSQL_DIR?}/${PGSQL_VER?}/data/postgresql.conf
    chmod 600 ${PGSQL_DIR?}/${PGSQL_VER?}/data/pg_hba.conf
}

function backrest_bootstrap {
    if [[ ! -d ${PGSQL_DIR?}/.ssh ]]
    then
        mkdir ${PGSQL_DIR?}/.ssh
    fi

    if [[ $1 == 'primary' ]]
    then
        cp ${PGSQL_SRC_DIR?}/config/pgbackrest.conf /etc/pgbackrest.conf
    else
        cp ${PGSQL_SRC_DIR?}/config/pgbackrest-replica.conf /etc/pgbackrest.conf
    fi
    cp ${PGSQL_SRC_DIR?}/config/authorized_keys ${PGSQL_DIR?}/.ssh
    cp ${PGSQL_SRC_DIR?}/config/config ${PGSQL_DIR?}/.ssh/config
    cp ${PGSQL_SRC_DIR?}/config/postgres ${PGSQL_DIR?}/.ssh
    chown -R ${USER?}:${GROUP?} /var/log/pgbackrest
    chown -R ${USER?}:${GROUP?} /var/lib/pgbackrest
    chown -R ${USER?}:${GROUP?} ${PGSQL_DIR?}/.ssh
    chmod 700 ${PGSQL_DIR?}/.ssh
    chmod 600 ${PGSQL_DIR?}/.ssh/config
    chmod 600 ${PGSQL_DIR?}/.ssh/authorized_keys
    chmod 400 ${PGSQL_DIR?}/.ssh/postgres
    restorecon ${PGSQL_DIR?}/.ssh
    restorecon ${PGSQL_DIR?}/.ssh/config
    restorecon ${PGSQL_DIR?}/.ssh/authorized_keys
}

function create_pgpass {
    su - ${USER?} -c "touch ${PGSQL_DIR?}/.pgpass"
    su - ${USER?} -c "echo ${PGPASS?} >> ${PGSQL_DIR?}/.pgpass"
    chmod 600 ${PGSQL_DIR?}/.pgpass
    chown ${USER?}:${GROUP?} ${PGSQL_DIR?}/.pgpass
}

function remote_backrest_setup {
    su - ${USER?} -c "ssh orc-pgbackrest.dev pgbackrest --stanza=main stanza-create --force"
    su - ${USER?} -c "ssh orc-pgbackrest.dev pgbackrest --stanza=main backup"
}

function run_bootstrap_sql {
    cp /tmp/${USER?}/config/bootstrap.sql ${PGSQL_DIR?}
    chmod 600 ${PGSQL_DIR?}/bootstrap.sql
    chown ${USER?}:${GROUP?} ${PGSQL_DIR?}/bootstrap.sql
    su - ${USER?} -c "psql -d ${USER?} -f ~/bootstrap.sql"
}
