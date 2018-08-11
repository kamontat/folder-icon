#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by v3.0.2
# link (https://github.com/Template-generator/script-genrating/tree/v3.0.2)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

icns_folder="./assets/icns"

update_icon() {
	local file="$1"

	fullname="${file##*/}"
	path="${file//$fullname/}"
	name="${fullname%%.*}"

	printf "For image \"%s\":  " "$name"
	# -e => If the standard input is coming from a terminal, Readline is used to obtain the line.
	read -re result_path
	result_path="${result_path//\~/$HOME}"

	printf "Update icon of    %-30s with %-30s :: " "$result_path" "${path}${fullname}"
	if ! test -f "$result_path" && ! test -d "$result_path"; then
		echo "FAILURE"
	else
		./bin/seticon "${path}${fullname}" "$result_path"
		echo "COMPLETE"
	fi
}

if test -n "$1"; then
	update_icon "$icns_folder/$1.icns"
else
	for file in $icns_folder/*.icns; do
		update_icon "$file"
	done
fi
