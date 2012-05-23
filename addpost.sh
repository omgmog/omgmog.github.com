#!/bin/bash
if [[ "${1}" == "" ]]; then
	echo -e "No title specified!"
else
	echo -e "Creating new post: ${1}"
	rake post title="${1}"
fi
