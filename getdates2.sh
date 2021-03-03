#!/bin/sh

source ./gitapi.sh

touch commit-order.dates

for url in `cut -d']' -f1-2 order-output.txt|cut -d'[' -f2-3|sed 's/\]\[/\/commit\//'` ; do
    base=`echo $url | cut -d'/' -f1-5`
    if ! grep -q $base bad-projects.txt ; then
        if ! grep -q $url commit-order.dates ; then
            echo "processing: $url"

            repo=`echo $url |cut -d'/' -f 4-5`
            commit=`echo $url |cut -d'/' -f 7`

            json=`git_api_commit $repo $commit`
            dt=`cat $json | jq -r '.commit.committer.date'`
            echo "$url: $dt" >> commit-order.dates

            for parent in `cat $json | jq -r '.parents[].sha'` ; do
                json=`git_api_commit $repo $parent`
                dt=`cat $json | jq -r '.commit.committer.date'`
                echo "$parent: $dt" >> parent.dates
            done
        else
            echo "skipping: $url"
        fi
    else
        echo "bad: $base"
    fi
done
