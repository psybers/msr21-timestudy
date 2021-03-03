#!/bin/sh

source ./shaapi.sh

for url in `cut -d']' -f1-2 order-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    repo=`echo $url | cut -d'/' -f 4-5`
    commit=`echo $url | cut -d'/' -f 7`
    json_path=`sha_json_path $commit`

    if [ -e $SHA_JSONDIR/$json_path ] ; then
        date=$(python3 date2unix.py "$(cat $SHA_JSONDIR/$json_path | jq -r '.committer_date')")

        newer=0
        for parent in `cat "$SHA_JSONDIR/$json_path" | jq -r '.parents[].id'` ; do
            parent_path=`sha_json_path $parent`
            if [ -e $SHA_JSONDIR/$parent_path ]; then
                parent_date=$(python3 date2unix.py "$(cat $SHA_JSONDIR/$parent_path | jq -r '.committer_date')")
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
