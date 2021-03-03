#!/bin/sh

cat old-output.txt | cut -d']' -f2 | cut -d '[' -f 2 > old-output-commits-only.txt
TOTAL_COMMITS_OLD=$(cat old-output-commits-only.txt | wc -l)
cat old-output-commits-only.txt | sort | uniq -c | sort -nr > old-commits-counted.txt
TOTAL_COMMITS_OLD_REPEATED=$(cat old-commits-counted.txt | grep -v ' *1 ' | awk '{s+=$1} END {print s}')
UNIQ_COMMITS_OLD=$(cat old-commits-counted.txt | wc -l)
UNIQ_COMMITS_OLD_REPEATED=$(cat old-commits-counted.txt | grep -v ' *1 ' | wc -l)
echo Total old commits: $TOTAL_COMMITS_OLD
echo Unique old commits: $UNIQ_COMMITS_OLD
echo Total commits repeated: $TOTAL_COMMITS_OLD_REPEATED
echo Unique repeated commit IDs: $UNIQ_COMMITS_OLD_REPEATED
rm old-output-commits-only.txt old-commits-counted.txt

echo

cat order-output.txt | cut -d']' -f2 | cut -d '[' -f 2 > order-output-commits-only.txt
TOTAL_COMMITS_ORDER=$(cat order-output-commits-only.txt | wc -l)
cat order-output-commits-only.txt | sort | uniq -c | sort -nr > order-commits-counted.txt
TOTAL_COMMITS_ORDER_REPEATED=$(cat order-commits-counted.txt | grep -v ' *1 ' | awk '{s+=$1} END {print s}')
UNIQ_COMMITS_ORDER=$(cat order-commits-counted.txt | wc -l)
UNIQ_COMMITS_ORDER_REPEATED=$(cat order-commits-counted.txt | grep -v ' *1 ' | wc -l)
echo Total order commits: $TOTAL_COMMITS_ORDER
echo Unique order commits: $UNIQ_COMMITS_ORDER
echo Total commits repeated: $TOTAL_COMMITS_ORDER_REPEATED
echo Unique repeated commit IDs: $UNIQ_COMMITS_ORDER_REPEATED
rm order-output-commits-only.txt order-commits-counted.txt
