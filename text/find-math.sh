#!/bin/sh

find $1 -name '*.html' -exec ./inline-math.sh {} \;
