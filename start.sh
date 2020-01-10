#!/bin/bash

set -eu

echo "=> Ensure directories"
mkdir -p /app/data/addons  /app/data/data

#if [[ ! -f "/app/data/odoo.conf" ]]; then
#    echo "=> First run, create config file"
#    cp /etc/odoo-server.conf /app/data/odoo.conf
#fi

echo "=> Patch config file"
# https://github.com/odoo/docker/blob/master/10.0/odoo.conf
crudini --set /app/data/odoo.conf options addons_path /app/data/addons,/app/code/odoo-server/addons,/app/code/extra-addons
crudini --set /app/data/odoo.conf options data_dir /app/data/data
crudini --set /app/data/odoo.conf options db_host ${CLOUDRON_POSTGRESQL_HOST}
crudini --set /app/data/odoo.conf options db_port ${CLOUDRON_POSTGRESQL_PORT}
crudini --set /app/data/odoo.conf options db_user ${CLOUDRON_POSTGRESQL_USERNAME}
crudini --set /app/data/odoo.conf options db_password ${CLOUDRON_POSTGRESQL_PASSWORD}
crudini --set /app/data/odoo.conf options db_dbname ${CLOUDRON_POSTGRESQL_DATABASE}
crudini --set /app/data/odoo.conf options smtp_password ${CLOUDRON_MAIL_SMTP_PASSWORD}
crudini --set /app/data/odoo.conf options smtp_port ${CLOUDRON_MAIL_SMTP_PORT}
crudini --set /app/data/odoo.conf options smtp_server ${CLOUDRON_MAIL_SMTP_SERVER}
crudini --set /app/data/odoo.conf options smtp_user ${CLOUDRON_MAIL_SMTP_USERNAME}
crudini --set /app/data/odoo.conf options smtp_ssl False
crudini --set /app/data/odoo.conf options email_from ${CLOUDRON_MAIL_FROM}
crudini --set /app/data/odoo.conf options list_db False
crudini --set /app/data/odoo.conf options without_demo WITHOUT_DEMO

echo "=> Ensure data ownership"
chown -R odoo:odoo /app/data/

echo "=> Starting odoo"
exec /usr/local/bin/gosu odoo:odoo  /app/code/odoo-server/odoo-bin --config=/app/data/odoo.conf

