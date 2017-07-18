#!/bin/bash

source /tmp/postgres/scripts/env.sh

if [[ $(hostname) == ${MASTER_HOST?} ]]
then
    run_bootstrap_sql
    remote_backrest_setup
else
    systemctl stop postgresql-${PGSQL_VER?}
#    create_pgpass
    backrest_bootstrap replica
    su - ${USER?} -c 'pgbackrest --stanza=main --delta restore'
    apply_postgres_configs replica
    systemctl start postgresql-${PGSQL_VER?}
fi

exit 0
