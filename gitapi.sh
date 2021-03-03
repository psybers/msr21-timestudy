#!/bin/sh

git_token=`cat github.token`
GIT_JSONDIR="json-gh"
GIT_RATE_LEFT=

function git_rateleft {
    GIT_RATE_LEFT=`curl --silent -H "Authorization: token $git_token" -X GET https://api.github.com/rate_limit | jq -r '.resources.core.remaining'`
}

function git_ratelimit {
    current_epoch=`date +%s`
    target_epoch=`curl --silent -H "Authorization: token $git_token" -X GET https://api.github.com/rate_limit | jq -r '.resources.core.reset'`
    sleep_seconds=$(( $target_epoch - $current_epoch + 5))
    echo "[`date`] sleeping $sleep_seconds seconds until `date -r $target_epoch`..." >>/dev/stderr
    sleep $sleep_seconds
    git_rateleft
}

function git_api {
    if [[ $GIT_RATE_LEFT < 1 ]]; then
        echo "GitHub API rate limit reached" >>/dev/stderr
        git_ratelimit
    fi
    GIT_RATE_LEFT=$((GIT_RATE_LEFT - 1))
}

function git_api_commit {
    git_api
    curl --fail --location --silent -H "Authorization: token $git_token" https://api.github.com/repos/$1/commits/$2
}

function git_api_repo {
    git_api
    curl --fail --location --silent -H "Authorization: token $git_token" https://api.github.com/repos/$1
}

function git_json_path {
    first=`echo $1 | cut -c1-1`
    second=`echo $1 | cut -c2-2`
    echo "$first/$second/$1.json"
}

git_rateleft
