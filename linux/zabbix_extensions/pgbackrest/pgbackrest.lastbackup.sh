#!/usr/bin/env bash
# $1 - stanza name

pgbackrest --stanza=$1 --output=json info | jq .[].backup[-1].timestamp.stop
