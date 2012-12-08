#!/bin/bash
if [[ "${1}" == "" ]]; then
	echo -e "No title specified!"
else
	echo -e "Creating new page: ${1}"
	rake page name="${1}"
fi
