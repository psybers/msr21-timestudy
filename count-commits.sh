#!/bin/sh

source ./gitapi.sh
source ./shaapi.sh

for line in `cut -d']' -f1-2 *-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    commit=`echo $line | cut -d'/' -f7`
    git_json_path=$GIT_JSONDIR/`git_json_path $commit`
    sha_json_path=$SHA_JSONDIR/`sha_json_path $commit`

    if [ -e $git_json_path ] ; then
        echo $commit: GH
    elif [ -e $sha_json_path ] ; then
        echo $commit: SHA
    else
        echo $commit: NONE
    fi
done
