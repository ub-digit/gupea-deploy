#!/bin/bash
source ./docker-compose-detect.sh
$DOCKER_COMPOSE -f docker-compose.cli.yml "$@"
