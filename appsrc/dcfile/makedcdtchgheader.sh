#!/bin/sh

dictionary="${1}"
outfile="${2}"

echo "// Automatically generated from template - EDITS WILL BE LOST" > "${outfile}"
echo "// Generated by makedcdtchgheader.sh" >> "${outfile}"
echo "static Tag mapDateTagToTimeTag[] = {" >> "${outfile}"
egrep 'VR="(DA)"' "${dictionary}" \
	| grep -v SelectorDAValue \
	| sed -e 's/^.*Keyword="\([^"]*\).*$/\1/' \
	| sed -e 's/Date/Time/' \
	| xargs -L 1 -I % grep 'Keyword="%"' "${dictionary}" \
	| sed -e 's/^.*Keyword="\([^"]*\).*$/\1/' \
	| sed -e 's/^\(.*\)Time\(.*\)$/    TagFromName(\1Date\2), TagFromName(\1Time\2),/' \
	>> "${outfile}"
echo "    0,0 };" >> "${outfile}"

