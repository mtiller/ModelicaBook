#!/bin/sh

# Use mathjax-node-page to transform math into HTML
# as a server side step.
echo "Inlining math in $1"
mjpage < $1 | sed '/MathJax\.js/d' > tmp.html
mv tmp.html $1

# TODO: Get rid of script element that loads MathJax scripts
# on loading.  No longer needed.
