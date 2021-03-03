#!/bin/sh

source ./shaapi.sh

touch good-sha-projects.txt
touch bad-sha-projects.txt

for url in `cat bad-projects.txt` ; do
    if ! grep -q $url bad-sha-projects.txt ; then
        if ! grep -q $url good-sha-projects.txt ; then
            repo=`echo $url |cut -d'/' -f 4-5`
            if sha_api_repo $repo >/dev/null ; then
                echo "URL exists: $url"
                echo $url >> good-sha-projects.txt
            else
                echo "URL does not exist: $url"
                echo $url >> bad-sha-projects.txt
            fi
        fi
    fi
done
