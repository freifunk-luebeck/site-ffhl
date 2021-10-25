#!/bin/bash
set -e

for manifest in gluon/output/images/sysupgrade/*.manifest; do
	echo "checking ${manifest}..."
	N=$(wc -l < "$manifest")
	echo "manifest is $N lines long"

	if [ "$N" -le 800 ]; then
		echo "$manifest has only $N lines"
		exit 1
	fi
done
