#!/bin/sh

source ./gitapi.sh

for url in `cut -d']' -f1-2 *-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    repo=`echo $url | cut -d'/' -f 4-5`
    commit=`echo $url | cut -d'/' -f 7`
    json_path=`git_json_path $commit`

    if ! [[ -e $GIT_JSONDIR/$json_path ]] ; then
        base=`echo $url | cut -d'/' -f1-5`
        if ! grep -q $base bad-projects.txt ; then
            echo "processing: $url"
            mkdir -p `dirname $GIT_JSONDIR/$json_path`
            git_api_commit $repo $commit > $GIT_JSONDIR/$json_path
        else
            echo "bad: $base"
        fi
    else
        echo "skipping: $url"
    fi
done
