#!/usr/bin/env bash

for file in templates/*.html.sh; do
    fname=`basename "$file"`
    fname=${fname%.sh}
    . $file
    templates/header.tmpl.sh >$fname
    echo "$CONTENT" >>$fname
    templates/footer.tmpl.sh >>$fname
done
