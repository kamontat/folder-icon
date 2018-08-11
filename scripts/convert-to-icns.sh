#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by v3.0.2
# link (https://github.com/Template-generator/script-genrating/tree/v3.0.2)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

TEMP_FOLDER="/tmp/conv-incs.d/"
mkdir "$TEMP_FOLDER" 2>/dev/null

ext_icns=".icns"

for image in assets/png/*.png; do
	overwrite=false
	fullname="${image##*/}"
	path="${image//$fullname/}"
	icnspath="${path//png/icns}"
	name="${fullname%%.*}"
	icnsname="${name}${ext_icns}"
	printf "Update %20s => %-20s :: " "$fullname" "$icnsname"
	test -f "${icnspath}${icnsname}" && overwrite=true

	if ! sips -z 512 512 "${path}${fullname}" --out "${TEMP_FOLDER}${name}.temp.png" &>/dev/null; then
		echo 'FAILURE(1)'
		break
	fi

	if sips -s format icns "${TEMP_FOLDER}${name}.temp.png" --out "${icnspath}${icnsname}" &>/dev/null; then
		$overwrite &&
			echo 'OVERWRITE' ||
			echo 'COMPLETE'
	else
		echo 'FAILURE(2)'
		break
	fi
done

rm -rf "$TEMP_FOLDER"
