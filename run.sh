#!/bin/bash

echo $MARIADB_PORT_3306_TCP_ADDR mysql.orshakes.org >> /etc/hosts

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

exec ${CATALINA_HOME}/bin/catalina.sh run
