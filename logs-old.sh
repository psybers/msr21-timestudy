#!/bin/sh

source ./gitapi.sh

for url in `grep ': no' git-svn.ids | cut -d' ' -f1 | cut -d':' -f1-2` ; do
    base=`echo $url | cut -d'/' -f1-5`
    echo "processing: $url"

    repo=`echo $url |cut -d'/' -f 4-5`
    commit=`echo $url |cut -d'/' -f 7`
    json_path=`git_json_path $commit`

    log=`cat $GIT_JSONDIR/$json_path | jq -r '.commit.message'`
    echo $log
done
