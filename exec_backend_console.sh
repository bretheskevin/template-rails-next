#!/bin/bash

export $(grep -v '^#' .env | xargs)
docker exec -it $PROJECT_NAME-backend bash
