#!/bin/bash

USER='backrest'
GROUP='backrest'
BACKREST_SRC_DIR='/tmp/pgbackrest'
BACKREST_DIR='/var/lib/pgbackrest'
COMMON_DIR='/tmp/common'
PGDG='https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm'

yum install -y ${PGDG?} >/dev/null 2>&1

yum install -y \
    perl \
    perl-Time-HiRes \
    perl-parent \
    perl-JSON \
    perl-Digest-SHA \
    perl-DBD-Pg >/dev/null 2>&1

yum install -y pgbackrest >/dev/null 2>&1

id -u ${USER?} >/dev/null 2>&1

if [[ $? -ne 0 ]]
then
    useradd ${USER?} -m -d ${BACKREST_DIR?}
fi

mkdir ${BACKREST_DIR?}/.ssh

cp ${BACKREST_SRC_DIR?}/config/pgbackrest.conf /etc/pgbackrest.conf
cp ${BACKREST_SRC_DIR?}/config/authorized_keys ${BACKREST_DIR?}/.ssh/authorized_keys
cp ${BACKREST_SRC_DIR?}/config/backrest ${BACKREST_DIR?}/.ssh/backrest
cp ${BACKREST_SRC_DIR?}/config/config ${BACKREST_DIR?}/.ssh/config

chown -R ${USER?}:${GROUP?} ${BACKREST_DIR?}
chown -R ${USER?}:root /var/log/pgbackrest
chmod 700 ${BACKREST_DIR?}/.ssh
chmod 600 ${BACKREST_DIR?}/.ssh/authorized_keys
chmod 600 ${BACKREST_DIR?}/.ssh/backrest
chmod 600 ${BACKREST_DIR?}/.ssh/config
restorecon ${BACKREST_DIR?}/.ssh
restorecon ${BACKREST_DIR?}/.ssh/authorized_keys
restorecon ${BACKREST_DIR?}/.ssh/config

exit 0
