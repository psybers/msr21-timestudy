#!/bin/sh

cat order-output.txt | cut -d']' -f1 | cut -d'[' -f2 | sed 's/$/]/' > order-projects.pat
fgrep -f order-projects.pat all-projects-revisions.txt | sort | uniq > order-project-total-revisions.txt
cat order-output.txt | cut -d']' -f1 | cut -d'[' -f2 | sort | uniq -c > order-project-revisions.txt
ORDER_TOTAL_COMMITS=$(cat order-project-total-revisions.txt | cut -d'=' -f2 | cut -d' ' -f2 | awk '{s+=$1} END {print s}')
ORDER_BAD_COMMITS=$(cat order-project-revisions.txt | awk '{s+=$1} END {print s}')
echo ORDER BAD $ORDER_BAD_COMMITS
echo ORDER TOTAL $ORDER_TOTAL_COMMITS
PERCENT_ORDER_BAD=$(echo "10 k ${ORDER_BAD_COMMITS} ${ORDER_TOTAL_COMMITS} / 100 * p" | dc)
echo "ORDER PERCENT BAD ${PERCENT_ORDER_BAD}%"
rm order-projects.pat

cat old-output.txt | cut -d']' -f1 | cut -d'[' -f2 | sed 's/$/]/'> old-projects.pat
fgrep -f old-projects.pat all-projects-revisions.txt | sort | uniq > old-project-total-revisions.txt
cat old-output.txt | cut -d']' -f1 | cut -d'[' -f2 | sort | uniq -c > old-project-revisions.txt 
OLD_TOTAL_COMMITS=$(cat old-project-total-revisions.txt | cut -d'=' -f2 | cut -d' ' -f2 | awk '{s+=$1} END {print s}')
OLD_BAD_COMMITS=$(cat old-project-revisions.txt | awk '{s+=$1} END {print s}')
echo OLD BAD $OLD_BAD_COMMITS
echo OLD TOTAL $OLD_TOTAL_COMMITS
PERCENT_OLD_BAD=$(echo "10 k ${OLD_BAD_COMMITS} ${OLD_TOTAL_COMMITS} / 100 * p" | dc)
echo "OLD PERCENT BAD ${PERCENT_OLD_BAD}%"
rm old-projects.pat
