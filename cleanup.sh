#!/bin/sh

source ./gitapi.sh
source ./shaapi.sh

find $GIT_JSONDIR -size 0 | xargs rm
find $SHA_JSONDIR -size 0 | xargs rm

grep -l -R 'Offline user session not found' $SHA_JSONDIR | xargs rm
grep -l -R 'Request was throttled. Expected available in' $SHA_JSONDIR | xargs rm
