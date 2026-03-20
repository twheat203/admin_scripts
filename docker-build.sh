#!/bin/bash
dt=$(date +%Y%m%d-%H%M%S)
dtshort=$(date +%Y%m%d)
version=$dtshort
project="app_name"
curver="path/to/artifactory/location/$project/$version"
latest="path/to/artifactory/location/$project:latest"
cme_curver="url-of-artifactory.domain.com/$curver"
cme_latest="url-of-artifactory.domain.com/$latest"

docker build --label "build-date=$dtshort" -t $cme_curver -t $cme_latest . 2>&1 | tee "/tmp/$(basename $(pwd))-$(date +%Y%m%d-%H%M%S).log
