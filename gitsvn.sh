#!/bin/sh

source ./gitapi.sh

touch git-svn.ids

for url in `cut -d']' -f1-2 old-output.txt|cut -d'[' -f2-3|sed 's/\]\[/\/commit\//'` ; do
    base=`echo $url | cut -d'/' -f1-5`
    if ! grep -q $base bad-projects.txt ; then
        if ! grep -q $url git-svn.ids ; then
            echo "processing: $url"

            repo=`echo $url |cut -d'/' -f 4-5`
            commit=`echo $url |cut -d'/' -f 7`
            json_path=`git_json_path $commit`

            log=`cat $GIT_JSONDIR/$json_path | jq -r '.commit.message'`
            if echo $log | grep -i -q "git-svn-id" ; then
                echo "$url: GIT-SVN-ID" >> git-svn.ids
            else
                echo "$url: no" >> git-svn.ids
            fi
        else
            echo "skipping: $url"
        fi
    else
        echo "bad: $base"
    fi
done
