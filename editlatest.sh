#!/bin/bash
if [[ ! -f ".latestpost" ]]; then
	echo -e ".latestpost does not exist, try adding a new post"
else
	latestpost=`cat .latestpost`
	echo -e "Opening ${latestpost}"
	subl ${latestpost}
fi
