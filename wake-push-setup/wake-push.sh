#!/bin/bash
cd `dirname $0`

CURL=/usr/bin/curl
PUSHBULLET_TOKEN=`cat token.txt`
PUSHBULLET_TITLE=Raspberry\ Pi
PUSHBULLET_BODY="発車します"

LANG=ja_JP.utf8

${CURL} --header "Access-Token: ${PUSHBULLET_TOKEN}" \
        --header "Content-Type: application/json" \
        --request POST \
	-f \
        --data-binary "{\"type\": \"note\", \"title\": \"${PUSHBULLET_TITLE}\", \"body\": \"${PUSHBULLET_BODY}\"}" \
        https://api.pushbullet.com/v2/pushes
if [ $? -ne 0 ]; then
	exit 1
fi
echo

