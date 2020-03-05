#!/usr/bin/env bash

stanzas=$(pgbackrest --output=json info | jq .[].name)

echo -n '{"data":['
for stanza in $stanzas; do echo -n "{\"{#STANZA}\": $stanza},"; done |sed -e 's:\},$:\}:'
echo -n ']}'
