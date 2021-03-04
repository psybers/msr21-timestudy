all: project-lists gen-goodbad cache-json gen-dates gen-filteryear-table gen-gitsvn gen-verified gen-logs gen-commit-users gen-commit-proj gen-commit-loc calc-dupes calc-percent-bad

zip:
	zip -r dataset.zip README.md Makefile *.txt *.sh *.pl *.py *.dates *.boa *.ids json-*

project-lists: old-projects.txt future-projects.txt order-projects.txt all-projects.txt

old-projects.txt: old-output.txt
	cat old-output.txt | cut -d']' -f1 | cut -d'[' -f2 | sort | uniq > old-projects.txt

future-projects.txt: future-output.txt
	cat future-output.txt | cut -d']' -f1 | cut -d'[' -f2 | sort | uniq > future-projects.txt

order-projects.txt: order-output.txt
	cat order-output.txt | cut -d']' -f1 | cut -d'[' -f2 | sort | uniq > order-projects.txt

all-projects.txt: old-output.txt future-projects.txt order-projects.txt
	cat old-projects.txt future-projects.txt order-projects.txt | sort | uniq > all-projects.txt

gen-goodbad:
	./test-projects.sh
	./test-projects-sha.sh

cache-json:
	./getjson-gh.sh
	./getjson-sha.sh
	./parents-gh.sh
	./parents-sha.sh
	./cleanup.sh

gen-dates:
	./getdates.sh
	./getdates2.sh
	./dates-all.sh | tee dates-all.txt | cut -d'-' -f1 | sort  -n | uniq -c | tee bad-commits-by-year.txt

gen-filteryear-table:
	./bad-commits-removed-percent.pl

gen-gitsvn:
	./gitsvn.sh

gen-verified:
	./order-gh.sh > order-verified.txt
	./order-sha.sh >> order-verified.txt

gen-logs:
	./logs-old.sh > logs-old.txt
	./logs-order.sh > logs-order.txt

gen-commit-users:
	./order-users.sh | tee commit-users.txt | cut -d' ' -f 2- | cut -d'<' -f 1 | sort | uniq -c | sort -rn

gen-commit-proj:
	./order-projects.sh | sort | uniq -c | sort -rn

gen-commit-loc:
	./count-commits.sh > commit-locations.txt

calc-dupes:
	./duplicate-commits.sh

calc-percent-bad:
	./percent-bad-commits.sh
