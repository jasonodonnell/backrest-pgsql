#!/bin/bash

source /tmp/postgres/scripts/env.sh

yum install -y ${PGDG?} >/dev/null 2>&1

yum install -y postgresql${PGSQL_VER//./} \
               postgresql${PGSQL_VER//./}-contrib \
               postgresql${PGSQL_VER//./}-libs \
               postgresql${PGSQL_VER//./}-server \
               postgresql${PGSQL_VER//./}-docs \
               pgbackrest \
               >/dev/null 2>&1

/usr/pgsql-${PGSQL_VER?}/bin/postgresql${PGSQL_VER//./}-setup initdb
systemctl enable postgresql-${PGSQL_VER?}

apply_postgres_configs
backrest_bootstrap primary

systemctl start postgresql-${PGSQL_VER?}

${PGSQL_SRC_DIR?}/scripts/bootstrap_replication.sh

exit 0
