#!/bin/sh

source ./gitapi.sh
source ./shaapi.sh

for commit in `grep ': BAD' order-verified.txt | cut -d':' -f1` ; do
    gh_json_path=`git_json_path $commit`
    sha_json_path=`sha_json_path $commit`
    
    # echo "processing: $commit"
    
    if [ -e $GIT_JSONDIR/$gh_json_path ] ; then
        cat $GIT_JSONDIR/$gh_json_path | jq -r '.commit.author.date'
    elif [ -e $SHA_JSONDIR/$sha_json_path ] ; then
        cat $SHA_JSONDIR/$sha_json_path | jq -r '.date'
    fi
    

    # echo "## ** %% @@ ##"
    
done
