#!/bin/sh

source ./gitapi.sh

touch good-projects.txt
touch bad-projects.txt

for url in `cat all-projects.txt` ; do
    if ! grep -q $url bad-projects.txt ; then
        if ! grep -q $url good-projects.txt ; then
            repo=`echo $url |cut -d'/' -f 4-5`
            if git_api_repo $repo >/dev/null ; then
                echo "URL exists: $url"
                echo $url >> good-projects.txt
            else
                echo "URL does not exist: $url"
                echo $url >> bad-projects.txt
            fi
        fi
    fi
done
