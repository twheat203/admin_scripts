#!/bin/bash

# Cleanup Docker container images
for i in `docker ps --format '{{.Names}}'
do
   docker kill $i
   docker rm $i
done

# Cleanup Docker system
yes | docker systme prune -a
