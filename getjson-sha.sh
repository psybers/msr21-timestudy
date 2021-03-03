#!/bin/sh

source ./gitapi.sh
source ./shaapi.sh

for url in `cut -d']' -f1-2 *-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    repo=`echo $url | cut -d'/' -f 4-5`
    commit=`echo $url | cut -d'/' -f 7`
    json_path=`sha_json_path $commit`

    if ! [[ -e $SHA_JSONDIR/$json_path ]] ; then
        base=`echo $url | cut -d'/' -f1-5`
        if [[ -e $GIT_JSONDIR/$json_path ]] ; then
            echo "on github: $base"
        else
            echo "processing: $url"
            mkdir -p `dirname $SHA_JSONDIR/$json_path`
            sha_api_commit $commit > $SHA_JSONDIR/$json_path
        fi
    else
        echo "skipping: $url"
    fi
done
