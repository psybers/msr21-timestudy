#!/bin/sh

source ./gitapi.sh

for url in `cut -d']' -f1-2 order-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    repo=`echo $url | cut -d'/' -f 4-5`
    commit=`echo $url | cut -d'/' -f 7`
    json_path=`git_json_path $commit`

    if [ -e $GIT_JSONDIR/$json_path ] ; then
        date=$(python3 date2unix.py "$(cat $GIT_JSONDIR/$json_path | jq -r '.commit.committer.date')")

        newer=0
        for parent in `cat $GIT_JSONDIR/$json_path | jq -r '.parents[].sha'` ; do
            parent_path=`git_json_path $parent`
            if [ -e $GIT_JSONDIR/$parent_path ]; then
                parent_date=$(python3 date2unix.py "$(cat $GIT_JSONDIR/$(git_json_path $parent) | jq -r '.commit.committer.date')")
                if [[ $date -lt $parent_date ]] ; then
                    newer=1
                fi
            else
                newer=-1
            fi
        done

        if [ $newer -eq 0 ] ; then
            echo "$commit: OK"
        else
            if [ $newer -eq -1 ] ; then
                echo "$commit: MISSING"
            else
                echo "$commit: BAD"
            fi
        fi
    fi
done
