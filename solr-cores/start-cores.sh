#!/bin/bash
# start.sh
# Start an instance of Solr container with Core config mounted
#

#THIS DOESNT WORK RIGHT NOW

HOST_PROXY_PORT=8983
CONTAINER_SOLR_PORT=8983

CONTAINER_PATH="/opt/solr"

COLLECTIONS=$(find . -maxdepth 1 -mindepth 1 -type d -not -name .git | printf "%f\n")
VOLUMES=$(for col in ${COLLECTIONS[*]}; do echo -en "-v ${APP_DIR}/${col}:${CONTAINER_PATH}/example/solr/${col} "; done)

start_container() {
  APP_CID=$(docker run \
    -d \
    --name=solr \
    -p ${HOST_PROXY_PORT}:${CONTAINER_SOLR_PORT} \
    $VOLUMES \
    andrewkrug/solr)
  RETVAL=$?
  [ $RETVAL -eq 0 ] && echo "you may access container via http://$(hostname -i):${HOST_PROXY_PORT}/solr" >&2
  return $RETVAL
}

start_container
exit 0
