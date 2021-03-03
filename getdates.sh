#!/bin/sh

source ./gitapi.sh

touch commit.dates

for url in `cut -d']' -f1-2 old-output.txt|cut -d'[' -f2-3|sed 's/\]\[/\/commit\//'` ; do
    base=`echo $url | cut -d'/' -f1-5`
    if ! grep -q $base bad-projects.txt ; then
        if ! grep -q $url commit.dates ; then
            echo "processing: $url"

            repo=`echo $url |cut -d'/' -f 4-5`
            commit=`echo $url |cut -d'/' -f 7`
            json_path=`git_json_path $commit`

            dt=`cat $GIT_JSONDIR/$json_path | jq -r '.commit.committer.date'`
            echo "$url: $dt" >> commit.dates
        else
            echo "skipping: $url"
        fi
    else
        echo "bad: $base"
    fi
done
