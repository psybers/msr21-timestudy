#!/bin/sh

source ./gitapi.sh

for url in `cut -d']' -f1-2 order-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    repo=`echo $url | cut -d'/' -f 4-5`
    commit=`echo $url | cut -d'/' -f 7`
    json_path=`git_json_path $commit`

    if [[ -e $GIT_JSONDIR/$json_path ]] ; then
        base=`echo $url | cut -d'/' -f1-5`
        echo "processing: $url"
        for p in `cat $GIT_JSONDIR/$json_path | jq -r '.parents[].sha'` ; do
            parent_path=`git_json_path $p`
            if ! [[ -e $GIT_JSONDIR/$parent_path ]] ; then
                mkdir -p `dirname $GIT_JSONDIR/$parent_path`
                git_api_commit $repo $p > $GIT_JSONDIR/$parent_path
                echo "parent: $p"
            else
                echo "skipping parent: $p"
            fi
        done
    else
        echo "skipping: $url"
    fi
done
