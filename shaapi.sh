#!/bin/sh

sha_token=`cat sha.token`
SHA_JSONDIR="json-sha"

SHA_RATE_LEFT=-1
SHA_RATE_EPOCH=0

function sha_rateleft {
    #curl --silent -i -H "Authorization: Bearer $sha_token" -X GET https://archive.softwareheritage.org/api/1/stat/counters/ | grep 'X-RateLimit-Remaining:' | cut -d' ' -f2
    curl --silent -i -X GET https://archive.softwareheritage.org/api/1/stat/counters/ | grep 'X-RateLimit-Remaining:' | cut -d' ' -f2
}

function sha_ratelimit {
    current_epoch=`date +%s`
    sleep_seconds=$((SHA_RATE_EPOCH - current_epoch + 5))
    echo "[`date`] sleeping $sleep_seconds seconds until `date -r $SHA_RATE_EPOCH`..." >>/dev/stderr
    sleep $sleep_seconds
    SHA_RATE_LEFT=-1
    SHA_RATE_EPOCH=0
}

function sha_unrated {
    #rm -f headers
    #curl --silent -D headers -H "Authorization: Bearer $sha_token" -X GET https://archive.softwareheritage.org/api/1/$1
    #SHA_RATE_LEFT=`grep 'X-RateLimit-Remaining:' headers | cut -d' ' -f2 | tr -d '[:space:]'`
    #SHA_RATE_EPOCH=`grep 'X-RateLimit-Reset:' headers | cut -d' ' -f2 | tr -d '[:space:]'`
    #rm -f headers

    rm -f headers2
    curl --silent -D headers2 -X GET https://archive.softwareheritage.org/api/1/$1
    SHA_RATE_LEFT=`grep 'X-RateLimit-Remaining:' headers2 | cut -d' ' -f2 | tr -d '[:space:]'`
    SHA_RATE_EPOCH=`grep 'X-RateLimit-Reset:' headers2 | cut -d' ' -f2 | tr -d '[:space:]'`
    rm -f headers2
}

function sha_api {
    if [[ $SHA_RATE_LEFT -lt 0 ]]; then
        sha_unrated "stat/counters/" > /dev/null
        echo "API ratelimit left: $SHA_RATE_LEFT" >>/dev/stderr
        echo "API ratelimit epoch: $SHA_RATE_EPOCH" >>/dev/stderr
    fi

    if [[ $SHA_RATE_LEFT -lt 1 ]]; then
        echo "SHA API rate limit reached" >>/dev/stderr
        sha_ratelimit
    fi
}

function sha_api_commit {
    sha_api
    sha_unrated "revision/$1/"
}

function sha_api_repo {
    sha_api
    sha_unrated "origin/$1/get/"
}

function sha_json_path {
    first=`echo $1 | cut -c1-1`
    second=`echo $1 | cut -c2-2`
    echo "$first/$second/$1.json"
}
