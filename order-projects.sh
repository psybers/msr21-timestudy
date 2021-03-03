#!/bin/sh

for url in `cut -d']' -f1-2 order-output.txt | cut -d'[' -f2-3 | sed 's/\]\[/\/commit\//' | sort | uniq` ; do
    repo=`echo $url | cut -d'/' -f 4-5`
    commit=`echo $url | cut -d'/' -f 7`

    if grep "$commit: BAD" order-verified.txt > /dev/null ; then
        echo $repo
    fi
done
