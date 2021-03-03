#!/bin/sh

source ./shaapi.sh

for url in `cut -d']' -f1-2 order-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    repo=`echo $url | cut -d'/' -f 4-5`
    commit=`echo $url | cut -d'/' -f 7`
    json_path=`sha_json_path $commit`

    if [[ -e $SHA_JSONDIR/$json_path ]] ; then
        base=`echo $url | cut -d'/' -f1-5`
        echo "processing: $url"
        for p in `cat $SHA_JSONDIR/$json_path | jq -r '.parents[].id'` ; do
            parent_path=`sha_json_path $p`
            if ! [[ -e $SHA_JSONDIR/$parent_path ]] ; then
                mkdir -p `dirname $SHA_JSONDIR/$parent_path`
                sha_api_commit $p > $SHA_JSONDIR/$parent_path
                echo "parent: $p"
            else
                echo "skipping parent: $p"
            fi
        done
    else
        echo "skipping: $url"
    fi
done
