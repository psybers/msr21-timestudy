#!/bin/sh

source ./gitapi.sh
source ./shaapi.sh

for commit in `grep ': BAD' order-verified.txt | cut -d':' -f1` ; do
    gh_json_path=`git_json_path $commit`
    sha_json_path=`sha_json_path $commit`
    
    if [ -e $GIT_JSONDIR/$gh_json_path ] ; then
        msg=`cat $GIT_JSONDIR/$gh_json_path | jq -r '.commit.message'`
        name=`cat $GIT_JSONDIR/$gh_json_path | jq -r '.commit.author.name'`
        email=`cat $GIT_JSONDIR/$gh_json_path | jq -r '.commit.author.email'`
        date=`cat $GIT_JSONDIR/$gh_json_path | jq -r '.commit.author.date'`
        echo "$name <$email>"
    elif [ -e $SHA_JSONDIR/$sha_json_path ] ; then
        msg=`cat $SHA_JSONDIR/$sha_json_path | jq -r '.message'`
        fullname=`cat $SHA_JSONDIR/$sha_json_path | jq -r '.author.fullname'`
        date=`cat $SHA_JSONDIR/$sha_json_path | jq -r '.date'`
        echo "$fullname" 
    fi
    
done
