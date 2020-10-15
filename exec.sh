#!/bin/bash
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

docker exec -it $(read_var PROJECT_NAME .env)webserver bash