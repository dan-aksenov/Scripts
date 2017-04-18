#!/bin/bash

while test $# -gt 0
do
    case "$1" in
        -p1) echo "option 1"
            ;;
        -p2) echo "option 2"
            ;;
        -*) echo "bad option $1"
            ;;
        *) echo "argument $1"
            ;;
    esac
    shift
done

exit 0
